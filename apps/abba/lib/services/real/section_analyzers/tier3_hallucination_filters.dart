import 'package:app_lib_logging/logging.dart';

import '../../../models/prayer.dart';

/// T3 post-processing filters to catch the two hallucination classes that
/// prompts alone cannot reliably prevent:
///
/// 1. `historical_story` drifting into Bible narrative (which is T2's job)
///    or naming a non-whitelisted church-history figure.
/// 2. `ai_prayer.citations` with empty/vague sources, fabricated "recent
///    studies", or well-known misattribution patterns.
///
/// Shared by `Tier3Analyzer` (new tier path) and
/// `GeminiService.analyzePrayerPremium` (legacy path that Pro users still
/// hit from PrayerDashboardView `_loadPremiumContent`).

/// Returns the story if it passes verification, or `null` if it must be
/// dropped so the UI gracefully omits the card.
///
/// Verification is whitelist-based on purpose: blocking Bible names by
/// substring produced false positives on legitimate phrasing such as
/// "Christian martyrs" or "followed Jesus' example". Requiring a
/// whitelisted church-history figure to appear is stricter and safer.
HistoricalStory? sanitizeHistoricalStory(HistoricalStory s) {
  final haystack = '${s.title} ${s.summary}'.toLowerCase();

  if (s.reference.trim().isEmpty || _isVagueReference(s.reference)) {
    apiLog.warning(
      '[T3-filter] historical_story dropped — vague/empty reference "${s.reference}"',
    );
    return null;
  }

  final matched = _churchHistoryWhitelist.any(
    (pattern) => haystack.contains(pattern),
  );
  if (!matched) {
    apiLog.warning(
      '[T3-filter] historical_story dropped — no whitelisted church-history figure in title/summary (title="${s.title}")',
    );
    return null;
  }

  // Wave B (B4) — historical-fabrication BAD-1 pattern: an authoritative-
  // sounding "in <year> in <Capitalized place>" date stamp. If a story
  // carries this stamp but lacks any strict full-name whitelist anchor
  // (i.e. only loose substring matches like " calvin" inside an unrelated
  // town name fired the gate above), drop it. Pattern is case-sensitive
  // by design so it runs against the ORIGINAL `title + summary`, not the
  // lowercased haystack.
  final original = '${s.title} ${s.summary}';
  if (_historicalDateStampRegex.hasMatch(original) &&
      !_strictChurchHistoryAnchors.any((a) => haystack.contains(a))) {
    apiLog.warning(
      '[T3-filter] historical_story dropped — date-stamp pattern without strict whitelist anchor (title="${s.title}")',
    );
    return null;
  }
  return s;
}

/// Filter out unsafe citations. Always returns a fresh `AiPrayer`; when
/// nothing changes the returned object is structurally equal.
AiPrayer sanitizeAiPrayer(AiPrayer p) {
  final kept = <Citation>[];
  for (final c in p.citations) {
    if (_isDangerousCitation(c)) {
      apiLog.warning(
        '[T3-filter] citation dropped — type=${c.type} source="${c.source}"',
      );
      continue;
    }
    kept.add(c);
  }
  if (kept.length == p.citations.length) return p;
  return AiPrayer(text: p.text, citations: kept, isPremium: p.isPremium);
}

bool _isDangerousCitation(Citation c) {
  final source = c.source.toLowerCase().trim();
  final content = c.content.toLowerCase();
  // "example" type is allowed to have empty source (concrete anecdotes).
  if (c.type != 'example' && source.isEmpty) return true;
  for (final pat in _citationBadPatterns) {
    if (source.contains(pat) || content.contains(pat)) return true;
  }
  return false;
}

bool _isVagueReference(String ref) {
  final r = ref.toLowerCase();
  return _vagueReferencePatterns.any((p) => r.contains(p));
}

/// Church-history figures the `historical_story_rubric §3` lists as safe
/// without additional verification. Matching is case-insensitive substring
/// on the story's title + summary combined.
///
/// Korean names are stored as base strings (주기철/손양원/한경직); they are
/// matched with the same lowercased haystack since Korean has no case.
const List<String> _churchHistoryWhitelist = <String>[
  // Western — names only; rubric also allows their verifiable works to
  // carry the attribution, but name-in-story is the MVP check.
  'augustine',
  'martin luther',
  ' luther', // matches "Luther wrote…" without catching "Lutheran"
  'john calvin',
  ' calvin',
  'john wesley',
  ' wesley',
  'charles spurgeon',
  'spurgeon',
  'dietrich bonhoeffer',
  'bonhoeffer',
  'george müller',
  'george muller',
  // B4 — removed standalone 'müller' / 'muller' (matched countless unrelated
  // names) and standalone 'moravian' (admitted fabricated anecdotes). Use
  // anchored forms only.
  'hudson taylor',
  'corrie ten boom',
  'c.s. lewis',
  'c. s. lewis',
  'billy graham',
  'amy carmichael',
  'moravian brethren',
  'moravian missions',
  // Korean
  '주기철',
  '손양원',
  '한경직',
];

/// Strict full-name anchors used by the BAD-1 date-stamp defense.
/// A subset of [_churchHistoryWhitelist] limited to unambiguous full names
/// (no leading-space substring tricks). If a story carries a "in 1547 in
/// Wittenberg" style date stamp we require one of these to appear, so a
/// hallucinated 16th-century narrative cannot piggy-back on " calvin" /
/// " luther" substring matches against unrelated towns.
const List<String> _strictChurchHistoryAnchors = <String>[
  'augustine',
  'martin luther',
  'john calvin',
  'john wesley',
  'charles spurgeon',
  'spurgeon',
  'dietrich bonhoeffer',
  'bonhoeffer',
  'george müller',
  'george muller',
  'hudson taylor',
  'corrie ten boom',
  'c.s. lewis',
  'c. s. lewis',
  'billy graham',
  'amy carmichael',
  'moravian brethren',
  'moravian missions',
  '주기철',
  '손양원',
  '한경직',
];

/// BAD-1 historical-fabrication pattern: "In 1547 in Wittenberg" — an
/// authoritative-sounding date + place stamp. We treat this as a red flag
/// when no strict whitelist anchor is present. The leading "in"/"In" is
/// matched explicitly (handles sentence-starts); the place must be a
/// capital ASCII letter so it looks like a real toponym.
final RegExp _historicalDateStampRegex = RegExp(r'[Ii]n 1\d{3} in [A-Z]');

const List<String> _vagueReferencePatterns = <String>[
  'some time ago',
  'in the church history',
  'in history',
  'a long time ago',
  // B4 — additional vague phrases historians actually never write.
  'centuries ago',
  'during the reformation',
  '오래전',
  '과거에',
  '예전에',
  '옛날에',
  '수세기 전',
  '초대교회 시절',
];

/// Patterns associated with fabricated or misattributed citations.
const List<String> _citationBadPatterns = <String>[
  'recent studies',
  'recent research',
  'scientists say',
  'studies have shown',
  'according to research',
  // B4 — additional generic-attribution patterns that flag
  // hallucination-by-default ("research says…" with no source).
  'research suggests',
  'studies indicate',
  'studies suggest',
  'experts say',
  'experts agree',
  'data shows',
  'as research shows',
  '연구에 따르면',
  '최근 연구',
  '과학자들은',
  '전문가들에 따르면',
  '한 연구에서',
  '전문가에 따르면',
  // Common misattribution red flags — Einstein/Gandhi quotes online are
  // overwhelmingly fabricated without primary-source attribution.
  'einstein said',
  'gandhi said',
  'mother teresa said',
  '아인슈타인이 말하',
  '간디가 말하',
];
