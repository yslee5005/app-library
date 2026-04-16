import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// F1. 설정 메인
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              '설정',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),

            // 프로필
            _SettingsSection(
              title: '프로필',
              icon: Icons.person_rounded,
              items: [
                _SettingsItem(
                  title: '아기 정보 수정',
                  onTap: () {},
                ),
                _SettingsItem(
                  title: '파트너 초대/관리',
                  onTap: () {},
                ),
                _SettingsItem(
                  title: '계정 연결 (선택)',
                  subtitle: 'Google / Apple로 데이터 백업',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 알림
            _SettingsSection(
              title: '알림',
              icon: Icons.notifications_rounded,
              items: [
                _SettingsItem(
                  title: '알림 설정',
                  onTap: () {
                    // TODO: F2 알림 설정
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 데이터
            _SettingsSection(
              title: '데이터',
              icon: Icons.storage_rounded,
              items: [
                _SettingsItem(
                  title: '데이터 내보내기',
                  onTap: () {},
                ),
                _SettingsItem(
                  title: '데이터 삭제',
                  textColor: AppColors.danger,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 정보
            _SettingsSection(
              title: '정보',
              icon: Icons.info_rounded,
              items: [
                _SettingsItem(
                  title: '앱 정보',
                  subtitle: 'v1.0.0',
                  onTap: () {},
                ),
                _SettingsItem(
                  title: '개인정보 처리방침',
                  onTap: () {},
                ),
                _SettingsItem(
                  title: '이용약관',
                  onTap: () {},
                ),
                _SettingsItem(
                  title: '오픈소스 라이선스',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 계정
            _SettingsSection(
              title: '계정',
              icon: Icons.lock_rounded,
              items: [
                _SettingsItem(
                  title: '로그아웃',
                  onTap: () {},
                ),
                _SettingsItem(
                  title: '회원 탈퇴',
                  textColor: AppColors.danger,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_SettingsItem> items;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? textColor;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.title,
    this.subtitle,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor ?? AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
