-- ============================================================
-- ABBA 커뮤니티 시드 데이터 (TEST ONLY)
-- 개발/테스트 환경 전용. 프로덕션에서는 절대 실행하지 마세요.
--
-- 포함: community_posts, post_comments, post_likes
-- 미포함: prayers, prayer_streaks, milestones, user_settings,
--         notification_settings, qt_passages (유저별 자동 생성)
-- ============================================================

-- FK 제약 및 트리거 비활성화 (auth.users 참조 우회)
SET session_replication_role = 'replica';

-- ============================================================
-- 테스트 유저 UUID 정의
-- ============================================================
-- user_01: 은혜 (named user, Korean)
-- user_02: Grace (named user, English)
-- user_03: anonymous (no display_name)
-- user_04: 찬양하는사람 (named user, Korean)
-- user_05: anonymous (no display_name)
-- user_06: David (named user, English)

-- ============================================================
-- 1. community_posts (10 posts)
-- ============================================================

INSERT INTO abba.community_posts (
  id, app_id, user_id, display_name, avatar_url,
  category, content,
  like_count, comment_count, is_hidden, report_count,
  created_at, updated_at
) VALUES

-- Post 1: 한국어 간증 (7일 전)
(
  'a0000000-0000-0000-0000-000000000001', 'abba',
  '00000000-0000-0000-0000-000000000001', '은혜', NULL,
  'testimony',
  '오늘 새벽기도 중에 정말 놀라운 경험을 했어요. 시편 23편을 묵상하는데 마음 깊은 곳에서 평안이 밀려왔습니다. 요즘 직장 문제로 너무 힘들었는데, 하나님이 나의 목자시라는 말씀이 새롭게 다가왔어요. 기도하시는 모든 분들도 이 평안을 누리시길 바랍니다.',
  0, 0, false, 0,
  now() - INTERVAL '7 days', now() - INTERVAL '7 days'
),

-- Post 2: English testimony (6일 전)
(
  'a0000000-0000-0000-0000-000000000002', 'abba',
  '00000000-0000-0000-0000-000000000002', 'Grace', NULL,
  'testimony',
  'God answered my prayer in such an unexpected way today. I''ve been praying for my mother''s health for 3 months, and today the doctor said her recovery is going remarkably well. Philippians 4:6-7 has been my anchor through this season. Never stop praying, friends!',
  0, 0, false, 0,
  now() - INTERVAL '6 days', now() - INTERVAL '6 days'
),

-- Post 3: 익명 기도요청 (6일 전)
(
  'a0000000-0000-0000-0000-000000000003', 'abba',
  '00000000-0000-0000-0000-000000000003', NULL, NULL,
  'prayer_request',
  '취업 준비 중인데 계속 떨어지고 있습니다. 마음이 너무 힘들고 하나님이 저를 잊으신 건 아닌지 의심이 들 때가 있어요. 기도 부탁드립니다. 하나님의 뜻 안에서 좋은 곳에 갈 수 있도록...',
  0, 0, false, 0,
  now() - INTERVAL '6 days', now() - INTERVAL '6 days'
),

-- Post 4: English prayer request (5일 전)
(
  'a0000000-0000-0000-0000-000000000004', 'abba',
  '00000000-0000-0000-0000-000000000002', 'Grace', NULL,
  'prayer_request',
  'Please pray for my friend who is going through a difficult divorce. She feels alone and hopeless. Pray that God would wrap His arms around her and give her strength. Isaiah 41:10.',
  0, 0, false, 0,
  now() - INTERVAL '5 days', now() - INTERVAL '5 days'
),

-- Post 5: 한국어 간증 (4일 전)
(
  'a0000000-0000-0000-0000-000000000005', 'abba',
  '00000000-0000-0000-0000-000000000004', '찬양하는사람', NULL,
  'testimony',
  '이번 주 QT에서 로마서 8:28을 묵상했는데, "모든 것이 합력하여 선을 이룬다"는 말씀이 정말 위로가 되었습니다. 지난달 사업 실패로 절망적이었는데, 오히려 그것이 가족과 더 가까워지는 계기가 되었어요. 하나님의 계획은 정말 우리와 다르시네요.',
  0, 0, false, 0,
  now() - INTERVAL '4 days', now() - INTERVAL '4 days'
),

-- Post 6: 익명 기도요청 (3일 전)
(
  'a0000000-0000-0000-0000-000000000006', 'abba',
  '00000000-0000-0000-0000-000000000005', NULL, NULL,
  'prayer_request',
  'My marriage is falling apart. We argue every day and I don''t know how to fix it. I know God hates divorce but I''m so tired. Please pray for restoration and wisdom. I want to honor God in this.',
  0, 0, false, 0,
  now() - INTERVAL '3 days', now() - INTERVAL '3 days'
),

-- Post 7: 한국어 간증 (2일 전)
(
  'a0000000-0000-0000-0000-000000000007', 'abba',
  '00000000-0000-0000-0000-000000000001', '은혜', NULL,
  'testimony',
  '기도 30일 연속 달성했어요! 처음엔 새벽에 일어나는 것조차 힘들었는데, 이제는 하루를 기도로 시작하지 않으면 뭔가 빠진 것 같아요. 이 앱 덕분에 습관이 만들어졌습니다. 감사합니다!',
  0, 0, false, 0,
  now() - INTERVAL '2 days', now() - INTERVAL '2 days'
),

-- Post 8: English testimony (2일 전)
(
  'a0000000-0000-0000-0000-000000000008', 'abba',
  '00000000-0000-0000-0000-000000000006', 'David', NULL,
  'testimony',
  'Started using this app a week ago and it has transformed my quiet time. The AI-guided prayer helped me express things I didn''t even know were in my heart. Today during QT on John 15, I felt the Lord''s presence so strongly. Abiding in Him is truly the key.',
  0, 0, false, 0,
  now() - INTERVAL '2 days', now() - INTERVAL '2 days'
),

-- Post 9: 한국어 기도요청 (1일 전)
(
  'a0000000-0000-0000-0000-000000000009', 'abba',
  '00000000-0000-0000-0000-000000000004', '찬양하는사람', NULL,
  'prayer_request',
  '어머니가 수술을 앞두고 계십니다. 큰 수술은 아니지만 연세가 있으셔서 걱정이 됩니다. 수술하시는 의사 선생님의 손에도, 어머니의 회복에도 하나님의 은혜가 함께하시길 기도 부탁드립니다.',
  0, 0, false, 0,
  now() - INTERVAL '1 day', now() - INTERVAL '1 day'
),

-- Post 10: English prayer request (오늘)
(
  'a0000000-0000-0000-0000-000000000010', 'abba',
  '00000000-0000-0000-0000-000000000006', 'David', NULL,
  'prayer_request',
  'Heading into final exams next week. I''m anxious but trying to trust God with the outcome. Proverbs 3:5-6 is my verse for this season. Would appreciate prayers for focus, peace, and wisdom. Thank you, prayer warriors!',
  0, 0, false, 0,
  now(), now()
)

ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 2. post_comments (18 comments)
-- ============================================================

INSERT INTO abba.post_comments (
  id, app_id, post_id, user_id, display_name,
  content, parent_comment_id, like_count,
  created_at, updated_at
) VALUES

-- Comments on Post 1 (은혜's testimony)
(
  'c0000000-0000-0000-0000-000000000001', 'abba',
  'a0000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000002', 'Grace',
  'Amen! Psalm 23 is so powerful. God is our shepherd indeed.',
  NULL, 0,
  now() - INTERVAL '6 days 20 hours', now() - INTERVAL '6 days 20 hours'
),
(
  'c0000000-0000-0000-0000-000000000002', 'abba',
  'a0000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000004', '찬양하는사람',
  '할렐루야! 저도 시편 23편으로 많은 위로를 받았어요. 함께 기도합니다.',
  NULL, 0,
  now() - INTERVAL '6 days 18 hours', now() - INTERVAL '6 days 18 hours'
),
-- Reply to first comment
(
  'c0000000-0000-0000-0000-000000000003', 'abba',
  'a0000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000001', '은혜',
  '감사합니다! 함께 기도해주시니 큰 힘이 됩니다.',
  'c0000000-0000-0000-0000-000000000001', 0,
  now() - INTERVAL '6 days 15 hours', now() - INTERVAL '6 days 15 hours'
),

-- Comments on Post 2 (Grace's testimony)
(
  'c0000000-0000-0000-0000-000000000004', 'abba',
  'a0000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000001', '은혜',
  '정말 감사한 소식이네요! 하나님이 어머니를 치유해주셨군요. 할렐루야!',
  NULL, 0,
  now() - INTERVAL '5 days 22 hours', now() - INTERVAL '5 days 22 hours'
),
(
  'c0000000-0000-0000-0000-000000000005', 'abba',
  'a0000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000006', 'David',
  'Praise the Lord! What a beautiful testimony. God is faithful.',
  NULL, 0,
  now() - INTERVAL '5 days 20 hours', now() - INTERVAL '5 days 20 hours'
),

-- Comments on Post 3 (익명 취업 기도요청)
(
  'c0000000-0000-0000-0000-000000000006', 'abba',
  'a0000000-0000-0000-0000-000000000003',
  '00000000-0000-0000-0000-000000000001', '은혜',
  '힘내세요! 하나님의 때가 있습니다. 이사야 40:31 말씀처럼 여호와를 앙망하는 자는 새 힘을 얻을 거예요. 기도할게요!',
  NULL, 0,
  now() - INTERVAL '5 days 23 hours', now() - INTERVAL '5 days 23 hours'
),
(
  'c0000000-0000-0000-0000-000000000007', 'abba',
  'a0000000-0000-0000-0000-000000000003',
  '00000000-0000-0000-0000-000000000004', '찬양하는사람',
  '저도 취업 준비할 때 정말 힘들었어요. 하나님은 절대 잊지 않으십니다. 함께 기도합니다.',
  NULL, 0,
  now() - INTERVAL '5 days 20 hours', now() - INTERVAL '5 days 20 hours'
),
(
  'c0000000-0000-0000-0000-000000000008', 'abba',
  'a0000000-0000-0000-0000-000000000003',
  '00000000-0000-0000-0000-000000000002', 'Grace',
  'Praying for you! God has a perfect plan. Jeremiah 29:11.',
  NULL, 0,
  now() - INTERVAL '5 days 18 hours', now() - INTERVAL '5 days 18 hours'
),

-- Comments on Post 5 (찬양하는사람 testimony)
(
  'c0000000-0000-0000-0000-000000000009', 'abba',
  'a0000000-0000-0000-0000-000000000005',
  '00000000-0000-0000-0000-000000000003', NULL,
  '아멘. 로마서 8:28 정말 위로가 되는 말씀이죠. 좋은 나눔 감사합니다.',
  NULL, 0,
  now() - INTERVAL '3 days 22 hours', now() - INTERVAL '3 days 22 hours'
),

-- Comments on Post 6 (marriage prayer request)
(
  'c0000000-0000-0000-0000-000000000010', 'abba',
  'a0000000-0000-0000-0000-000000000006',
  '00000000-0000-0000-0000-000000000006', 'David',
  'I''m praying for your marriage. God can restore what feels broken. Don''t give up. Matthew 19:6 — what God has joined together, let no one separate.',
  NULL, 0,
  now() - INTERVAL '2 days 22 hours', now() - INTERVAL '2 days 22 hours'
),
(
  'c0000000-0000-0000-0000-000000000011', 'abba',
  'a0000000-0000-0000-0000-000000000006',
  '00000000-0000-0000-0000-000000000001', '은혜',
  '함께 기도합니다. 부부가 함께 이 앱으로 기도해보시는 건 어떨까요? 기도가 관계를 변화시킵니다.',
  NULL, 0,
  now() - INTERVAL '2 days 20 hours', now() - INTERVAL '2 days 20 hours'
),
-- Reply
(
  'c0000000-0000-0000-0000-000000000012', 'abba',
  'a0000000-0000-0000-0000-000000000006',
  '00000000-0000-0000-0000-000000000005', NULL,
  'Thank you all so much. Your prayers and words mean more than you know.',
  'c0000000-0000-0000-0000-000000000010', 0,
  now() - INTERVAL '2 days 18 hours', now() - INTERVAL '2 days 18 hours'
),

-- Comments on Post 7 (30일 연속 기도)
(
  'c0000000-0000-0000-0000-000000000013', 'abba',
  'a0000000-0000-0000-0000-000000000007',
  '00000000-0000-0000-0000-000000000004', '찬양하는사람',
  '30일 연속이라니 정말 대단해요! 저도 도전해봐야겠어요. 축하합니다!',
  NULL, 0,
  now() - INTERVAL '1 day 22 hours', now() - INTERVAL '1 day 22 hours'
),
(
  'c0000000-0000-0000-0000-000000000014', 'abba',
  'a0000000-0000-0000-0000-000000000007',
  '00000000-0000-0000-0000-000000000006', 'David',
  'That''s amazing! Consistency in prayer is so important. Keep going!',
  NULL, 0,
  now() - INTERVAL '1 day 20 hours', now() - INTERVAL '1 day 20 hours'
),

-- Comments on Post 9 (어머니 수술 기도요청)
(
  'c0000000-0000-0000-0000-000000000015', 'abba',
  'a0000000-0000-0000-0000-000000000009',
  '00000000-0000-0000-0000-000000000001', '은혜',
  '어머니 수술 위해 기도합니다. 하나님이 의사 선생님의 손을 인도하시고 빠른 회복 주시길 기도해요.',
  NULL, 0,
  now() - INTERVAL '20 hours', now() - INTERVAL '20 hours'
),
(
  'c0000000-0000-0000-0000-000000000016', 'abba',
  'a0000000-0000-0000-0000-000000000009',
  '00000000-0000-0000-0000-000000000003', NULL,
  '기도합니다. 평안하시길.',
  NULL, 0,
  now() - INTERVAL '18 hours', now() - INTERVAL '18 hours'
),

-- Comments on Post 10 (David's exam prayer request)
(
  'c0000000-0000-0000-0000-000000000017', 'abba',
  'a0000000-0000-0000-0000-000000000010',
  '00000000-0000-0000-0000-000000000002', 'Grace',
  'Praying for you, David! God gives wisdom generously to all who ask. James 1:5. You''ve got this!',
  NULL, 0,
  now() - INTERVAL '2 hours', now() - INTERVAL '2 hours'
),
(
  'c0000000-0000-0000-0000-000000000018', 'abba',
  'a0000000-0000-0000-0000-000000000010',
  '00000000-0000-0000-0000-000000000004', '찬양하는사람',
  '화이팅! 하나님이 함께하십니다. 기도할게요!',
  NULL, 0,
  now() - INTERVAL '1 hour', now() - INTERVAL '1 hour'
)

ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 3. post_likes (12 likes — spread realistically)
-- ============================================================

INSERT INTO abba.post_likes (
  id, app_id, post_id, user_id, created_at
) VALUES

-- Post 1 (은혜 testimony): 4 likes
('d0000000-0000-0000-0000-000000000001', 'abba', 'a0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', now() - INTERVAL '6 days 21 hours'),
('d0000000-0000-0000-0000-000000000002', 'abba', 'a0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000004', now() - INTERVAL '6 days 19 hours'),
('d0000000-0000-0000-0000-000000000003', 'abba', 'a0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', now() - INTERVAL '6 days 16 hours'),
('d0000000-0000-0000-0000-000000000004', 'abba', 'a0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', now() - INTERVAL '6 days 10 hours'),

-- Post 2 (Grace testimony): 3 likes
('d0000000-0000-0000-0000-000000000005', 'abba', 'a0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', now() - INTERVAL '5 days 23 hours'),
('d0000000-0000-0000-0000-000000000006', 'abba', 'a0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000006', now() - INTERVAL '5 days 21 hours'),
('d0000000-0000-0000-0000-000000000007', 'abba', 'a0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000004', now() - INTERVAL '5 days 19 hours'),

-- Post 3 (익명 취업 기도요청): 2 likes
('d0000000-0000-0000-0000-000000000008', 'abba', 'a0000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001', now() - INTERVAL '5 days 22 hours'),
('d0000000-0000-0000-0000-000000000009', 'abba', 'a0000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000002', now() - INTERVAL '5 days 17 hours'),

-- Post 7 (30일 연속): 3 likes
('d0000000-0000-0000-0000-000000000010', 'abba', 'a0000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000004', now() - INTERVAL '1 day 23 hours'),
('d0000000-0000-0000-0000-000000000011', 'abba', 'a0000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000006', now() - INTERVAL '1 day 21 hours'),
('d0000000-0000-0000-0000-000000000012', 'abba', 'a0000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000002', now() - INTERVAL '1 day 19 hours')

ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 4. 카운터 수동 동기화
-- 트리거가 replica 모드에서 비활성이므로 직접 설정
-- ============================================================

-- like_count 동기화
UPDATE abba.community_posts SET like_count = 4, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000001';
UPDATE abba.community_posts SET like_count = 3, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000002';
UPDATE abba.community_posts SET like_count = 2, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000003';
UPDATE abba.community_posts SET like_count = 3, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000007';

-- comment_count 동기화
UPDATE abba.community_posts SET comment_count = 3, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000001';
UPDATE abba.community_posts SET comment_count = 2, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000002';
UPDATE abba.community_posts SET comment_count = 3, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000003';
UPDATE abba.community_posts SET comment_count = 1, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000005';
UPDATE abba.community_posts SET comment_count = 3, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000006';
UPDATE abba.community_posts SET comment_count = 2, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000007';
UPDATE abba.community_posts SET comment_count = 2, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000009';
UPDATE abba.community_posts SET comment_count = 2, updated_at = updated_at WHERE id = 'a0000000-0000-0000-0000-000000000010';

-- ============================================================
-- 5. FK/트리거 복원
-- ============================================================
SET session_replication_role = 'origin';

-- ============================================================
-- 완료. 시드 데이터 요약:
--   community_posts : 10건 (testimony 5, prayer_request 5)
--   post_comments   : 18건 (2 replies 포함)
--   post_likes      : 12건 (4개 포스트에 분산)
-- ============================================================
