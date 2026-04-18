-- ============================================================
-- abba 스키마 테이블 재생성 (보안 강화 버전)
-- 테이블은 Supabase 대시보드에서 수동 삭제 후 실행
-- ============================================================

-- abba 스키마
CREATE SCHEMA IF NOT EXISTS abba;
GRANT USAGE ON SCHEMA abba TO anon, authenticated, service_role;

-- 최소 권한 원칙: anon은 SELECT만, authenticated는 DML, service_role은 ALL
ALTER DEFAULT PRIVILEGES IN SCHEMA abba
  GRANT SELECT ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA abba
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA abba
  GRANT ALL ON TABLES TO service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA abba
  GRANT USAGE, SELECT ON SEQUENCES TO anon, authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA abba
  GRANT ALL ON SEQUENCES TO service_role;

-- ============================================================
-- 1단계: 독립 테이블
-- ============================================================

-- 1-1. prayers (기도/QT 기록)
CREATE TABLE abba.prayers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  transcript TEXT NOT NULL,
  mode TEXT NOT NULL CHECK (mode IN ('prayer', 'qt')),
  qt_passage_ref TEXT,
  duration_seconds INT NOT NULL DEFAULT 0,
  audio_storage_path TEXT,
  result JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_prayers_user_date
  ON abba.prayers (app_id, user_id, created_at DESC);

ALTER TABLE abba.prayers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "prayers_select" ON abba.prayers
  FOR SELECT USING (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "prayers_insert" ON abba.prayers
  FOR INSERT WITH CHECK (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "prayers_update" ON abba.prayers
  FOR UPDATE USING (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "prayers_delete" ON abba.prayers
  FOR DELETE USING (auth.uid() = user_id AND app_id = 'abba');

-- 1-2. prayer_streaks
CREATE TABLE abba.prayer_streaks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  current_streak INT NOT NULL DEFAULT 0,
  best_streak INT NOT NULL DEFAULT 0,
  last_prayer_date DATE,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (app_id, user_id)
);

ALTER TABLE abba.prayer_streaks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "streaks_select" ON abba.prayer_streaks
  FOR SELECT USING (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "streaks_insert" ON abba.prayer_streaks
  FOR INSERT WITH CHECK (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "streaks_update" ON abba.prayer_streaks
  FOR UPDATE USING (auth.uid() = user_id AND app_id = 'abba');

-- 1-3. milestones
CREATE TABLE abba.milestones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  milestone_type TEXT NOT NULL,
  achieved_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (app_id, user_id, milestone_type)
);

ALTER TABLE abba.milestones ENABLE ROW LEVEL SECURITY;

CREATE POLICY "milestones_select" ON abba.milestones
  FOR SELECT USING (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "milestones_insert" ON abba.milestones
  FOR INSERT WITH CHECK (auth.uid() = user_id AND app_id = 'abba');

-- 1-4. qt_passages (Edge Function이 생성하는 공용 콘텐츠)
CREATE TABLE abba.qt_passages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  reference TEXT NOT NULL,
  locale TEXT NOT NULL,
  text TEXT NOT NULL,
  topic TEXT NOT NULL,
  theme TEXT NOT NULL,
  icon TEXT NOT NULL DEFAULT '🌿',
  color_hex TEXT NOT NULL DEFAULT '#B2DFDB',
  date DATE NOT NULL,
  batch_slot TEXT NOT NULL DEFAULT 'morning',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (app_id, date, batch_slot, locale, theme)
);

CREATE INDEX idx_qt_passages_daily
  ON abba.qt_passages (app_id, date, batch_slot, locale);

ALTER TABLE abba.qt_passages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "qt_passages_select" ON abba.qt_passages
  FOR SELECT USING (true);
-- INSERT는 service_role만 (Edge Function) — RLS가 false라도 service_role은 bypass
CREATE POLICY "qt_passages_insert" ON abba.qt_passages
  FOR INSERT WITH CHECK (false);

-- 1-5. user_settings
CREATE TABLE abba.user_settings (
  user_id UUID NOT NULL REFERENCES auth.users(id),
  app_id TEXT NOT NULL DEFAULT 'abba',
  total_prayers INT NOT NULL DEFAULT 0,
  current_streak INT NOT NULL DEFAULT 0,
  best_streak INT NOT NULL DEFAULT 0,
  subscription TEXT NOT NULL DEFAULT 'free' CHECK (subscription IN ('free', 'premium', 'trial')),
  locale TEXT NOT NULL DEFAULT 'en',
  voice_preference TEXT NOT NULL DEFAULT 'warm',
  reminder_time TEXT DEFAULT '06:00',
  dark_mode BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, app_id)
);

ALTER TABLE abba.user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_settings_select" ON abba.user_settings
  FOR SELECT USING (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "user_settings_insert" ON abba.user_settings
  FOR INSERT WITH CHECK (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "user_settings_update" ON abba.user_settings
  FOR UPDATE USING (auth.uid() = user_id AND app_id = 'abba');

-- 1-6. notification_settings
CREATE TABLE abba.notification_settings (
  user_id UUID NOT NULL REFERENCES auth.users(id),
  app_id TEXT NOT NULL DEFAULT 'abba',
  morning_reminder BOOLEAN NOT NULL DEFAULT true,
  morning_time TEXT NOT NULL DEFAULT '06:00',
  evening_reminder BOOLEAN NOT NULL DEFAULT false,
  afternoon_nudge BOOLEAN NOT NULL DEFAULT true,
  streak_reminder BOOLEAN NOT NULL DEFAULT true,
  weekly_summary BOOLEAN NOT NULL DEFAULT true,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, app_id)
);

ALTER TABLE abba.notification_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "notif_select" ON abba.notification_settings
  FOR SELECT USING (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "notif_insert" ON abba.notification_settings
  FOR INSERT WITH CHECK (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "notif_update" ON abba.notification_settings
  FOR UPDATE USING (auth.uid() = user_id AND app_id = 'abba');

-- ============================================================
-- 2단계: community_posts (부모 테이블)
-- ============================================================

CREATE TABLE abba.community_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  display_name TEXT,
  avatar_url TEXT,
  category TEXT NOT NULL CHECK (category IN ('testimony', 'prayer_request')),
  content TEXT NOT NULL,
  like_count INT NOT NULL DEFAULT 0,
  comment_count INT NOT NULL DEFAULT 0,
  is_hidden BOOLEAN NOT NULL DEFAULT false,
  report_count INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_community_posts_feed
  ON abba.community_posts (app_id, is_hidden, created_at DESC);

ALTER TABLE abba.community_posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "posts_select" ON abba.community_posts
  FOR SELECT USING (app_id = 'abba' AND (NOT is_hidden OR auth.uid() = user_id));
CREATE POLICY "posts_insert" ON abba.community_posts
  FOR INSERT WITH CHECK (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "posts_update" ON abba.community_posts
  FOR UPDATE USING (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "posts_delete" ON abba.community_posts
  FOR DELETE USING (auth.uid() = user_id AND app_id = 'abba');

-- ============================================================
-- 3단계: 자식 테이블 (FK → community_posts)
-- ============================================================

-- 3-1. post_comments
CREATE TABLE abba.post_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES abba.community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  content TEXT NOT NULL,
  parent_comment_id UUID REFERENCES abba.post_comments(id) ON DELETE CASCADE,
  like_count INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_post_comments_post
  ON abba.post_comments (post_id, parent_comment_id, created_at);

ALTER TABLE abba.post_comments ENABLE ROW LEVEL SECURITY;

-- 숨겨지지 않은 글의 댓글만 조회 가능
CREATE POLICY "comments_select" ON abba.post_comments
  FOR SELECT USING (
    app_id = 'abba'
    AND EXISTS (
      SELECT 1 FROM abba.community_posts p
      WHERE p.id = post_id AND (NOT p.is_hidden OR p.user_id = auth.uid())
    )
  );
CREATE POLICY "comments_insert" ON abba.post_comments
  FOR INSERT WITH CHECK (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "comments_update" ON abba.post_comments
  FOR UPDATE USING (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "comments_delete" ON abba.post_comments
  FOR DELETE USING (auth.uid() = user_id AND app_id = 'abba');

-- 3-2. post_likes
CREATE TABLE abba.post_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES abba.community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (post_id, user_id)
);

ALTER TABLE abba.post_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "post_likes_select" ON abba.post_likes
  FOR SELECT USING (app_id = 'abba');
CREATE POLICY "post_likes_insert" ON abba.post_likes
  FOR INSERT WITH CHECK (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "post_likes_delete" ON abba.post_likes
  FOR DELETE USING (auth.uid() = user_id AND app_id = 'abba');

-- 3-3. comment_likes
CREATE TABLE abba.comment_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  comment_id UUID NOT NULL REFERENCES abba.post_comments(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (comment_id, user_id)
);

ALTER TABLE abba.comment_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "comment_likes_select" ON abba.comment_likes
  FOR SELECT USING (app_id = 'abba');
CREATE POLICY "comment_likes_insert" ON abba.comment_likes
  FOR INSERT WITH CHECK (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "comment_likes_delete" ON abba.comment_likes
  FOR DELETE USING (auth.uid() = user_id AND app_id = 'abba');

-- 3-4. post_saves
CREATE TABLE abba.post_saves (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES abba.community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (post_id, user_id)
);

ALTER TABLE abba.post_saves ENABLE ROW LEVEL SECURITY;

CREATE POLICY "saves_select" ON abba.post_saves
  FOR SELECT USING (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "saves_insert" ON abba.post_saves
  FOR INSERT WITH CHECK (auth.uid() = user_id AND app_id = 'abba');
CREATE POLICY "saves_delete" ON abba.post_saves
  FOR DELETE USING (auth.uid() = user_id AND app_id = 'abba');

-- 3-5. reports
CREATE TABLE abba.reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  reporter_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  target_type TEXT NOT NULL CHECK (target_type IN ('post', 'comment')),
  target_id UUID NOT NULL,
  reason TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (app_id, reporter_id, target_type, target_id)
);

-- target_id 유효성 검증: 존재하지 않는 post/comment 신고 방지
CREATE OR REPLACE FUNCTION abba.validate_report_target()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.target_type = 'post' THEN
    IF NOT EXISTS (SELECT 1 FROM abba.community_posts WHERE id = NEW.target_id) THEN
      RAISE EXCEPTION 'Target post does not exist: %', NEW.target_id;
    END IF;
  ELSIF NEW.target_type = 'comment' THEN
    IF NOT EXISTS (SELECT 1 FROM abba.post_comments WHERE id = NEW.target_id) THEN
      RAISE EXCEPTION 'Target comment does not exist: %', NEW.target_id;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = abba, public;

CREATE TRIGGER trg_validate_report_target
  BEFORE INSERT ON abba.reports
  FOR EACH ROW EXECUTE FUNCTION abba.validate_report_target();

REVOKE EXECUTE ON FUNCTION abba.validate_report_target() FROM PUBLIC;

ALTER TABLE abba.reports ENABLE ROW LEVEL SECURITY;

CREATE POLICY "reports_insert" ON abba.reports
  FOR INSERT WITH CHECK (auth.uid() = reporter_id AND app_id = 'abba');
CREATE POLICY "reports_select" ON abba.reports
  FOR SELECT USING (auth.uid() = reporter_id AND app_id = 'abba');

-- ============================================================
-- 4단계: 카운터 자동 동기화 트리거 (RPC 제거 → 트리거로 교체)
-- ============================================================

-- 4-1. post_likes → community_posts.like_count 자동 동기화
CREATE OR REPLACE FUNCTION abba.sync_post_like_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE abba.community_posts
    SET like_count = like_count + 1, updated_at = now()
    WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE abba.community_posts
    SET like_count = GREATEST(like_count - 1, 0), updated_at = now()
    WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = abba, public;

CREATE TRIGGER trg_post_likes_sync
  AFTER INSERT OR DELETE ON abba.post_likes
  FOR EACH ROW EXECUTE FUNCTION abba.sync_post_like_count();

-- 4-2. post_comments → community_posts.comment_count 자동 동기화
CREATE OR REPLACE FUNCTION abba.sync_comment_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE abba.community_posts
    SET comment_count = comment_count + 1, updated_at = now()
    WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE abba.community_posts
    SET comment_count = GREATEST(comment_count - 1, 0), updated_at = now()
    WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = abba, public;

CREATE TRIGGER trg_comments_sync
  AFTER INSERT OR DELETE ON abba.post_comments
  FOR EACH ROW EXECUTE FUNCTION abba.sync_comment_count();

-- 4-3. comment_likes → post_comments.like_count 자동 동기화
CREATE OR REPLACE FUNCTION abba.sync_comment_like_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE abba.post_comments
    SET like_count = like_count + 1, updated_at = now()
    WHERE id = NEW.comment_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE abba.post_comments
    SET like_count = GREATEST(like_count - 1, 0), updated_at = now()
    WHERE id = OLD.comment_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = abba, public;

CREATE TRIGGER trg_comment_likes_sync
  AFTER INSERT OR DELETE ON abba.comment_likes
  FOR EACH ROW EXECUTE FUNCTION abba.sync_comment_like_count();

-- 4-4. reports → community_posts.report_count 자동 동기화 + 3건 이상 자동 숨김
CREATE OR REPLACE FUNCTION abba.sync_report_count()
RETURNS TRIGGER AS $$
DECLARE
  v_target UUID;
  cnt INT;
BEGIN
  v_target := COALESCE(NEW.target_id, OLD.target_id);

  IF COALESCE(NEW.target_type, OLD.target_type) = 'post' THEN
    SELECT COUNT(*) INTO cnt
    FROM abba.reports
    WHERE target_type = 'post' AND target_id = v_target AND app_id = 'abba';

    UPDATE abba.community_posts
    SET report_count = cnt,
        is_hidden = (cnt >= 3),
        updated_at = now()
    WHERE id = v_target AND app_id = 'abba';
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = abba, public;

CREATE TRIGGER trg_reports_sync
  AFTER INSERT OR DELETE ON abba.reports
  FOR EACH ROW EXECUTE FUNCTION abba.sync_report_count();

-- 트리거 함수는 직접 호출 불가하므로 PUBLIC 실행 권한 명시적 제거
REVOKE EXECUTE ON FUNCTION abba.sync_post_like_count() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION abba.sync_comment_count() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION abba.sync_comment_like_count() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION abba.sync_report_count() FROM PUBLIC;

-- ============================================================
-- 5단계: handle_new_user 트리거
-- ⚠️ 주의: 이 함수는 public 전역 트리거입니다.
-- CREATE OR REPLACE로 기존 함수를 덮어씁니다.
-- 다른 앱(blacklabelled 등) 추가 시 이 함수에 분기를 추가해야 합니다.
-- 앱별 독립 트리거로 분리하는 것은 Phase 2에서 검토.
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

  -- 공통 profile (모든 앱 공유)
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

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- 6단계: PostgREST 스키마 캐시 리로드
-- ============================================================
NOTIFY pgrst, 'reload schema';
