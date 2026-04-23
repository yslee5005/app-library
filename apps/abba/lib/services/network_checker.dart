import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contract for a lightweight connectivity probe. The `hasConnection`
/// method returns false for any failure (offline, DNS timeout, socket
/// exception) — callers should treat it as a best-effort signal, not a
/// definitive network status.
abstract class NetworkChecker {
  Future<bool> hasConnection();
}

/// Production implementation using DNS lookup against google.com.
/// No external package needed.
class DnsNetworkChecker implements NetworkChecker {
  const DnsNetworkChecker();

  @override
  Future<bool> hasConnection() async {
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

/// Riverpod provider so tests can override connectivity behaviour without
/// touching the network stack. Default impl is [DnsNetworkChecker].
final networkCheckerProvider = Provider<NetworkChecker>(
  (ref) => const DnsNetworkChecker(),
);
