/// 아기의 편지 — 주차별 1인칭 메시지
/// 과학적 발달 근거 기반, 감성적 스토리텔링
class BabyLetter {
  final String weekKey; // "week_8", "d_7" 등
  final String title;
  final String message;
  final String scientificBasis;
  final String source;
  final String emoji;

  const BabyLetter({
    required this.weekKey,
    required this.title,
    required this.message,
    required this.scientificBasis,
    required this.source,
    this.emoji = '💌',
  });
}

/// 임신 중 편지 (주차별)
const pregnancyLetters = <BabyLetter>[
  BabyLetter(
    weekKey: 'week_8',
    title: '심장이 뛰기 시작했어!',
    message:
        '엄마, 나 심장이 뛰기 시작했어!\n분당 170번이야. 엄마보다 2배 빠르지?\n아직 엄마 새끼손가락보다 작지만,\n나만의 리듬이 생겼어.',
    scientificBasis: '8주: 심장 4개 방 형성 완료, 분당 150-170회 박동',
    source: 'Moore KL, The Developing Human, 2019',
    emoji: '💓',
  ),
  BabyLetter(
    weekKey: 'week_10',
    title: '손가락이 생겼어!',
    message:
        '엄마, 나 손가락이 10개 다 생겼어!\n아직 물갈퀴 같은 게 있었는데\n이제 하나하나 나눠졌어.\n곧 뭔가 잡을 수 있을 거야!',
    scientificBasis: '10주: 지간막(물갈퀴) 퇴화, 개별 손가락 분리 완료',
    source: 'Carnegie Stage 23',
    emoji: '✋',
  ),
  BabyLetter(
    weekKey: 'week_12',
    title: '하품하는 법을 배웠어!',
    message:
        '엄마, 나 하품하는 법을 배웠어!\n입을 크~~게 벌린다 😊\n왜 하품을 하는지는 나도 모르겠는데\n뭔가 편안해져.',
    scientificBasis: '12주: 하품 반사 시작, 얼굴 근육 발달',
    source: 'Reissland et al., PLOS ONE, 2012',
    emoji: '🥱',
  ),
  BabyLetter(
    weekKey: 'week_14',
    title: '표정을 지을 수 있어!',
    message:
        '엄마, 이제 얼굴을 찡그리기도 하고\n웃는 것 같은 표정도 지어!\n아직 감정은 아니래. 근육 연습이야.\n근데 나는 기분이 좋아 😊',
    scientificBasis: '14주: 안면 근육 발달, 무의식적 표정 움직임 시작',
    source: 'Reissland et al., PLOS ONE, 2011',
    emoji: '😊',
  ),
  BabyLetter(
    weekKey: 'week_16',
    title: '빛이 보여!',
    message:
        '엄마, 빛이 보여!\n엄마 배 위에 손전등 비추면\n내가 움직일 거야.\n아직 눈은 감고 있지만\n밝고 어두운 건 알 수 있어.',
    scientificBasis: '16주: 망막 광수용체 발달, 강한 빛에 반응',
    source: 'Khan et al., Semin Fetal Neonatal Med, 2004',
    emoji: '💡',
  ),
  BabyLetter(
    weekKey: 'week_18',
    title: '엄마 배 속에서 놀고 있어!',
    message:
        '엄마, 나 요즘 많이 움직여!\n발차기도 하고, 구르기도 하고.\n엄마가 느끼기엔 아직 작은 느낌이겠지만\n나는 열심히 운동 중이야 💪',
    scientificBasis: '18주: 태동 시작기, 초산모 18-20주에 첫 인지',
    source: 'ACOG Practice Bulletin, 2021',
    emoji: '🤸',
  ),
  BabyLetter(
    weekKey: 'week_20',
    title: '엄마 목소리가 들려!',
    message:
        '엄마, 엄마 목소리가 들려!\n낮은 음이 제일 좋아.\n아빠 목소리도 들리는데\n엄마 목소리가 제일 편해.\n계속 말해줘 🎵',
    scientificBasis: '20주: 달팽이관 발달 완성기, 외부 소리 인지 시작',
    source: 'DeCasper & Fifer, Science, 1980',
    emoji: '👂',
  ),
  BabyLetter(
    weekKey: 'week_22',
    title: '만져지는 게 느껴져!',
    message:
        '엄마, 엄마가 배를 만지면\n나도 느낄 수 있어!\n따뜻하고 포근해.\n엄마 손이 가까이 오면\n나도 그쪽으로 가고 싶어져.',
    scientificBasis: '22주: 촉각 수용체 전신 분포, 복벽 접촉에 반응',
    source: 'Marx & Nagy, PLOS ONE, 2015',
    emoji: '🫳',
  ),
  BabyLetter(
    weekKey: 'week_24',
    title: '눈을 떴어!',
    message:
        '엄마, 오늘 내 눈꺼풀이 조금 열렸어!\n빛이 아주 조금 보이는 것 같아.\n엄마 배 위에 손전등 비추면\n내가 고개를 돌린대!\n\n그리고 요즘 꿈을 꾸기 시작했어.\nREM 수면이 생겼거든! 🌙',
    scientificBasis: '24주: 안검열(눈꺼풀 분리) 형성, REM sleep onset, 빛 반응',
    source: 'Khan et al., 2004; Birnholz, 1981',
    emoji: '👁️',
  ),
  BabyLetter(
    weekKey: 'week_26',
    title: '엄마가 먹는 게 느껴져!',
    message: '엄마, 엄마가 먹는 맛이\n양수를 통해 전해져!\n단 맛이 제일 좋고\n쓴 맛은 좀 싫어.\n오늘 뭐 먹었어? 🍓',
    scientificBasis: '26주: 미뢰 발달 완성, 양수 속 맛 분자 감지',
    source: 'Mennella et al., Pediatrics, 2001',
    emoji: '🍓',
  ),
  BabyLetter(
    weekKey: 'week_28',
    title: '눈을 깜빡여!',
    message:
        '엄마, 이제 눈을 깜빡일 수 있어!\n빛이 들어오면 눈을 감기도 해.\n세상이 어떻게 생겼을지 궁금해.\n엄마 얼굴이 제일 보고 싶어 💛',
    scientificBasis: '28주: 순목반사(blink reflex) 형성, 동공 빛 반사',
    source: 'Moore KL, 2019',
    emoji: '😊',
  ),
  BabyLetter(
    weekKey: 'week_30',
    title: '기억을 할 수 있어!',
    message:
        '엄마, 이제 소리를 기억할 수 있어!\n엄마가 자주 부르는 노래,\n아빠가 읽어주는 동화책.\n태어나서도 기억할 거야.\n계속 들려줘! 📖',
    scientificBasis: '30주: 장기 기억 형성 시작, 출생 후 익숙한 소리에 선호 반응',
    source: 'DeCasper & Spence, Infant Behavior & Development, 1986',
    emoji: '📖',
  ),
  BabyLetter(
    weekKey: 'week_32',
    title: '머리를 아래로 돌렸어!',
    message:
        '엄마, 나 머리를 아래로 돌렸어.\n만날 준비하고 있어!\n여기가 좀 좁아지긴 했는데\n그만큼 내가 많이 컸다는 거야.',
    scientificBasis: '32주: 대부분 두위(머리 아래) 전환, 태아 성장 가속기',
    source: 'ACOG, 2021',
    emoji: '🔄',
  ),
  BabyLetter(
    weekKey: 'week_34',
    title: '폐가 거의 완성됐어!',
    message:
        '엄마, 내 폐가 거의 다 됐어.\n표면활성제라는 게 만들어지고 있어.\n이게 있어야 밖에서 숨을 쉴 수 있대.\n조금만 더 기다려줘!',
    scientificBasis: '34주: 폐 표면활성제(surfactant) 생산 증가',
    source: 'Jobe & Ikegami, AJRCCM, 2001',
    emoji: '🫁',
  ),
  BabyLetter(
    weekKey: 'week_36',
    title: '거의 다 됐어!',
    message:
        '엄마, 이제 거의 다 됐어.\n폐가 완성됐고, 피하지방도 충분해.\n밖에서도 체온을 유지할 수 있어.\n만날 날이 얼마 안 남았어! 💛',
    scientificBasis: '36주: 폐 성숙 완료, 피하지방 축적, 체온조절 능력',
    source: 'Moore KL, 2019',
    emoji: '🌟',
  ),
  BabyLetter(
    weekKey: 'week_38',
    title: '준비 완료!',
    message:
        '엄마, 나 준비 다 됐어!\n머리카락도 났고, 손톱도 자랐어.\n엄마를 만나면 제일 먼저\n엄마 심장소리를 들을 거야.\n그게 나한테 제일 익숙한 소리거든.',
    scientificBasis: '38주: 만삭 준비 완료, 모든 장기 기능 성숙',
    source: 'ACOG, 2021',
    emoji: '🎀',
  ),
  BabyLetter(
    weekKey: 'week_40',
    title: '드디어 만나!',
    message:
        '엄마, 드디어 만나!\n내가 울면 바로 안아줘.\n그게 나한테 제일 필요한 거야.\n\n엄마 품이 세상에서 제일 안전한 곳이야.\n사랑해 💛',
    scientificBasis: '40주: 출산, 피부 접촉(skin-to-skin)의 중요성',
    source: 'WHO Recommendations, 2018',
    emoji: '👶',
  ),
];

/// 출산 후 편지 (일별/주차별)
const postnatalLetters = <BabyLetter>[
  BabyLetter(
    weekKey: 'd_1',
    title: '세상이 너무 밝아!',
    message:
        '엄마, 밖이 너무 밝고 시끄러워.\n엄마 심장소리가 제일 편해.\n안아줄 때 듣는 엄마 심장소리는\n내가 9개월 동안 들었던 그 소리야.',
    scientificBasis: '신생아: 자궁 내 환경과의 급격한 변화, 감각 과부하',
    source: 'Karp, The Happiest Baby, 2015',
    emoji: '🌍',
  ),
  BabyLetter(
    weekKey: 'd_7',
    title: '엄마 얼굴이 보여!',
    message:
        '엄마, 20-25cm 거리에서 얼굴이 보여!\n수유할 때 딱 그 거리야.\n아직 흐릿하지만\n엄마 눈, 코, 입은 알 수 있어.\n제일 좋아하는 풍경이야 💛',
    scientificBasis: '신생아 시력: 20-25cm 초점, 고대비 패턴 선호, 얼굴 선호',
    source: 'Farroni et al., PNAS, 2005',
    emoji: '👀',
  ),
  BabyLetter(
    weekKey: 'd_14',
    title: '엄마 냄새가 제일 좋아!',
    message:
        '엄마, 엄마 냄새가 제일 좋아.\n수유할 때 나는 냄새,\n엄마 피부 냄새.\n다른 사람이 안아줘도\n엄마인지 아닌지 알 수 있어!',
    scientificBasis: '생후 2주: 엄마의 체취/모유 냄새 인식, 안정감 증가',
    source: 'Porter & Winberg, Neuroscience & Biobehavioral Reviews, 1999',
    emoji: '🌸',
  ),
  BabyLetter(
    weekKey: 'd_30',
    title: '우리 첫 대화를 하자!',
    message:
        '엄마, 내가 "아~" 하면 대답해줘.\n그게 우리의 첫 대화야!\n엄마가 대답해주면\n내 뇌에 연결이 하나 만들어져.\n매번 대답해줄수록 내 뇌가 자라! 🗣️',
    scientificBasis: 'Serve & Return: 반응적 양육이 시냅스 형성 촉진',
    source: 'Harvard Center on the Developing Child, 2016',
    emoji: '🗣️',
  ),
  BabyLetter(
    weekKey: 'd_45',
    title: '사회적 미소가 시작됐어!',
    message:
        '엄마, 이제 엄마를 보고 진짜 웃어!\n전에는 반사 미소였는데\n이제는 엄마 얼굴을 알아보고 웃는 거야.\n엄마가 웃으면 나도 웃어.\n우리 서로 웃자! 😊',
    scientificBasis: '6-8주: 사회적 미소(social smile) 시작, 의도적 미소 구분',
    source: 'Messinger et al., Infancy, 2001',
    emoji: '😊',
  ),
  BabyLetter(
    weekKey: 'd_60',
    title: '엄마 표정을 따라해봤어!',
    message:
        '엄마, 엄마 표정을 따라해봤어!\n엄마가 입을 벌리면 나도 벌리고,\n혀를 내밀면 나도 내밀어.\n이게 미러 뉴런이래!\n우리 뇌가 연결된 거야.',
    scientificBasis: '2개월: 표정 모방 능력, 미러 뉴런 시스템 활성화',
    source: 'Meltzoff & Moore, Science, 1977',
    emoji: '🪞',
  ),
  BabyLetter(
    weekKey: 'd_90',
    title: '손으로 잡을 수 있어!',
    message:
        '엄마, 손으로 뭔가 잡을 수 있어!\n엄마 손가락이 제일 좋아.\n전에는 반사적으로 잡았는데\n이제는 내가 잡고 싶어서 잡는 거야.\n놓지 않을게 💛',
    scientificBasis: '3개월: 파악반사→의도적 잡기 전환, 대상 영속성 발달 시작',
    source: 'Piaget, 1954; CDC Milestone Tracker',
    emoji: '🤝',
  ),
  BabyLetter(
    weekKey: 'd_120',
    title: '뒤집기 성공!',
    message:
        '엄마, 나 뒤집었어!\n세상이 다르게 보여!\n천장만 보다가 바닥을 보니까 신기해.\n엄마가 놀라는 표정도 좋았어 😄',
    scientificBasis: '4개월: 엎드려 뒤집기 시작, 대근육 발달 마일스톤',
    source: 'WHO Motor Development Study, 2006',
    emoji: '🔄',
  ),
  BabyLetter(
    weekKey: 'd_180',
    title: '이유식이 궁금해!',
    message:
        '엄마, 엄마가 먹는 게 너무 궁금해!\n침도 많이 나오고, 손도 입에 넣고.\n나도 먹어보고 싶어!\n근데 처음엔 이상한 표정 지을 수도 있어 😝',
    scientificBasis: '6개월: 이유식 시작 권장, 혀 내밀기 반사 소실, 앉기 가능',
    source: 'WHO/AAP Guidelines, 2023',
    emoji: '🥄',
  ),
  BabyLetter(
    weekKey: 'd_270',
    title: '엄마를 찾아!',
    message:
        '엄마, 엄마가 안 보이면 불안해.\n까꿍 놀이가 좋은 건\n엄마가 사라져도 다시 나타난다는 걸\n배울 수 있어서야.\n많이 해줘! 까꿍! 🫣',
    scientificBasis: '9개월: 분리불안 시작, 대상 영속성 인지',
    source: 'Bowlby, Attachment Theory, 1969',
    emoji: '🫣',
  ),
  BabyLetter(
    weekKey: 'd_365',
    title: '첫 번째 생일!',
    message:
        '엄마, 1년이 됐어!\n이 1년 동안 엄마 덕분에\n이만큼 자랐어.\n\n엄마가 울 때 와주고,\n웃을 때 같이 웃어주고,\n밤에 일어나서 안아주고.\n\n그 모든 순간이\n나를 만들었어.\n사랑해, 엄마 💛',
    scientificBasis: '12개월: 1년간의 폭발적 성장, 안정 애착 형성 결정기',
    source: 'Ainsworth, Strange Situation, 1978',
    emoji: '🎂',
  ),
];

/// 주차/일수로 편지 찾기
BabyLetter? findLetterForWeek(int week) {
  final key = 'week_$week';
  return pregnancyLetters.cast<BabyLetter?>().firstWhere(
    (l) => l?.weekKey == key,
    orElse: () => null,
  );
}

BabyLetter? findLetterForDay(int day) {
  // 가장 가까운 이전 편지 찾기
  BabyLetter? closest;
  for (final letter in postnatalLetters) {
    final letterDay = int.parse(letter.weekKey.substring(2));
    if (letterDay <= day) {
      closest = letter;
    }
  }
  return closest;
}
