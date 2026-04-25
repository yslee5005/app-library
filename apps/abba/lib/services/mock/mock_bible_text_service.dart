import '../bible_text_service.dart';

/// Mock BibleTextService for dev/tests. Returns a handful of well-known
/// Public Domain verses inline — no Supabase, no local cache.
class MockBibleTextService implements BibleTextService {
  /// ko = 개역한글 (Public Domain 2012 expired).
  /// en = World English Bible (Public Domain).
  static const Map<String, Map<String, String>> _verses = {
    'ko': {
      'Psalm 23:1': '여호와는 나의 목자시니 내게 부족함이 없으리로다',
      'Psalm 23:2': '그가 나를 푸른 풀밭에 누이시며 쉴 만한 물가로 인도하시는도다',
      'Psalm 23:3': '내 영혼을 소생시키시고 자기 이름을 위하여 의의 길로 인도하시는도다',
      'John 3:16':
          '하나님이 세상을 이처럼 사랑하사 독생자를 주셨으니 이는 저를 믿는 자마다 멸망치 않고 영생을 얻게 하려 하심이니라',
      'Genesis 1:1': '태초에 하나님이 천지를 창조하시니라',
      'Matthew 6:9': '그러므로 너희는 이렇게 기도하라 하늘에 계신 우리 아버지여 이름이 거룩히 여김을 받으시오며',
    },
    'en': {
      'Psalm 23:1': 'Yahweh is my shepherd: I shall lack nothing.',
      'Psalm 23:2':
          'He makes me lie down in green pastures. He leads me beside still waters.',
      'Psalm 23:3':
          'He restores my soul. He guides me in the paths of righteousness for his name\'s sake.',
      'John 3:16':
          'For God so loved the world, that he gave his one and only Son, that whoever believes in him should not perish, but have eternal life.',
      'Genesis 1:1': 'In the beginning, God created the heavens and the earth.',
      'Matthew 6:9':
          'Pray like this: "Our Father in heaven, may your name be kept holy."',
    },
  };

  @override
  bool hasBundleForLocale(String locale) => _verses.containsKey(locale);

  @override
  Map<String, BibleTranslationInfo> attributions() => const {
    'ko': BibleTranslationInfo(name: '개역한글 (KRV)', license: 'Public Domain'),
    'en': BibleTranslationInfo(
      name: 'World English Bible',
      license: 'Public Domain',
    ),
  };

  @override
  Future<void> preload(String locale) async {
    // no-op: in-memory mock has nothing to load
  }

  @override
  Future<String?> lookup(String reference, String locale) async {
    final bundle = _verses[locale];
    if (bundle == null) return null;

    final direct = bundle[reference];
    if (direct != null) return direct;

    // Range support (same as SupabaseStorageBibleTextService).
    final colon = reference.lastIndexOf(':');
    if (colon < 0) return null;
    final bookChapter = reference.substring(0, colon);
    final versePart = reference.substring(colon + 1);
    final dash = versePart.indexOf('-');
    if (dash < 0) return null;

    final start = int.tryParse(versePart.substring(0, dash));
    final end = int.tryParse(versePart.substring(dash + 1));
    if (start == null || end == null || end < start) return null;

    final collected = <String>[];
    for (var v = start; v <= end; v++) {
      final text = bundle['$bookChapter:$v'];
      if (text != null) collected.add(text);
    }
    if (collected.isEmpty) return null;
    return collected.join(' ');
  }
}
