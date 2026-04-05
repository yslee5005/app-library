import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/blacklabelled_theme.dart';

class ConsultView extends StatelessWidget {
  const ConsultView({super.key});

  Future<void> _launchPhone() async {
    final uri = Uri.parse('tel:010-9887-2826');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchKakao() async {
    final uri = Uri.parse('https://pf.kakao.com/_blacklabelled');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail() async {
    final uri = Uri.parse('mailto:blacklabelled@naver.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(BlackLabelledSpacing.contentPadding),
      children: [
        const SizedBox(height: BlackLabelledSpacing.md),

        // Section Title
        Text(
          'INTERIOR PROCESS',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.xl),

        // 5-Step Process Indicator
        const _ProcessSteps(),
        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),

        // Step Descriptions
        _StepDescription(
          number: '01',
          title: '상담',
          description:
              '고객님의 라이프스타일과 취향, 예산을 파악합니다.\n공간의 현황을 분석하고 디자인 방향을 제안합니다.',
        ),
        _StepDescription(
          number: '02',
          title: '계약',
          description: '상담 내용을 바탕으로 견적을 산출합니다.\n시공 범위와 일정을 확정하고 계약을 진행합니다.',
        ),
        _StepDescription(
          number: '03',
          title: '설계',
          description: '3D 모델링을 통해 공간을 시각화합니다.\n자재와 가구를 선정하고 상세 도면을 완성합니다.',
        ),
        _StepDescription(
          number: '04',
          title: '시공',
          description: '전문 시공팀이 설계대로 정밀 시공합니다.\n단계별 현장 관리로 품질을 보장합니다.',
        ),
        _StepDescription(
          number: '05',
          title: '완료',
          description: '최종 점검과 클리닝을 진행합니다.\n입주 후에도 A/S를 통해 관리합니다.',
        ),

        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),

        // Contact Section
        Text(
          'CONTACT',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.lg),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _launchPhone,
            icon: const Icon(Icons.phone_outlined, size: 18),
            label: const Text('010-9887-2826'),
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _launchKakao,
            icon: const Icon(Icons.chat_outlined, size: 18),
            label: const Text('KAKAOTALK'),
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _launchEmail,
            icon: const Icon(Icons.email_outlined, size: 18),
            label: const Text('blacklabelled@naver.com'),
          ),
        ),

        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),

        // Business Info
        Text(
          'INFORMATION',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.lg),

        _InfoRow(label: '운영시간', value: '월 - 금  09:30 ~ 18:30'),
        const SizedBox(height: BlackLabelledSpacing.sm),
        _InfoRow(label: '주소', value: '경기도 성남시 분당구 야탑로 81'),
        const SizedBox(height: BlackLabelledSpacing.sm),
        _InfoRow(label: '이메일', value: 'blacklabelled@naver.com'),
        const SizedBox(height: BlackLabelledSpacing.sm),
        _InfoRow(label: '전화', value: '010-9887-2826'),

        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),
      ],
    );
  }
}

class _ProcessSteps extends StatelessWidget {
  const _ProcessSteps();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const steps = ['상담', '계약', '설계', '시공', '완료'];

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector line
          return Expanded(
            child: Container(height: 1, color: theme.colorScheme.primary),
          );
        }
        final stepIndex = index ~/ 2;
        return Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '${stepIndex + 1}',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              steps[stepIndex],
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StepDescription extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepDescription({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: BlackLabelledSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: GoogleFonts.montserrat(
              fontSize: 28,
              fontWeight: FontWeight.w200,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(width: BlackLabelledSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.secondary,
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ),
        Expanded(child: Text(value, style: theme.textTheme.bodySmall)),
      ],
    );
  }
}
