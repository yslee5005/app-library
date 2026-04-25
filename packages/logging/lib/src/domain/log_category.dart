/// Categories for structured log filtering.
///
/// Use [LogCategory.general] for uncategorized messages.
/// Apps can pass a custom [tag] string for finer sub-categories.
enum LogCategory {
  db,
  api,
  auth,
  prayer,
  qt,
  community,
  tts,
  stt,
  fcm,
  subscription,
  general,
}
