/// Service for locale detection and supported locale management.
///
/// Pure Dart — uses [Platform.localeName] heuristic or accepts explicit locale.
class LanguageService {
  const LanguageService({
    this.supportedLocales = const ['en', 'ko'],
    this.fallbackLocale = 'en',
  });

  /// List of locale codes the app supports.
  final List<String> supportedLocales;

  /// Fallback locale when the system locale is not supported.
  final String fallbackLocale;

  /// Resolves the best matching supported locale for [systemLocale].
  ///
  /// [systemLocale] is a locale string like `en_US`, `ko_KR`, or `ko`.
  /// Returns the first supported match by language code, or [fallbackLocale].
  String resolve(String systemLocale) {
    // Extract language code (before underscore or hyphen)
    final lang = systemLocale.split(RegExp(r'[_-]')).first.toLowerCase();

    if (supportedLocales.contains(lang)) return lang;
    return fallbackLocale;
  }

  /// Whether [localeCode] is in the supported list.
  bool isSupported(String localeCode) {
    return supportedLocales.contains(localeCode.toLowerCase());
  }
}
