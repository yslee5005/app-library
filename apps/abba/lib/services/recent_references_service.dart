import 'package:supabase_flutter/supabase_flutter.dart';

/// Maps localized Bible book names → English canonical book name.
/// Currently covers Korean (the only locale we've observed leaking
/// localized refs into DB; see learned-pitfalls §2-1, scripture v7).
/// Returns the input unchanged if no prefix matches.
String canonicalizeReference(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return trimmed;
  for (final entry in _koreanBookMap.entries) {
    if (trimmed.startsWith(entry.key)) {
      final rest = trimmed.substring(entry.key.length).trimLeft();
      return rest.isEmpty ? entry.value : '${entry.value} $rest';
    }
  }
  return trimmed;
}

/// Returns "Book Chapter" key from a canonicalized reference.
/// Used to dedup ranges/single-verses within the same chapter.
/// e.g., "Psalm 4:8" → "Psalm 4", "1 Corinthians 13:4-7" → "1 Corinthians 13".
/// Returns the input unchanged when no `:` is present.
String chapterKeyOf(String canonical) {
  final colon = canonical.lastIndexOf(':');
  if (colon < 0) return canonical;
  return canonical.substring(0, colon);
}

const Map<String, String> _koreanBookMap = {
  // OT
  '창세기': 'Genesis',
  '출애굽기': 'Exodus',
  '레위기': 'Leviticus',
  '민수기': 'Numbers',
  '신명기': 'Deuteronomy',
  '여호수아': 'Joshua',
  '사사기': 'Judges',
  '룻기': 'Ruth',
  '사무엘상': '1 Samuel',
  '사무엘하': '2 Samuel',
  '열왕기상': '1 Kings',
  '열왕기하': '2 Kings',
  '역대상': '1 Chronicles',
  '역대하': '2 Chronicles',
  '에스라': 'Ezra',
  '느헤미야': 'Nehemiah',
  '에스더': 'Esther',
  '욥기': 'Job',
  '시편': 'Psalm',
  '잠언': 'Proverbs',
  '전도서': 'Ecclesiastes',
  '아가': 'Song of Solomon',
  '이사야': 'Isaiah',
  '예레미야애가': 'Lamentations', // longer prefix MUST come before 예레미야
  '예레미야': 'Jeremiah',
  '에스겔': 'Ezekiel',
  '다니엘': 'Daniel',
  '호세아': 'Hosea',
  '요엘': 'Joel',
  '아모스': 'Amos',
  '오바댜': 'Obadiah',
  '요나': 'Jonah',
  '미가': 'Micah',
  '나훔': 'Nahum',
  '하박국': 'Habakkuk',
  '스바냐': 'Zephaniah',
  '학개': 'Haggai',
  '스가랴': 'Zechariah',
  '말라기': 'Malachi',
  // NT
  '마태복음': 'Matthew',
  '마가복음': 'Mark',
  '누가복음': 'Luke',
  '요한복음': 'John',
  '사도행전': 'Acts',
  '로마서': 'Romans',
  '고린도전서': '1 Corinthians',
  '고린도후서': '2 Corinthians',
  '갈라디아서': 'Galatians',
  '에베소서': 'Ephesians',
  '빌립보서': 'Philippians',
  '골로새서': 'Colossians',
  '데살로니가전서': '1 Thessalonians',
  '데살로니가후서': '2 Thessalonians',
  '디모데전서': '1 Timothy',
  '디모데후서': '2 Timothy',
  '디도서': 'Titus',
  '빌레몬서': 'Philemon',
  '히브리서': 'Hebrews',
  '야고보서': 'James',
  '베드로전서': '1 Peter',
  '베드로후서': '2 Peter',
  '요한일서': '1 John',
  '요한이서': '2 John',
  '요한삼서': '3 John',
  '유다서': 'Jude',
  '요한계시록': 'Revelation',
};

/// Reads the user's last-30-day chosen scripture references from
/// `abba.prayers.result->scripture->>reference` and returns a chapter-deduped,
/// canonicalized list (newest first) for injection into the T1 prompt.
///
/// Wired with a hard timeout — if the Supabase query is slow or unreachable,
/// returns an empty list. T1 must NEVER block on this.
class RecentReferencesService {
  RecentReferencesService({
    required SupabaseClient client,
    String appId = 'abba',
  }) : _client = client,
       _appId = appId;

  /// Used by [NoopRecentReferencesService] which never reaches the
  /// network call and overrides [getRecentReferences] entirely.
  RecentReferencesService._noClient()
    : _client = null,
      _appId = 'abba';

  final SupabaseClient? _client;
  final String _appId;

  Future<List<String>> getRecentReferences({
    required String userId,
    int days = 30,
    int maxItems = 25,
    Duration timeout = const Duration(milliseconds: 500),
  }) async {
    if (userId.isEmpty) return const [];
    final client = _client;
    if (client == null) return const [];
    final cutoff = DateTime.now()
        .toUtc()
        .subtract(Duration(days: days))
        .toIso8601String();

    Future<List<String>> fetch() async {
      // Schema `abba`, table `prayers`, column path `result->scripture->>reference`.
      // Over-fetch 60 rows; we'll dedup down to maxItems by chapter.
      final raw = await client
          .schema(_appId)
          .from('prayers')
          .select('result, created_at')
          .eq('app_id', _appId)
          .eq('user_id', userId)
          .gte('created_at', cutoff)
          .order('created_at', ascending: false)
          .limit(60);

      final list = (raw as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      final seenChapters = <String>{};
      final out = <String>[];
      for (final row in list) {
        final result = row['result'];
        if (result is! Map) continue;
        final scripture = result['scripture'];
        if (scripture is! Map) continue;
        final ref = scripture['reference'];
        if (ref is! String || ref.trim().isEmpty) continue;

        final canonical = canonicalizeReference(ref);
        final chapter = chapterKeyOf(canonical);
        if (chapter.isEmpty) continue;
        if (seenChapters.add(chapter)) {
          out.add(canonical);
          if (out.length >= maxItems) break;
        }
      }
      return out;
    }

    try {
      return await fetch().timeout(timeout, onTimeout: () => const []);
    } catch (_) {
      // Any error (RLS, network, schema mismatch) → soft-empty, never block T1.
      return const [];
    }
  }
}

/// Mock/test stub — always returns the empty list.
/// Wired by `main.dart` mock path so `recentReferencesProvider` resolves.
class NoopRecentReferencesService extends RecentReferencesService {
  NoopRecentReferencesService()
    : super._noClient();

  @override
  Future<List<String>> getRecentReferences({
    required String userId,
    int days = 30,
    int maxItems = 25,
    Duration timeout = const Duration(milliseconds: 500),
  }) async => const [];
}
