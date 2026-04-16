import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';

/// A2/A3. 웰컴 스크린
/// 임신 중 / 출산 후 분기 선택
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 일러스트 영역
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '💌',
                    style: TextStyle(fontSize: 80),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 메인 카피
              Text(
                '아기가 편지를\n보내기 시작했어요',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                '아기의 성장을 이해하고,\n판단하지 않고 기록하는 여정을 시작해요',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),

              // CTA 버튼 — 임신 중
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/onboarding/pregnancy'),
                  child: const Text('임신 중이에요'),
                ),
              ),

              const SizedBox(height: 12),

              // CTA 버튼 — 출산 후
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/onboarding/postnatal'),
                  child: const Text('아기가 태어났어요'),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
