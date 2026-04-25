import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

/// Gates a premium action behind the `abba_pro` entitlement.
///
/// When the user is already premium, [action] runs immediately. Otherwise the
/// RevenueCat paywall is presented; if the user completes a purchase, the
/// paywall closes and [action] runs. Returns true when [action] executed.
///
/// Call from any widget callback:
/// ```dart
/// onPressed: () => ProGate.run(ref, () async {
///   // premium-only behaviour (e.g. play AI prayer TTS)
/// });
/// ```
class ProGate {
  ProGate._();

  static Future<bool> run(WidgetRef ref, Future<void> Function() action) async {
    final service = ref.read(subscriptionServiceProvider);
    if (await service.isPremium) {
      await action();
      return true;
    }
    final purchased = await service.presentPaywall();
    if (!purchased) return false;
    ref.invalidate(isPremiumProvider);
    await action();
    return true;
  }
}

/// Widget wrapper that intercepts taps on [child] and routes them through
/// [ProGate.run]. Use when the whole widget (a card, list tile, etc.) is
/// premium-only. For more granular control, call [ProGate.run] directly.
class ProGateTap extends ConsumerWidget {
  const ProGateTap({super.key, required this.child, required this.onAccess});

  final Widget child;
  final Future<void> Function() onAccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ProGate.run(ref, onAccess),
      child: child,
    );
  }
}
