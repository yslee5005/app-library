import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// E4/E5/E6. EPDS 결과 화면
/// 점수에 따라 3단계로 결과 표시: 정상(0-9), 주의(10-12), 위험(13+)
class EpdsResultScreen extends StatefulWidget {
  final int score;
  final bool isMom;

  const EpdsResultScreen({
    super.key,
    required this.score,
    required this.isMom,
  });

  @override
  State<EpdsResultScreen> createState() => _EpdsResultScreenState();
}

class _EpdsResultScreenState extends State<EpdsResultScreen> {
  bool _notifyPartner = false;

  _ResultLevel get _level {
    if (widget.score <= 9) return _ResultLevel.normal;
    if (widget.score <= 12) return _ResultLevel.warning;
    return _ResultLevel.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _level.backgroundColor,
      appBar: AppBar(
        backgroundColor: _level.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '결과',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              switch (_level) {
                _ResultLevel.normal => _buildNormalResult(context),
                _ResultLevel.warning => _buildWarningResult(context),
                _ResultLevel.danger => _buildDangerResult(context),
              },
            ],
          ),
        ),
      ),
    );
  }

  /// 정상 (0-9점)
  Widget _buildNormalResult(BuildContext context) {
    return Column(
      children: [
        // 제목
        Text(
          '잘 하고 있어요 💛',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 20),

        // 점수 원
        _ScoreCircle(
          score: widget.score,
          color: AppColors.success,
          maxScore: 30,
        ),
        const SizedBox(height: 12),
        Text(
          '현재 상태가 양호해요',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),

        const SizedBox(height: 28),

        // 셀프케어 팁
        Text(
          '나를 위한 셀프케어 💝',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),

        _SelfCareTipCard(
          emoji: '🚶',
          title: '산책하기',
          description: '15분이라도 바깥 공기를 쐬면\n기분이 한결 나아져요',
        ),
        const SizedBox(height: 10),
        _SelfCareTipCard(
          emoji: '🧘',
          title: '명상 5분',
          description: '눈을 감고 깊게 호흡해보세요.\n지금 이 순간에 집중하기',
        ),
        const SizedBox(height: 10),
        _SelfCareTipCard(
          emoji: '📱',
          title: '친구에게 연락',
          description: '오래된 친구에게 안부 메시지를\n보내보는 건 어떨까요?',
        ),

        const SizedBox(height: 24),

        // 주간 트렌드 플레이스홀더
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.show_chart_rounded,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '주간 변화 추이',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 간단한 트렌드 플레이스홀더
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _TrendDot(label: '1주전', height: 40, color: AppColors.success),
                    _TrendDot(label: '2주전', height: 30, color: AppColors.success),
                    _TrendDot(label: '지난주', height: 25, color: AppColors.success),
                    _TrendDot(
                      label: '이번주',
                      height: 20,
                      color: AppColors.success,
                      isCurrent: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 홈으로 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('홈으로'),
          ),
        ),
      ],
    );
  }

  /// 주의 (10-12점)
  Widget _buildWarningResult(BuildContext context) {
    return Column(
      children: [
        // 제목
        Text(
          '요즘 좀 힘드시죠',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '그럴 수 있어요. 당신 잘못이 아니에요.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 20),

        // 점수 원
        _ScoreCircle(
          score: widget.score,
          color: AppColors.warning,
          maxScore: 30,
        ),

        const SizedBox(height: 24),

        // 따뜻한 메시지
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('🤗', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 12),
              Text(
                '육아는 정말 힘든 일이에요.\n지금 느끼는 감정은 자연스러운 거예요.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                '전문 상담을 받아보시면\n마음이 한결 편해질 수 있어요.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 정신건강복지센터 링크
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.warning.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Text('🏥', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '가까운 정신건강복지센터',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '무료 상담을 받을 수 있어요',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 파트너 알림 토글
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '파트너에게 알릴까요?',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '결과를 공유하면 서로 도울 수 있어요',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _notifyPartner,
                onChanged: (value) {
                  setState(() {
                    _notifyPartner = value;
                  });
                },
                activeTrackColor: AppColors.coral,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 확인 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.amberDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('확인'),
          ),
        ),
      ],
    );
  }

  /// 위험 (13점 이상)
  Widget _buildDangerResult(BuildContext context) {
    return Column(
      children: [
        // 제목
        Text(
          '당신은 혼자가 아니에요',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '도움을 요청하는 것은 용기 있는 일이에요',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 20),

        // 점수 원
        _ScoreCircle(
          score: widget.score,
          color: AppColors.danger,
          maxScore: 30,
        ),

        const SizedBox(height: 24),

        // 메시지
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '전문가와 이야기하는 것이\n가장 좋은 선택이에요',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
          ),
        ),

        const SizedBox(height: 16),

        // 긴급 연결 버튼들
        _EmergencyButton(
          emoji: '📞',
          title: '정신건강 위기상담 전화',
          subtitle: '1577-0199',
          color: AppColors.danger,
          onTap: () {
            // TODO: 전화 연결
          },
        ),
        const SizedBox(height: 10),
        _EmergencyButton(
          emoji: '🆘',
          title: '자살예방 상담전화',
          subtitle: '1393',
          color: AppColors.danger,
          onTap: () {
            // TODO: 전화 연결
          },
        ),
        const SizedBox(height: 10),
        _EmergencyButton(
          emoji: '🏥',
          title: '가까운 정신건강복지센터 검색',
          subtitle: '무료 상담 가능',
          color: AppColors.coralDark,
          onTap: () {
            // TODO: 검색 연결
          },
        ),

        const SizedBox(height: 20),

        // 파트너 알림
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '파트너에게 알리기',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '함께 이겨낼 수 있어요',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _notifyPartner,
                onChanged: (value) {
                  setState(() {
                    _notifyPartner = value;
                  });
                },
                activeTrackColor: AppColors.coral,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 이 설문은 진단이 아닙니다
        Text(
          '이 설문은 선별 도구이며 진단이 아닙니다.\n정확한 진단은 전문가 상담이 필요합니다.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textHint,
                height: 1.5,
              ),
        ),
      ],
    );
  }
}

/// 결과 레벨 enum
enum _ResultLevel {
  normal,
  warning,
  danger;

  Color get backgroundColor {
    return switch (this) {
      _ResultLevel.normal => AppColors.successLight,
      _ResultLevel.warning => AppColors.warningLight,
      _ResultLevel.danger => AppColors.dangerLight,
    };
  }
}

/// 점수 원형 위젯
class _ScoreCircle extends StatelessWidget {
  final int score;
  final Color color;
  final int maxScore;

  const _ScoreCircle({
    required this.score,
    required this.color,
    required this.maxScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color, width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$score',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(
            '/ $maxScore',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color.withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }
}

/// 셀프케어 팁 카드
class _SelfCareTipCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _SelfCareTipCard({
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
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

/// 주간 트렌드 점 위젯
class _TrendDot extends StatelessWidget {
  final String label;
  final double height;
  final Color color;
  final bool isCurrent;

  const _TrendDot({
    required this.label,
    required this.height,
    required this.color,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: isCurrent ? 14 : 10,
          height: isCurrent ? 14 : 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent ? color : color.withValues(alpha: 0.5),
            border: isCurrent
                ? Border.all(color: Colors.white, width: 2)
                : null,
            boxShadow: isCurrent
                ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 6)]
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textHint,
                fontSize: 9,
              ),
        ),
      ],
    );
  }
}

/// 긴급 연결 버튼
class _EmergencyButton extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _EmergencyButton({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.phone_rounded,
              color: color,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
