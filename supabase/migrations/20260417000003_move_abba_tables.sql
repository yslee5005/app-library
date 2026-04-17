-- ============================================================
-- public에 있는 abba 전용 테이블 → abba 스키마로 이동
-- 데이터/RLS/인덱스/FK 모두 OID 기반으로 자동 유지
-- ============================================================

-- Step 1: 테이블 이동 (부모 테이블 먼저)
ALTER TABLE public.prayers SET SCHEMA abba;
ALTER TABLE public.qt_passages SET SCHEMA abba;
ALTER TABLE public.prayer_streaks SET SCHEMA abba;
ALTER TABLE public.community_posts SET SCHEMA abba;
ALTER TABLE public.post_comments SET SCHEMA abba;
ALTER TABLE public.post_likes SET SCHEMA abba;
ALTER TABLE public.post_saves SET SCHEMA abba;

-- Step 2: 이동된 테이블 권한 부여 (SET SCHEMA는 GRANT 상속 안 됨)
GRANT ALL ON ALL TABLES IN SCHEMA abba TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA abba TO anon, authenticated, service_role;

-- Step 3: PostgREST 스키마 캐시 리로드
NOTIFY pgrst, 'reload schema';
