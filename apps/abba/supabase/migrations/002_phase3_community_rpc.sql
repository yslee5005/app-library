-- Phase 3: Community enhancements
-- report_count column + RPC functions for atomic counter updates

-- Add report_count and is_hidden to community_posts
ALTER TABLE community_posts ADD COLUMN IF NOT EXISTS report_count INTEGER DEFAULT 0;
ALTER TABLE community_posts ADD COLUMN IF NOT EXISTS is_hidden BOOLEAN DEFAULT false;

-- Reports table
CREATE TABLE IF NOT EXISTS reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  reporter_id UUID NOT NULL REFERENCES auth.users(id),
  target_type TEXT NOT NULL, -- 'post' | 'comment'
  target_id TEXT NOT NULL,
  reason TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY reports_insert ON reports FOR INSERT WITH CHECK (
  auth.uid() = reporter_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY reports_select ON reports FOR SELECT USING (
  COALESCE(app_id, '') = 'abba'
);

-- Update policy for community_posts: owner can update own posts,
-- report_count/is_hidden updates go through SECURITY DEFINER RPC
CREATE POLICY posts_update_owner ON community_posts FOR UPDATE USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);

-- RPC: Increment like count (SECURITY DEFINER to bypass RLS)
CREATE OR REPLACE FUNCTION increment_like_count(p_post_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE community_posts
  SET like_count = like_count + 1
  WHERE id = p_post_id AND app_id = 'abba';
END;
$$;

-- RPC: Decrement like count
CREATE OR REPLACE FUNCTION decrement_like_count(p_post_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE community_posts
  SET like_count = GREATEST(like_count - 1, 0)
  WHERE id = p_post_id AND app_id = 'abba';
END;
$$;

-- RPC: Increment comment count
CREATE OR REPLACE FUNCTION increment_comment_count(p_post_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE community_posts
  SET comment_count = comment_count + 1
  WHERE id = p_post_id AND app_id = 'abba';
END;
$$;

-- RPC: Decrement comment count
CREATE OR REPLACE FUNCTION decrement_comment_count(p_post_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE community_posts
  SET comment_count = GREATEST(comment_count - 1, 0)
  WHERE id = p_post_id AND app_id = 'abba';
END;
$$;

-- User devices table for FCM tokens
CREATE TABLE IF NOT EXISTS user_devices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  fcm_token TEXT NOT NULL,
  platform TEXT NOT NULL, -- 'ios' | 'android'
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, fcm_token)
);

ALTER TABLE user_devices ENABLE ROW LEVEL SECURITY;
CREATE POLICY devices_select ON user_devices FOR SELECT USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY devices_insert ON user_devices FOR INSERT WITH CHECK (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY devices_update ON user_devices FOR UPDATE USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY devices_delete ON user_devices FOR DELETE USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);

-- User notification settings
CREATE TABLE IF NOT EXISTS notification_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  morning_reminder BOOLEAN DEFAULT true,
  morning_time TEXT DEFAULT '06:00',
  evening_reminder BOOLEAN DEFAULT false,
  streak_reminder BOOLEAN DEFAULT true,
  weekly_summary BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(app_id, user_id)
);

ALTER TABLE notification_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY notif_select ON notification_settings FOR SELECT USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY notif_upsert ON notification_settings FOR INSERT WITH CHECK (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY notif_update ON notification_settings FOR UPDATE USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);

-- Milestones tracking
CREATE TABLE IF NOT EXISTS milestones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  milestone_type TEXT NOT NULL, -- 'first_prayer', '7_day_streak', '30_day_streak', '100_prayers'
  achieved_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(app_id, user_id, milestone_type)
);

ALTER TABLE milestones ENABLE ROW LEVEL SECURITY;
CREATE POLICY milestones_select ON milestones FOR SELECT USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY milestones_insert ON milestones FOR INSERT WITH CHECK (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);

-- RPC: Update report count and auto-hide (bypasses owner-only RLS)
CREATE OR REPLACE FUNCTION update_report_count(p_post_id UUID, p_count INTEGER)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE community_posts
  SET report_count = p_count,
      is_hidden = CASE WHEN p_count >= 3 THEN true ELSE is_hidden END
  WHERE id = p_post_id AND app_id = 'abba';
END;
$$;

-- Indexes
CREATE INDEX IF NOT EXISTS idx_devices_user ON user_devices(user_id);
CREATE INDEX IF NOT EXISTS idx_notif_user ON notification_settings(app_id, user_id);
CREATE INDEX IF NOT EXISTS idx_milestones_user ON milestones(app_id, user_id);
CREATE INDEX IF NOT EXISTS idx_reports_target ON reports(target_type, target_id);
