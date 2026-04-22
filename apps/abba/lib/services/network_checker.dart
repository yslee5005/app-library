import 'dart:io';

/// Simple network connectivity check using DNS lookup.
/// No external package needed.
class NetworkChecker {
  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      // Intentional: no network is a valid state, not an error
      return false;
    } on Exception catch (_) {
      // Intentional: DNS/timeout failures are the same signal (offline)
      return false;
    }
  }
}
