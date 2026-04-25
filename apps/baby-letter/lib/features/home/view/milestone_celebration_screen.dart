import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// B10. 마일스톤 축하 화면
/// 풀스크린 + 파티클 애니메이션 + 축하 메시지 + 액션 버튼
class MilestoneCelebrationScreen extends StatefulWidget {
  final String milestoneName;
  final DateTime achievedDate;

  const MilestoneCelebrationScreen({
    super.key,
    required this.milestoneName,
    required this.achievedDate,
  });

  @override
  State<MilestoneCelebrationScreen> createState() =>
      _MilestoneCelebrationScreenState();
}

class _MilestoneCelebrationScreenState extends State<MilestoneCelebrationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _particleController;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();

    // 이모지 스케일 애니메이션
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _scaleController.forward();

    // 파티클 애니메이션
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    final random = Random();
    _particles = List.generate(20, (_) {
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: 0.3 + random.nextDouble() * 0.7,
        size: 4.0 + random.nextDouble() * 8.0,
        color: [
          AppColors.coral,
          AppColors.amber,
          AppColors.info,
          AppColors.success,
          AppColors.sleepPurple,
          AppColors.coralLight,
        ][random.nextInt(6)],
      );
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  String get _formattedDate {
    final d = widget.achievedDate;
    return '${d.year}년 ${d.month}월 ${d.day}일';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // 파티클 레이어
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                size: MediaQuery.sizeOf(context),
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                ),
              );
            },
          ),

          // 메인 콘텐츠
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 닫기 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),

                  // 축하 이모지 (스케일 애니메이션)
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Text('🎉', style: TextStyle(fontSize: 80)),
                  ),

                  const SizedBox(height: 32),

                  // 마일스톤 텍스트
                  Text(
                    widget.milestoneName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // 달성 날짜
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amberLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formattedDate,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    '이 순간을 기록해두세요',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.textHint),
                  ),

                  const Spacer(flex: 3),

                  // 액션 버튼
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: 사진 추가 기능
                            },
                            icon: const Text(
                              '📸',
                              style: TextStyle(fontSize: 18),
                            ),
                            label: const Text('사진 추가'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: 공유하기 기능
                            },
                            icon: const Text(
                              '📤',
                              style: TextStyle(fontSize: 18),
                            ),
                            label: const Text('공유하기'),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('닫기'),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 파티클 데이터
class _Particle {
  final double x;
  final double y;
  final double speed;
  final double size;
  final Color color;

  const _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.color,
  });
}

/// 파티클 페인터
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final animatedY = (particle.y + progress * particle.speed) % 1.0;
      final opacity = (1.0 - animatedY).clamp(0.0, 0.6);

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, animatedY * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
