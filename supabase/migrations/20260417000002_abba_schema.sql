-- ============================================================
-- abba 전용 스키마 생성 + public 테이블 이동
-- blacklabelled과 동일한 스키마 분리 패턴 적용
-- ============================================================

-- Step 1: abba 스키마 생성
CREATE SCHEMA IF NOT EXISTS abba;
GRANT USAGE ON SCHEMA abba TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA abba TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA abba
  GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA abba
  GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;

-- Step 2: 기존 public 테이블 → abba 스키마로 이동 + 리네임
-- abba_user_settings → abba.user_settings
ALTER TABLE public.abba_user_settings SET SCHEMA abba;
ALTER TABLE abba.abba_user_settings RENAME TO user_settings;

-- abba_notification_settings → abba.notification_settings
ALTER TABLE public.abba_notification_settings SET SCHEMA abba;
ALTER TABLE abba.abba_notification_settings RENAME TO notification_settings;

-- Step 3: handle_new_user 트리거 업데이트 (abba 스키마 참조)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  v_app_id TEXT;
BEGIN
  v_app_id := COALESCE(
    NEW.raw_user_meta_data->>'app_id',
    NEW.raw_app_meta_data->>'app_id',
    'abba'
  );

  -- 공통 profile (packages/auth)
  INSERT INTO public.profiles (id, app_id, display_name, email, provider)
  VALUES (
    NEW.id,
    v_app_id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.email, ''),
    COALESCE(NEW.raw_user_meta_data->>'provider', NEW.raw_app_meta_data->>'provider', 'anonymous')
  );

  -- abba 전용 (abba 스키마)
  IF v_app_id = 'abba' THEN
    INSERT INTO abba.user_settings (user_id, app_id)
    VALUES (NEW.id, 'abba');

    INSERT INTO abba.prayer_streaks (app_id, user_id, current_streak, best_streak)
    VALUES ('abba', NEW.id, 0, 0)
    ON CONFLICT (app_id, user_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
