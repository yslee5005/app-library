/// Localized subscription prices from the store (App Store / Play Store).
///
/// Read via [SubscriptionService.getOfferingPrices]. Prices are returned in
/// the store's locale-formatted form (e.g. `$6.99`, `₩9,900`, `€6,99`) —
/// UI should display them verbatim and **not** apply any additional
/// currency formatting.
///
/// When the store offering is unavailable (no network, RevenueCat
/// misconfiguration, sandbox before first fetch), implementations return
/// `null`. In that case the UI must fall back to the hardcoded ARB default
/// prices.
class OfferingPrices {
  const OfferingPrices({
    required this.monthlyPriceString,
    required this.yearlyPriceString,
    required this.yearlyPriceMonthlyString,
    this.savingsPercent,
    required this.currencyCode,
  });

  /// Monthly plan price as formatted by the store (e.g. `$6.99`).
  final String monthlyPriceString;

  /// Yearly plan price as formatted by the store (e.g. `$49.99`).
  final String yearlyPriceString;

  /// Yearly plan divided by 12, formatted in the same currency/locale as
  /// [yearlyPriceString] (e.g. `$4.17`). Computed via
  /// `NumberFormat.simpleCurrency` against [currencyCode] since RevenueCat
  /// only returns the full-period price string.
  final String yearlyPriceMonthlyString;

  /// Integer percent saved when switching from monthly×12 to yearly.
  /// Null when either price is 0/unknown (division undefined).
  final int? savingsPercent;

  /// ISO 4217 code of the store-local currency (e.g. `USD`, `KRW`, `EUR`).
  final String currencyCode;
}
