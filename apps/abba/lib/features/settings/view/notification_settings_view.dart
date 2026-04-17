import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

class NotificationSettingsView extends ConsumerWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(notificationSettingsProvider);
    final settings = settingsAsync.value;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text(l10n.notificationSetting, style: AbbaTypography.h2),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AbbaSpacing.md),
        children: [
          AbbaCard(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Morning reminder toggle
                _NotificationTile(
                  icon: Icons.wb_sunny_outlined,
                  title: l10n.morningPrayerReminder,
                  trailing: Switch(
                    value: settings?.morningReminder ?? true,
                    onChanged: (v) {
                      ref
                          .read(notificationServiceProvider)
                          .updateSettings(morningReminder: v);
                      ref.invalidate(notificationSettingsProvider);
                    },
                    activeTrackColor: AbbaColors.sage,
                  ),
                ),
                // Morning time picker (only if morning reminder is on)
                if (settings?.morningReminder ?? true) ...[
                  const Divider(height: 1, indent: 56),
                  _NotificationTile(
                    icon: Icons.access_time,
                    title: settings?.morningTime ?? '06:00',
                    onTap: () async {
                      final currentTime = settings?.morningTime ?? '06:00';
                      final parts = currentTime.split(':');
                      final hour = int.tryParse(parts[0]) ?? 6;
                      final minute =
                          parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: hour, minute: minute),
                      );
                      if (time != null) {
                        final formatted =
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                        ref
                            .read(notificationServiceProvider)
                            .updateSettings(morningTime: formatted);
                        ref.invalidate(notificationSettingsProvider);
                      }
                    },
                  ),
                ],
                const Divider(height: 1, indent: 56),
                // Evening reminder
                _NotificationTile(
                  icon: Icons.nightlight_outlined,
                  title: l10n.eveningGratitudeReminder,
                  trailing: Switch(
                    value: settings?.eveningReminder ?? false,
                    onChanged: (v) {
                      ref
                          .read(notificationServiceProvider)
                          .updateSettings(eveningReminder: v);
                      ref.invalidate(notificationSettingsProvider);
                    },
                    activeTrackColor: AbbaColors.sage,
                  ),
                ),
                const Divider(height: 1, indent: 56),
                // Afternoon nudge
                _NotificationTile(
                  icon: Icons.wb_sunny,
                  title: l10n.afternoonNudgeReminder,
                  trailing: Switch(
                    value: settings?.afternoonNudge ?? true,
                    onChanged: (v) {
                      ref
                          .read(notificationServiceProvider)
                          .updateSettings(afternoonNudge: v);
                      ref.invalidate(notificationSettingsProvider);
                    },
                    activeTrackColor: AbbaColors.sage,
                  ),
                ),
                const Divider(height: 1, indent: 56),
                // Streak reminder
                _NotificationTile(
                  icon: Icons.local_fire_department_outlined,
                  title: l10n.streakReminder,
                  trailing: Switch(
                    value: settings?.streakReminder ?? true,
                    onChanged: (v) {
                      ref
                          .read(notificationServiceProvider)
                          .updateSettings(streakReminder: v);
                      ref.invalidate(notificationSettingsProvider);
                    },
                    activeTrackColor: AbbaColors.sage,
                  ),
                ),
                const Divider(height: 1, indent: 56),
                // Weekly summary
                _NotificationTile(
                  icon: Icons.calendar_view_week,
                  title: l10n.weeklySummaryReminder,
                  trailing: Switch(
                    value: settings?.weeklySummary ?? true,
                    onChanged: (v) {
                      ref
                          .read(notificationServiceProvider)
                          .updateSettings(weeklySummary: v);
                      ref.invalidate(notificationSettingsProvider);
                    },
                    activeTrackColor: AbbaColors.sage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _NotificationTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AbbaColors.warmBrown),
      title: Text(
        title,
        style: AbbaTypography.body.copyWith(color: AbbaColors.warmBrown),
      ),
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right, color: AbbaColors.muted)
              : null),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.md,
        vertical: AbbaSpacing.xs,
      ),
    );
  }
}
