-- ============================================================
-- ABBA 기도/QT 시드 데이터 (TEST ONLY)
-- 유저 UUID: 6ce250dd-c97b-48a6-a538-ad04ae0c6944
-- ============================================================

-- prayers (기도 6개 + QT 4개 = 10개, 최근 2주)
INSERT INTO abba.prayers (
  id, app_id, user_id, transcript, mode, qt_passage_ref,
  duration_seconds, result, created_at, updated_at
) VALUES

-- Prayer 1: 4월 18일 (오늘)
(
  gen_random_uuid(), 'abba', '6ce250dd-c97b-48a6-a538-ad04ae0c6944',
  '주님 감사합니다. 오늘 하루도 은혜로 시작하게 하심에 감사드립니다. 가족들을 지켜주시고 건강하게 해주세요.',
  'prayer', NULL, 360,
  '{
    "prayer_summary": {
      "gratitude": ["새벽에 눈을 뜰 수 있는 은혜에 감사합니다", "가족을 지켜주신 손길에 감사합니다"],
      "petition": ["오늘 하루도 인도해 주세요"],
      "intercession": ["가족들의 건강을 위해 기도합니다"]
    },
    "scripture": {
      "verse_en": "The LORD is my shepherd; I shall not want.",
      "verse_ko": "여호와는 나의 목자시니 내게 부족함이 없으리로다.",
      "reference": "시편 23:1",
      "reason_en": "Your prayer of gratitude echoes the heart of Psalm 23.",
      "reason_ko": "감사의 기도가 시편 23편의 마음과 울려 퍼집니다."
    },
    "bible_story": {
      "title_en": "David the Shepherd King",
      "title_ko": "목자에서 왕이 된 다윗",
      "summary_en": "Before David became king, he was a humble shepherd tending his father''s sheep.",
      "summary_ko": "다윗이 왕이 되기 전, 그는 아버지의 양을 돌보는 겸손한 양치기 소년이었습니다."
    },
    "testimony": {
      "transcript_en": "Lord, thank You for this new morning. Guide my steps today.",
      "transcript_ko": "주님, 새 아침을 주셔서 감사합니다. 오늘 걸음을 인도해 주세요."
    }
  }'::jsonb,
  now() - INTERVAL '2 hours', now() - INTERVAL '2 hours'
),

-- Prayer 2: 4월 17일
(
  gen_random_uuid(), 'abba', '6ce250dd-c97b-48a6-a538-ad04ae0c6944',
  '하나님 아버지, 오늘 직장에서 좋은 결과가 있게 해주세요. 동료들과의 관계도 축복해 주세요.',
  'prayer', NULL, 240,
  '{
    "scripture": {
      "verse_en": "Commit to the LORD whatever you do, and he will establish your plans.",
      "verse_ko": "너의 행사를 여호와께 맡기라 그리하면 네가 경영하는 것이 이루어지리라.",
      "reference": "잠언 16:3",
      "reason_en": "Your prayer for workplace guidance aligns with trusting God with your plans.",
      "reason_ko": "직장에서의 인도를 구하는 기도는 하나님께 계획을 맡기는 것과 같습니다."
    },
    "bible_story": {
      "title_en": "Daniel in the Royal Court",
      "title_ko": "왕궁의 다니엘",
      "summary_en": "Daniel served faithfully in a foreign workplace, trusting God for wisdom.",
      "summary_ko": "다니엘은 이방 땅의 직장에서 하나님의 지혜를 신뢰하며 충성되게 섬겼습니다."
    },
    "testimony": {
      "transcript_en": "Father, bless my work today and my relationships with colleagues.",
      "transcript_ko": "아버지, 오늘 직장과 동료들과의 관계를 축복해 주세요."
    }
  }'::jsonb,
  now() - INTERVAL '1 day 6 hours', now() - INTERVAL '1 day 6 hours'
),

-- QT 1: 4월 16일
(
  gen_random_uuid(), 'abba', '6ce250dd-c97b-48a6-a538-ad04ae0c6944',
  '여호와는 나의 목자시니 내게 부족함이 없으리로다. 이 말씀처럼 주님만 의지하며 살겠습니다.',
  'qt', 'Psalm 23:1-6', 480,
  '{
    "scripture": {
      "verse_en": "The LORD is my shepherd; I shall not want. He makes me lie down in green pastures.",
      "verse_ko": "여호와는 나의 목자시니 내게 부족함이 없으리로다. 그가 나를 푸른 풀밭에 누이시며.",
      "reference": "시편 23:1-2",
      "reason_en": "Your meditation on Psalm 23 reveals a deep trust in God''s provision.",
      "reason_ko": "시편 23편에 대한 묵상이 하나님의 공급하심에 대한 깊은 신뢰를 보여줍니다."
    },
    "bible_story": {
      "title_en": "The Good Shepherd",
      "title_ko": "선한 목자",
      "summary_en": "Jesus declared Himself the Good Shepherd who lays down His life for the sheep.",
      "summary_ko": "예수님은 양을 위해 목숨을 버리는 선한 목자라고 선언하셨습니다."
    },
    "testimony": {
      "transcript_en": "I will trust only in the Lord, as this Word teaches.",
      "transcript_ko": "이 말씀처럼 주님만 의지하며 살겠습니다."
    }
  }'::jsonb,
  now() - INTERVAL '2 days', now() - INTERVAL '2 days'
),

-- Prayer 3: 4월 15일
(
  gen_random_uuid(), 'abba', '6ce250dd-c97b-48a6-a538-ad04ae0c6944',
  '주님, 어머니의 건강을 위해 기도합니다. 수술이 잘 되게 해주시고 빠른 회복을 주세요.',
  'prayer', NULL, 300,
  '{
    "prayer_summary": {
      "gratitude": [],
      "petition": ["어머니의 수술이 잘 되게 해주세요"],
      "intercession": ["어머니의 건강을 위한 중보 기도"]
    },
    "scripture": {
      "verse_en": "He heals the brokenhearted and binds up their wounds.",
      "verse_ko": "그는 마음이 상한 자들을 고치시며 그들의 상처를 싸매시는도다.",
      "reference": "시편 147:3",
      "reason_en": "Your prayer for healing touches God''s heart as the ultimate Healer.",
      "reason_ko": "치유를 위한 기도가 궁극의 치유자이신 하나님의 마음을 감동시킵니다."
    },
    "bible_story": {
      "title_en": "Jesus Heals the Sick",
      "title_ko": "병자를 고치시는 예수님",
      "summary_en": "Jesus healed many who were suffering, showing God''s compassion for the sick.",
      "summary_ko": "예수님은 고통받는 많은 이들을 치유하시며 하나님의 긍휼을 보여주셨습니다."
    },
    "testimony": {
      "transcript_en": "Lord, I pray for my mother''s health and recovery.",
      "transcript_ko": "주님, 어머니의 건강과 회복을 위해 기도합니다."
    }
  }'::jsonb,
  now() - INTERVAL '3 days', now() - INTERVAL '3 days'
),

-- QT 2: 4월 14일
(
  gen_random_uuid(), 'abba', '6ce250dd-c97b-48a6-a538-ad04ae0c6944',
  '하나님, 오늘 말씀을 통해 평안을 주셔서 감사합니다. 염려하지 않고 기도로 아뢰겠습니다.',
  'qt', 'Philippians 4:6-7', 420,
  '{
    "scripture": {
      "verse_en": "Do not be anxious about anything, but in every situation, by prayer and petition, present your requests to God.",
      "verse_ko": "아무 것도 염려하지 말고 다만 모든 일에 기도와 간구로, 너희 구할 것을 감사함으로 하나님께 아뢰라.",
      "reference": "빌립보서 4:6-7",
      "reason_en": "Your meditation connects weariness with hope — exactly what Paul teaches.",
      "reason_ko": "평안과 신뢰에 대한 묵상이 바울의 가르침과 직접 연결됩니다."
    },
    "bible_story": {
      "title_en": "Paul in Prison",
      "title_ko": "감옥에서의 바울",
      "summary_en": "Paul wrote about peace and joy even while imprisoned, demonstrating unshakable faith.",
      "summary_ko": "바울은 감옥에 갇혀 있으면서도 평안과 기쁨에 대해 기록하며 흔들리지 않는 믿음을 보여주었습니다."
    },
    "testimony": {
      "transcript_en": "Thank You for peace through Your Word. I will pray instead of worry.",
      "transcript_ko": "말씀을 통해 평안을 주셔서 감사합니다. 염려 대신 기도하겠습니다."
    }
  }'::jsonb,
  now() - INTERVAL '4 days', now() - INTERVAL '4 days'
),

-- Prayer 4: 4월 13일
(
  gen_random_uuid(), 'abba', '6ce250dd-c97b-48a6-a538-ad04ae0c6944',
  '하나님 아버지, 감사합니다. 오늘도 건강하게 일어나게 하시니 감사합니다. 교회 봉사를 잘 감당하게 해주세요.',
  'prayer', NULL, 300,
  '{
    "scripture": {
      "verse_en": "Each of you should use whatever gift you have received to serve others.",
      "verse_ko": "각각 은사를 받은 대로 하나님의 여러 가지 은혜를 맡은 선한 청지기같이 서로 봉사하라.",
      "reference": "베드로전서 4:10",
      "reason_en": "Your desire to serve well in church reflects the heart of a faithful steward.",
      "reason_ko": "교회에서 잘 봉사하고 싶은 마음이 충성된 청지기의 마음을 반영합니다."
    },
    "bible_story": {
      "title_en": "The Servant Heart of Jesus",
      "title_ko": "섬기는 예수님의 마음",
      "summary_en": "Jesus washed His disciples'' feet, teaching that true greatness comes through serving.",
      "summary_ko": "예수님은 제자들의 발을 씻기시며, 진정한 위대함은 섬김을 통해 온다고 가르치셨습니다."
    },
    "testimony": {
      "transcript_en": "Thank You for health and the opportunity to serve in church.",
      "transcript_ko": "건강과 교회 봉사의 기회를 주셔서 감사합니다."
    }
  }'::jsonb,
  now() - INTERVAL '5 days', now() - INTERVAL '5 days'
),

-- QT 3: 4월 12일
(
  gen_random_uuid(), 'abba', '6ce250dd-c97b-48a6-a538-ad04ae0c6944',
  '오직 여호와를 앙망하는 자는 새 힘을 얻으리니. 주님, 지친 마음에 새 힘을 부어주세요.',
  'qt', 'Isaiah 40:31', 540,
  '{
    "scripture": {
      "verse_en": "But those who hope in the LORD will renew their strength. They will soar on wings like eagles.",
      "verse_ko": "오직 여호와를 앙망하는 자는 새 힘을 얻으리니 독수리가 날개치며 올라감 같을 것이요.",
      "reference": "이사야 40:31",
      "reason_en": "Your meditation connects weariness with hope — exactly what Isaiah promises.",
      "reason_ko": "피곤함과 소망을 연결하는 묵상이 이사야의 약속과 정확히 맞닿아 있습니다."
    },
    "bible_story": {
      "title_en": "Elijah at Mount Horeb",
      "title_ko": "호렙산의 엘리야",
      "summary_en": "After exhaustion and despair, God renewed Elijah''s strength with gentle care.",
      "summary_ko": "탈진과 절망 후에, 하나님은 부드러운 돌봄으로 엘리야의 힘을 새롭게 하셨습니다."
    },
    "testimony": {
      "transcript_en": "Lord, pour new strength into my weary heart.",
      "transcript_ko": "주님, 지친 마음에 새 힘을 부어주세요."
    }
  }'::jsonb,
  now() - INTERVAL '6 days', now() - INTERVAL '6 days'
),

-- Prayer 5: 4월 11일
(
  gen_random_uuid(), 'abba', '6ce250dd-c97b-48a6-a538-ad04ae0c6944',
  '주님, 손주들이 건강하게 자라게 해주세요. 믿음 안에서 성장하도록 인도해 주세요.',
  'prayer', NULL, 240,
  '{
    "scripture": {
      "verse_en": "Train up a child in the way he should go; even when he is old he will not depart from it.",
      "verse_ko": "마땅히 행할 길을 아이에게 가르치라 그리하면 늙어도 그것을 떠나지 아니하리라.",
      "reference": "잠언 22:6",
      "reason_en": "Your prayer for grandchildren''s faith echoes the wisdom of Proverbs.",
      "reason_ko": "손주들의 믿음을 위한 기도가 잠언의 지혜와 울려 퍼집니다."
    },
    "bible_story": {
      "title_en": "Timothy''s Grandmother Lois",
      "title_ko": "디모데의 할머니 로이스",
      "summary_en": "Timothy''s sincere faith was first nurtured by his grandmother Lois and mother Eunice.",
      "summary_ko": "디모데의 진실한 믿음은 할머니 로이스와 어머니 유니게에 의해 처음 길러졌습니다."
    },
    "testimony": {
      "transcript_en": "Lord, guide my grandchildren to grow in health and faith.",
      "transcript_ko": "주님, 손주들이 건강과 믿음 안에서 자라도록 인도해 주세요."
    }
  }'::jsonb,
  now() - INTERVAL '7 days', now() - INTERVAL '7 days'
),

-- Prayer 6: 4월 9일
(
  gen_random_uuid(), 'abba', '6ce250dd-c97b-48a6-a538-ad04ae0c6944',
  '하나님, 우리 교회가 부흥하게 해주세요. 목사님께 지혜를 주시고 성도들이 하나되게 해주세요.',
  'prayer', NULL, 360,
  '{
    "scripture": {
      "verse_en": "How good and pleasant it is when God''s people live together in unity!",
      "verse_ko": "보라 형제가 연합하여 동거함이 어찌 그리 선하고 아름다운고.",
      "reference": "시편 133:1",
      "reason_en": "Your prayer for church unity reflects the psalmist''s vision of harmony.",
      "reason_ko": "교회의 하나됨을 위한 기도가 시편 기자의 화합의 비전을 반영합니다."
    },
    "bible_story": {
      "title_en": "The Early Church in Acts",
      "title_ko": "사도행전의 초대교회",
      "summary_en": "The early believers were united in heart and mind, sharing everything they had.",
      "summary_ko": "초대 교인들은 마음과 뜻이 하나되어 가진 것을 서로 나누었습니다."
    },
    "testimony": {
      "transcript_en": "God, revive our church. Give wisdom to our pastor and unity to the congregation.",
      "transcript_ko": "하나님, 우리 교회를 부흥시켜 주세요."
    }
  }'::jsonb,
  now() - INTERVAL '9 days', now() - INTERVAL '9 days'
),

-- QT 4: 4월 7일
(
  gen_random_uuid(), 'abba', '6ce250dd-c97b-48a6-a538-ad04ae0c6944',
  '너는 마음을 다하여 여호와를 신뢰하고 네 명철을 의지하지 말라. 주님, 내 뜻이 아닌 주의 뜻대로 되게 해주세요.',
  'qt', 'Proverbs 3:5-6', 600,
  '{
    "scripture": {
      "verse_en": "Trust in the LORD with all your heart and lean not on your own understanding.",
      "verse_ko": "너는 마음을 다하여 여호와를 신뢰하고 네 명철을 의지하지 말라.",
      "reference": "잠언 3:5-6",
      "reason_en": "Your meditation embraces the core message — surrendering human wisdom for divine guidance.",
      "reason_ko": "묵상이 핵심 메시지를 품고 있습니다 — 인간의 지혜를 내려놓고 신적 인도를 구하는 것."
    },
    "bible_story": {
      "title_en": "Solomon''s Request for Wisdom",
      "title_ko": "솔로몬의 지혜 구함",
      "summary_en": "When God offered Solomon anything, he chose wisdom over wealth and power.",
      "summary_ko": "하나님이 솔로몬에게 무엇이든 주겠다 하셨을 때, 그는 부와 권력 대신 지혜를 택했습니다."
    },
    "testimony": {
      "transcript_en": "Lord, not my will but Yours be done.",
      "transcript_ko": "주님, 내 뜻이 아닌 주의 뜻대로 되게 해주세요."
    }
  }'::jsonb,
  now() - INTERVAL '11 days', now() - INTERVAL '11 days'
);

-- prayer_streaks 업데이트
UPDATE abba.prayer_streaks
SET current_streak = 5, best_streak = 5, last_prayer_date = CURRENT_DATE, updated_at = now()
WHERE user_id = '6ce250dd-c97b-48a6-a538-ad04ae0c6944' AND app_id = 'abba';

-- ============================================================
-- 완료: prayers 10건 (prayer 6 + qt 4), streak 5일
-- ============================================================
