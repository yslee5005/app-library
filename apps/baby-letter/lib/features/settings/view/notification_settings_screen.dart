import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// F2. 알림 설정
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Toggle states
  bool _letterEnabled = true;
  bool _dangerAlertEnabled = true;
  bool _epdsEnabled = true;
  bool _partnerMessageEnabled = true;
  bool _milestoneEnabled = true;
  bool _recordReminderEnabled = true;

  // Picker values
  String _letterTime = '오전 8시';
  String _epdsDay = '일요일';
  String _recordInterval = '3시간';

  // Danger alert warning
  bool _showDangerWarning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '알림 설정',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 아기의 편지
          _NotificationCard(
            emoji: '💌',
            title: '아기의 편지',
            value: _letterEnabled,
            onChanged: (v) => setState(() => _letterEnabled = v),
            extraWidget: _letterEnabled
                ? _TimePicker(
                    label: '시간',
                    value: _letterTime,
                    options: const [
                      '오전 6시',
                      '오전 7시',
                      '오전 8시',
                      '오전 9시',
                      '오전 10시',
                      '오후 12시',
                      '오후 6시',
                      '오후 8시',
                    ],
                    onChanged: (v) => setState(() => _letterTime = v),
                  )
                : null,
          ),

          const SizedBox(height: 12),

          // 위험신호 알림
          _NotificationCard(
            emoji: '⚠️',
            title: '위험신호 알림',
            value: _dangerAlertEnabled,
            onChanged: (v) {
              setState(() {
                _dangerAlertEnabled = v;
                _showDangerWarning = !v;
              });
            },
            extraWidget: _showDangerWarning && !_dangerAlertEnabled
                ? Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Text('⚠️', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '끄지 않는 것을 권장합니다',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),

          const SizedBox(height: 12),

          // EPDS 리마인더
          _NotificationCard(
            emoji: '🧠',
            title: 'EPDS 리마인더',
            value: _epdsEnabled,
            onChanged: (v) => setState(() => _epdsEnabled = v),
            extraWidget: _epdsEnabled
                ? _TimePicker(
                    label: '요일',
                    value: _epdsDay,
                    options: const [
                      '월요일',
                      '화요일',
                      '수요일',
                      '목요일',
                      '금요일',
                      '토요일',
                      '일요일',
                    ],
                    onChanged: (v) => setState(() => _epdsDay = v),
                  )
                : null,
          ),

          const SizedBox(height: 12),

          // 파트너 메시지
          _NotificationCard(
            emoji: '💬',
            title: '파트너 메시지',
            value: _partnerMessageEnabled,
            onChanged: (v) => setState(() => _partnerMessageEnabled = v),
          ),

          const SizedBox(height: 12),

          // 마일스톤 축하
          _NotificationCard(
            emoji: '🏆',
            title: '마일스톤 축하',
            value: _milestoneEnabled,
            onChanged: (v) => setState(() => _milestoneEnabled = v),
          ),

          const SizedBox(height: 12),

          // 기록 리마인더
          _NotificationCard(
            emoji: '📋',
            title: '기록 리마인더',
            value: _recordReminderEnabled,
            onChanged: (v) => setState(() => _recordReminderEnabled = v),
            extraWidget: _recordReminderEnabled
                ? _TimePicker(
                    label: '간격',
                    value: _recordInterval,
                    options: const [
                      '1시간',
                      '2시간',
                      '3시간',
                      '4시간',
                      '6시간',
                    ],
                    onChanged: (v) => setState(() => _recordInterval = v),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

/// 알림 카테고리 카드
class _NotificationCard extends StatelessWidget {
  final String emoji;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? extraWidget;

  const _NotificationCard({
    required this.emoji,
    required this.title,
    required this.value,
    required this.onChanged,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: AppColors.coral,
                activeTrackColor: AppColors.coralLight,
                inactiveThumbColor: AppColors.textHint,
                inactiveTrackColor:
                    AppColors.textHint.withValues(alpha: 0.3),
              ),
            ],
          ),
          ?extraWidget,
        ],
      ),
    );
  }
}

/// 드롭다운 선택기
class _TimePicker extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _TimePicker({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 36),
      child: Row(
        children: [
          Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.textHint.withValues(alpha: 0.3),
              ),
            ),
            child: DropdownButton<String>(
              value: value,
              underline: const SizedBox.shrink(),
              isDense: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: AppColors.textSecondary,
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
              items: options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ],
      ),
    );
  }
}
