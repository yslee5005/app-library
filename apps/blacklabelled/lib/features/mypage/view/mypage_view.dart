import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/blacklabelled_theme.dart';

class MyPageView extends ConsumerWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(BlackLabelledSpacing.contentPadding),
      children: [
        const SizedBox(height: BlackLabelledSpacing.md),

        // Settings Section
        Text(
          'SETTINGS',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.lg),

        // App Version
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: BlackLabelledSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('App Version', style: theme.textTheme.bodyMedium),
              Text(
                '1.0.0',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),

        // SNS Section
        Text(
          'SNS',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.lg),

        _LinkTile(
          title: 'Instagram',
          subtitle: '@blacklabelled_official',
          onTap: () async {
            final uri = Uri.parse(
              'https://www.instagram.com/blacklabelled_official/',
            );
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
        ),
        Divider(color: theme.colorScheme.outline, thickness: 0.5),
        _LinkTile(
          title: 'Naver Blog',
          subtitle: 'BLACKLABELLED',
          onTap: () async {
            final uri = Uri.parse('https://blog.naver.com/blacklabelled');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
        ),

        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),

        // Company Info
        Text(
          'BLACKLABELLED',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            letterSpacing: 2.0,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.sm),
        Text(
          '경기도 성남시 분당구 야탑로 81\nTel. 010-9887-2826\nblacklabelled@naver.com',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.secondary,
            height: 1.6,
          ),
        ),

        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LinkTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BlackLabelledSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: theme.colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
