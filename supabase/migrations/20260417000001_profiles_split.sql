-- ============================================================
-- 공통/앱전용 테이블 분리 마이그레이션
-- 1) profiles → 공통 auth + abba_user_settings 분리
-- 2) notification_settings → 공통 + abba_notification_settings 분리
-- 기존 데이터 보존, blacklabelled 유저 영향 없음
-- ============================================================

-- Step 1: profiles 테이블에 새 컬럼 추가 (이미 있으면 무시)
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS display_name TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS provider TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS onboarding_completed BOOLEAN DEFAULT false;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT now();

-- Step 2: 기존 name 데이터 → display_name으로 복사
UPDATE profiles SET display_name = name WHERE display_name IS NULL AND name IS NOT NULL;

-- Step 3: abba_user_settings 테이블 생성
CREATE TABLE IF NOT EXISTS abba_user_settings (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  app_id TEXT NOT NULL DEFAULT 'abba',
  total_prayers INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  subscription TEXT DEFAULT 'free',
  locale TEXT DEFAULT 'en',
  voice_preference TEXT DEFAULT 'warm',
  reminder_time TEXT,
  dark_mode BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, app_id)
);

ALTER TABLE abba_user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "abba_settings_select_own" ON abba_user_settings
  FOR SELECT USING (auth.uid() = user_id AND COALESCE(app_id, '') = 'abba');
CREATE POLICY "abba_settings_insert_own" ON abba_user_settings
  FOR INSERT WITH CHECK (auth.uid() = user_id AND COALESCE(app_id, '') = 'abba');
CREATE POLICY "abba_settings_update_own" ON abba_user_settings
  FOR UPDATE USING (auth.uid() = user_id AND COALESCE(app_id, '') = 'abba');

-- Step 4: 기존 abba 도메인 데이터 → abba_user_settings로 이전
INSERT INTO abba_user_settings (user_id, app_id, total_prayers, current_streak,
  best_streak, subscription, locale, voice_preference, reminder_time, dark_mode)
SELECT id, app_id, total_prayers, current_streak, best_streak, subscription,
  locale, voice_preference, reminder_time, dark_mode
FROM profiles
WHERE app_id = 'abba'
ON CONFLICT (user_id, app_id) DO NOTHING;

-- Step 5: profiles에서 abba 전용 컬럼 제거
ALTER TABLE profiles DROP COLUMN IF EXISTS total_prayers;
ALTER TABLE profiles DROP COLUMN IF EXISTS current_streak;
ALTER TABLE profiles DROP COLUMN IF EXISTS best_streak;
ALTER TABLE profiles DROP COLUMN IF EXISTS subscription;
ALTER TABLE profiles DROP COLUMN IF EXISTS locale;
ALTER TABLE profiles DROP COLUMN IF EXISTS voice_preference;
ALTER TABLE profiles DROP COLUMN IF EXISTS reminder_time;
ALTER TABLE profiles DROP COLUMN IF EXISTS dark_mode;

-- Step 6: name 컬럼 제거 (display_name으로 대체)
ALTER TABLE profiles DROP COLUMN IF EXISTS name;

-- Step 7: PK 변경 (id → id + app_id 복합키)
-- 기존 PK 제거 후 복합 PK 추가
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_pkey;
ALTER TABLE profiles ADD PRIMARY KEY (id, app_id);

-- Step 8: RLS 정책 업데이트 (app_id 하드코딩 제거 → 범용)
DROP POLICY IF EXISTS "profiles_select_own" ON profiles;
DROP POLICY IF EXISTS "profiles_insert_own" ON profiles;
DROP POLICY IF EXISTS "profiles_update_own" ON profiles;

CREATE POLICY "profiles_select_own" ON profiles
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "profiles_insert_own" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles_update_own" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Step 9: handle_new_user 트리거 업데이트
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, app_id, display_name, email, provider)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'app_id', NEW.raw_app_meta_data->>'app_id', 'abba'),
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.email, ''),
    COALESCE(NEW.raw_user_meta_data->>'provider', NEW.raw_app_meta_data->>'provider', 'anonymous')
  );

  -- abba 전용 settings (app_id가 abba일 때만)
  IF COALESCE(NEW.raw_user_meta_data->>'app_id', NEW.raw_app_meta_data->>'app_id', 'abba') = 'abba' THEN
    INSERT INTO public.abba_user_settings (user_id, app_id)
    VALUES (NEW.id, 'abba');

    INSERT INTO public.prayer_streaks (app_id, user_id, current_streak, best_streak)
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

-- ============================================================
-- PART 2: notification_settings 공통화 + abba 전용 분리
-- ============================================================

-- Step 10: notification_settings → 공통 필드만 남기기
-- 공통: app_id, user_id, enabled, updated_at
ALTER TABLE notification_settings ADD COLUMN IF NOT EXISTS enabled BOOLEAN DEFAULT true;

-- Step 11: abba_notification_settings 생성
CREATE TABLE IF NOT EXISTS abba_notification_settings (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  app_id TEXT NOT NULL DEFAULT 'abba',
  morning_reminder BOOLEAN DEFAULT true,
  morning_time TEXT DEFAULT '06:00',
  evening_reminder BOOLEAN DEFAULT false,
  streak_reminder BOOLEAN DEFAULT true,
  weekly_summary BOOLEAN DEFAULT true,
  updated_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, app_id)
);

ALTER TABLE abba_notification_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "abba_notif_select_own" ON abba_notification_settings
  FOR SELECT USING (auth.uid() = user_id AND COALESCE(app_id, '') = 'abba');
CREATE POLICY "abba_notif_insert_own" ON abba_notification_settings
  FOR INSERT WITH CHECK (auth.uid() = user_id AND COALESCE(app_id, '') = 'abba');
CREATE POLICY "abba_notif_update_own" ON abba_notification_settings
  FOR UPDATE USING (auth.uid() = user_id AND COALESCE(app_id, '') = 'abba');

-- Step 12: 기존 abba 알림 데이터 이전
INSERT INTO abba_notification_settings (user_id, app_id, morning_reminder,
  morning_time, evening_reminder, streak_reminder, weekly_summary)
SELECT user_id, app_id, morning_reminder, morning_time,
  evening_reminder, streak_reminder, weekly_summary
FROM notification_settings
WHERE app_id = 'abba'
ON CONFLICT (user_id, app_id) DO NOTHING;

-- Step 13: notification_settings에서 abba 전용 컬럼 제거
ALTER TABLE notification_settings DROP COLUMN IF EXISTS morning_reminder;
ALTER TABLE notification_settings DROP COLUMN IF EXISTS morning_time;
ALTER TABLE notification_settings DROP COLUMN IF EXISTS evening_reminder;
ALTER TABLE notification_settings DROP COLUMN IF EXISTS streak_reminder;
ALTER TABLE notification_settings DROP COLUMN IF EXISTS weekly_summary;
