CREATE TABLE IF NOT EXISTS public.notification_settings (
  app_id TEXT NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  morning_reminder BOOLEAN DEFAULT true,
  morning_time TEXT DEFAULT '06:00',
  evening_reminder BOOLEAN DEFAULT false,
  streak_reminder BOOLEAN DEFAULT true,
  weekly_summary BOOLEAN DEFAULT true,
  updated_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (app_id, user_id)
);

ALTER TABLE public.notification_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "users_own_settings" ON public.notification_settings
  FOR ALL USING (user_id = auth.uid());
