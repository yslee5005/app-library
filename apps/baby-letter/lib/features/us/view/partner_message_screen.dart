import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// E7. 파트너 메시지 화면
/// 감정 선택 → 프리셋/직접 작성 → 보내기 / 받은 메시지 목록
class PartnerMessageScreen extends StatefulWidget {
  const PartnerMessageScreen({super.key});

  @override
  State<PartnerMessageScreen> createState() => _PartnerMessageScreenState();
}

class _PartnerMessageScreenState extends State<PartnerMessageScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '파트너에게',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.coral,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.coral,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: '받은 메시지'),
            Tab(text: '보내기'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_ReceivedTab(), _SendTab()],
      ),
    );
  }
}

/// 받은 메시지 탭
class _ReceivedTab extends StatelessWidget {
  const _ReceivedTab();

  // 샘플 데이터 (실제로는 상태관리에서 가져옴)
  static const List<_ReceivedMessage> _sampleMessages = [];

  @override
  Widget build(BuildContext context) {
    if (_sampleMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💌', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              '아직 받은 메시지가 없어요',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              '파트너에게 먼저 마음을 전해보세요',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _sampleMessages.length,
      itemBuilder: (context, index) {
        final msg = _sampleMessages[index];
        return _ReceivedMessageCard(message: msg);
      },
    );
  }
}

/// 받은 메시지 데이터 모델
class _ReceivedMessage {
  final String emoji;
  final String emotion;
  final String message;
  final String timestamp;

  const _ReceivedMessage({
    required this.emoji,
    required this.emotion,
    required this.message,
    required this.timestamp,
  });
}

/// 받은 메시지 카드
class _ReceivedMessageCard extends StatelessWidget {
  final _ReceivedMessage message;

  const _ReceivedMessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(message.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                message.emotion,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.coral,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                message.timestamp,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.textHint),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// 보내기 탭
class _SendTab extends StatefulWidget {
  const _SendTab();

  @override
  State<_SendTab> createState() => _SendTabState();
}

class _SendTabState extends State<_SendTab> {
  String? _selectedEmotion;
  String? _selectedPreset;
  bool _isCustom = false;
  final _customController = TextEditingController();

  // 감정 선택 그리드
  static const List<_Emotion> _emotions = [
    _Emotion(emoji: '💛', label: '감사'),
    _Emotion(emoji: '🙏', label: '응원'),
    _Emotion(emoji: '🤗', label: '위로'),
    _Emotion(emoji: '💬', label: '솔직'),
    _Emotion(emoji: '🆘', label: '도움요청'),
  ];

  // 감정별 프리셋 메시지
  static const Map<String, List<String>> _presets = {
    '감사': ['오늘 밤중 수유 대신 해줘서 고마워', '힘든데도 잘 해주고 있어서 고마워', '아기 돌봐줘서 고마워'],
    '응원': ['당신은 정말 좋은 부모야', '오늘도 수고했어, 힘내자!', '우리 함께하니까 괜찮아'],
    '위로': ['힘들면 말해줘, 내가 도와줄게', '잠깐 쉬어도 괜찮아', '완벽하지 않아도 돼'],
    '솔직': ['요즘 좀 힘들어...', '나도 쉬고 싶어', '우리 얘기 좀 하자'],
    '도움요청': ['오늘 좀 도와줄 수 있어?', '아기 좀 봐줄 수 있어?', '같이 병원 가줄 수 있어?'],
  };

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 감정 선택 그리드
          Text(
            '어떤 마음을 전할까요?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _emotions.map((emotion) {
              final isSelected = _selectedEmotion == emotion.label;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedEmotion = emotion.label;
                    _selectedPreset = null;
                    _isCustom = false;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: (MediaQuery.sizeOf(context).width - 70) / 3,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.coral.withValues(alpha: 0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.coral
                          : AppColors.surfaceVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(emotion.emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 4),
                      Text(
                        emotion.label,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: isSelected
                                  ? AppColors.coral
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          // 프리셋 메시지 + 직접 쓰기
          if (_selectedEmotion != null) ...[
            const SizedBox(height: 24),
            Text(
              '메시지를 선택하세요',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // 프리셋 메시지들
            ...(_presets[_selectedEmotion] ?? []).map((preset) {
              final isSelected = _selectedPreset == preset && !_isCustom;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedPreset = preset;
                      _isCustom = false;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.coral.withValues(alpha: 0.1)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.coral
                            : AppColors.surfaceVariant,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      preset,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppColors.coral
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),

            // 직접 쓰기 옵션
            const SizedBox(height: 4),
            InkWell(
              onTap: () {
                setState(() {
                  _isCustom = true;
                  _selectedPreset = null;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _isCustom
                      ? AppColors.coral.withValues(alpha: 0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCustom
                        ? AppColors.coral
                        : AppColors.surfaceVariant,
                    width: _isCustom ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: _isCustom
                          ? AppColors.coral
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '직접 쓰기',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _isCustom
                            ? AppColors.coral
                            : AppColors.textSecondary,
                        fontWeight: _isCustom
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 직접 쓰기 입력 필드
            if (_isCustom) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _customController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '마음을 담아 적어보세요...',
                  hintStyle: const TextStyle(color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.surfaceVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.surfaceVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.coral),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // 보내기 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (_selectedPreset != null ||
                        (_isCustom && _customController.text.isNotEmpty))
                    ? () {
                        // TODO: 메시지 전송 로직
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('메시지를 보냈어요 💌'),
                            backgroundColor: AppColors.coral,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  disabledBackgroundColor: AppColors.coralLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('보내기 💌'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 감정 모델
class _Emotion {
  final String emoji;
  final String label;

  const _Emotion({required this.emoji, required this.label});
}
