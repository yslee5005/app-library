-- ============================================================
-- handle_new_user 트리거 수정
-- profiles PK가 (id, app_id) 복합키인데 ON CONFLICT (id)만 사용해서 실패
-- ON CONFLICT (id) → ON CONFLICT (id, app_id) 수정
-- ============================================================

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

  -- 공통 profile (PK는 id + app_id 복합키)
  INSERT INTO public.profiles (id, app_id, display_name, email, provider)
  VALUES (
    NEW.id,
    v_app_id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.email, ''),
    COALESCE(NEW.raw_user_meta_data->>'provider', NEW.raw_app_meta_data->>'provider', 'anonymous')
  )
  ON CONFLICT (id, app_id) DO NOTHING;

  -- abba 전용 초기화
  IF v_app_id = 'abba' THEN
    INSERT INTO abba.user_settings (user_id, app_id)
    VALUES (NEW.id, 'abba')
    ON CONFLICT (user_id, app_id) DO NOTHING;

    INSERT INTO abba.notification_settings (user_id, app_id)
    VALUES (NEW.id, 'abba')
    ON CONFLICT (user_id, app_id) DO NOTHING;

    INSERT INTO abba.prayer_streaks (app_id, user_id, current_streak, best_streak)
    VALUES ('abba', NEW.id, 0, 0)
    ON CONFLICT (app_id, user_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, abba;
