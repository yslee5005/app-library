import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// B4. 태아 영상 풀스크린
/// 다크 배경 + 비디오 플레이스홀더 + 발달 정보 + 주차 이동
class VideoFullscreenScreen extends StatelessWidget {
  final int currentWeek;

  const VideoFullscreenScreen({super.key, required this.currentWeek});

  /// 주차별 대략적 크기/무게 정보
  String get _sizeInfo {
    if (currentWeek <= 10) return '약 3cm · 4g';
    if (currentWeek <= 14) return '약 8cm · 43g';
    if (currentWeek <= 18) return '약 14cm · 190g';
    if (currentWeek <= 22) return '약 27cm · 430g';
    if (currentWeek <= 26) return '약 35cm · 760g';
    if (currentWeek <= 30) return '약 38cm · 1.3kg';
    if (currentWeek <= 34) return '약 43cm · 2.1kg';
    if (currentWeek <= 38) return '약 48cm · 3.0kg';
    return '약 50cm · 3.3kg';
  }

  /// 주차별 발달 하이라이트
  String get _developmentHighlight {
    if (currentWeek <= 10) return '심장이 뛰기 시작하고 손가락이 나뉘어요';
    if (currentWeek <= 14) return '하품을 하고 표정을 지을 수 있어요';
    if (currentWeek <= 18) return '태동이 시작되고 엄마가 느낄 수 있어요';
    if (currentWeek <= 22) return '청각이 발달해 엄마 목소리를 들어요';
    if (currentWeek <= 26) return '눈을 뜨고 맛을 느낄 수 있어요';
    if (currentWeek <= 30) return '소리를 기억하고 꿈을 꿔요';
    if (currentWeek <= 34) return '폐가 거의 완성되어 가요';
    if (currentWeek <= 38) return '모든 장기가 성숙해 만날 준비가 됐어요';
    return '만삭! 곧 만나요';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: Text(
          'Week $currentWeek',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const Spacer(),

          // 비디오 플레이스홀더 (1080x1080 → 정사각형)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFE0B2),
                      Color(0xFFFFCC80),
                      Color(0xFFFFB74D),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // 중앙 콘텐츠
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('👶',
                              style: TextStyle(fontSize: 80)),
                          const SizedBox(height: 16),
                          Text(
                            'Week $currentWeek',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 재생 버튼 오버레이
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 크기/무게 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$currentWeek주차',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 16,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 12),
                Text(
                  _sizeInfo,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 발달 하이라이트
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _developmentHighlight,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),

          // 하단 주차 이동 네비게이션
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 이전 주차
                  TextButton.icon(
                    onPressed: currentWeek > 8
                        ? () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => VideoFullscreenScreen(
                                  currentWeek: currentWeek - 2,
                                ),
                              ),
                            );
                          }
                        : null,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 18,
                      color: currentWeek > 8
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                    ),
                    label: Text(
                      'Week ${currentWeek - 2}',
                      style: TextStyle(
                        color: currentWeek > 8
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),

                  // 현재 주차 인디케이터
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Week $currentWeek',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.amber,
                      ),
                    ),
                  ),

                  // 다음 주차
                  TextButton(
                    onPressed: currentWeek < 40
                        ? () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => VideoFullscreenScreen(
                                  currentWeek: currentWeek + 2,
                                ),
                              ),
                            );
                          }
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Week ${currentWeek + 2}',
                          style: TextStyle(
                            color: currentWeek < 40
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: currentWeek < 40
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SafeArea 하단 패딩
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
