CREATE TABLE IF NOT EXISTS public.user_devices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  fcm_token TEXT NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('ios', 'android')),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (app_id, user_id, fcm_token)
);

ALTER TABLE public.user_devices ENABLE ROW LEVEL SECURITY;
-- Users can read/write their own device tokens
CREATE POLICY "users_own_devices" ON public.user_devices
  FOR ALL USING (user_id = auth.uid());
