import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;

import '../l10n/generated/app_localizations.dart';
import '../theme/abba_theme.dart';

/// Captures a milestone card as an image and shares it.
class MilestoneShareCard {
  /// Generates and shares a milestone achievement card.
  static Future<void> share({
    required BuildContext context,
    required int streakDays,
    required String userName,
    required String locale,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final key = GlobalKey();

    final overlay = OverlayEntry(
      builder: (context) => Positioned(
        left: -2000,
        child: RepaintBoundary(
          key: key,
          child: _MilestoneCardWidget(
            streakDays: streakDays,
            userName: userName,
            daysLabel: l10n.shareDaysLabel,
            subtitle: l10n.shareSubtitle,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);

    // Wait for render
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/abba_milestone_$streakDays.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: l10n.shareStreakText(streakDays));
    } finally {
      overlay.remove();
    }
  }
}

class _MilestoneCardWidget extends StatelessWidget {
  final int streakDays;
  final String userName;
  final String daysLabel;
  final String subtitle;

  const _MilestoneCardWidget({
    required this.streakDays,
    required this.userName,
    required this.daysLabel,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Instagram Story size: 1080x1920 at 3x = 360x640
    return SizedBox(
      width: 360,
      height: 640,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AbbaColors.cream, Color(0xFFE8F5E9)],
          ),
        ),
        padding: const EdgeInsets.all(AbbaSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_icon, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: AbbaSpacing.lg),
            Text(
              '$streakDays',
              style: AbbaTypography.hero.copyWith(
                fontSize: 72,
                color: AbbaColors.sage,
              ),
            ),
            Text(
              daysLabel,
              style: AbbaTypography.h1.copyWith(color: AbbaColors.warmBrown),
            ),
            const SizedBox(height: AbbaSpacing.lg),
            Text(
              subtitle,
              style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AbbaSpacing.xxl),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AbbaSpacing.lg,
                vertical: AbbaSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AbbaColors.sage.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AbbaRadius.xl),
              ),
              child: Text(
                'Abba',
                style: AbbaTypography.h1.copyWith(color: AbbaColors.sage),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _icon {
    if (streakDays >= 365) return '🌳';
    if (streakDays >= 100) return '🌸';
    if (streakDays >= 30) return '🌿';
    if (streakDays >= 7) return '🌱';
    return '🌱';
  }
}
