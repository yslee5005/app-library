import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;

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
    final key = GlobalKey();

    final overlay = OverlayEntry(
      builder: (context) => Positioned(
        left: -2000,
        child: RepaintBoundary(
          key: key,
          child: _MilestoneCardWidget(
            streakDays: streakDays,
            userName: userName,
            locale: locale,
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
      ], text: _shareText(streakDays, locale));
    } finally {
      overlay.remove();
    }
  }

  static String _shareText(int days, String locale) {
    return switch (locale) {
      'ko' => '$days일 연속 기도! Abba와 함께하는 기도 여정 #Abba #기도',
      'ja' => '$days日連続の祈り！Abbaとの祈りの旅 #Abba #祈り',
      'es' =>
        '¡$days días seguidos de oración! Mi viaje con Abba #Abba #Oración',
      'zh' => '连续$days天祷告！与Abba同行的祷告之旅 #Abba #祷告',
      _ => '$days day prayer streak! My prayer journey with Abba #Abba #Prayer',
    };
  }
}

class _MilestoneCardWidget extends StatelessWidget {
  final int streakDays;
  final String userName;
  final String locale;

  const _MilestoneCardWidget({
    required this.streakDays,
    required this.userName,
    required this.locale,
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
              _daysLabel,
              style: AbbaTypography.h1.copyWith(color: AbbaColors.warmBrown),
            ),
            const SizedBox(height: AbbaSpacing.lg),
            Text(
              _subtitle,
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

  String get _daysLabel => switch (locale) {
    'ko' => '일 연속 기도',
    'ja' => '日連続の祈り',
    'es' => 'días de oración',
    'zh' => '天连续祷告',
    _ => 'day prayer streak',
  };

  String get _subtitle => switch (locale) {
    'ko' => '하나님과 함께하는 매일의 기도',
    'ja' => '神と共にある毎日の祈り',
    'es' => 'Oración diaria con Dios',
    'zh' => '与上帝同行的每日祷告',
    _ => 'Daily prayer with God',
  };
}
