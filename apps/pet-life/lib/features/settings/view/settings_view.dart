import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../../../models/daily_routine.dart';
import '../../../models/pet_profile.dart';
import '../../../services/breed_data_service.dart';
import '../../../services/pet_storage_service.dart';
import '../../../widgets/glass_card.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  PetProfile? _profile;
  final _storageService = PetStorageService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await _storageService.loadProfile();
    setState(() => _profile = profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('설정',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),

              // Pet info section
              _buildSectionHeader('반려견 정보'),
              const SizedBox(height: 12),
              if (_profile != null) _buildPetInfoCard(),
              const SizedBox(height: 24),

              // Routines section
              _buildSectionHeader('데일리 루틴'),
              const SizedBox(height: 12),
              _buildRoutineSettings(),
              const SizedBox(height: 24),

              // Notification section
              _buildSectionHeader('알림'),
              const SizedBox(height: 12),
              _buildNotificationSettings(),
              const SizedBox(height: 24),

              // App settings
              _buildSectionHeader('앱 설정'),
              const SizedBox(height: 12),
              _buildAppSettings(),
              const SizedBox(height: 24),

              // About
              _buildSectionHeader('정보'),
              const SizedBox(height: 12),
              _buildAboutSection(),
              const SizedBox(height: 24),

              // Reset
              _buildResetButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppConfig.accentColor,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildPetInfoCard() {
    final breed = BreedDataService().getBreedById(_profile!.breedId);

    return GlassCard(
      child: Column(
        children: [
          _buildSettingRow(
            icon: Icons.pets,
            label: '이름',
            value: _profile!.name,
            onTap: () => _editName(),
          ),
          const Divider(height: 24),
          _buildSettingRow(
            icon: Icons.category,
            label: '견종',
            value: breed?.nameKo ?? _profile!.breedId,
          ),
          const Divider(height: 24),
          _buildSettingRow(
            icon: Icons.cake,
            label: '생년월일',
            value:
                '${_profile!.birthDate.year}.${_profile!.birthDate.month}.${_profile!.birthDate.day}',
          ),
          const Divider(height: 24),
          _buildSettingRow(
            icon: Icons.monitor_weight,
            label: '체중',
            value: '${_profile!.weightKg} kg',
            onTap: () => _editWeight(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineSettings() {
    if (_profile == null) return const SizedBox.shrink();

    final allRoutines = [...DailyRoutine.defaults, ...DailyRoutine.optionals];
    final activeIds =
        _profile!.routines.map((r) => r.id).toSet();

    return GlassCard(
      child: Column(
        children: allRoutines.asMap().entries.map((entry) {
          final routine = entry.value;
          final isActive = activeIds.contains(routine.id);

          return Column(
            children: [
              if (entry.key > 0) const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(routine.icon,
                        color: isActive
                            ? AppConfig.accentColor
                            : Colors.white38,
                        size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        routine.name,
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.white54,
                        ),
                      ),
                    ),
                    Switch(
                      value: isActive,
                      activeColor: AppConfig.accentColor,
                      onChanged: (v) => _toggleRoutine(routine, v),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return GlassCard(
      child: Column(
        children: [
          _buildSettingRow(
            icon: Icons.notifications_outlined,
            label: '루틴 알림',
            trailing: Switch(
              value: true, // placeholder
              activeColor: AppConfig.accentColor,
              onChanged: (v) {
                // TODO: implement notification toggle
              },
            ),
          ),
          const Divider(height: 24),
          _buildSettingRow(
            icon: Icons.access_time,
            label: '아침 알림 시간',
            value: '08:00',
          ),
          const Divider(height: 24),
          _buildSettingRow(
            icon: Icons.access_time,
            label: '저녁 알림 시간',
            value: '18:00',
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings() {
    return GlassCard(
      child: Column(
        children: [
          _buildSettingRow(
            icon: Icons.dark_mode,
            label: '다크 모드',
            trailing: Switch(
              value: true,
              activeColor: AppConfig.accentColor,
              onChanged: null, // Always dark for now
            ),
          ),
          const Divider(height: 24),
          _buildSettingRow(
            icon: Icons.language,
            label: '언어',
            value: '한국어',
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return GlassCard(
      child: Column(
        children: [
          _buildSettingRow(
            icon: Icons.info_outline,
            label: '버전',
            value: '1.0.0',
          ),
          const Divider(height: 24),
          _buildSettingRow(
            icon: Icons.description_outlined,
            label: '면책 조항',
            onTap: () => _showDisclaimer(),
          ),
          const Divider(height: 24),
          _buildSettingRow(
            icon: Icons.source_outlined,
            label: '데이터 출처',
            onTap: () => _showSources(),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _confirmReset(),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
        ),
        child: const Text('데이터 초기화'),
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String label,
    String? value,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 15)),
          ),
          if (trailing != null)
            trailing
          else if (value != null)
            Text(value,
                style: const TextStyle(color: Colors.white54, fontSize: 14))
          else if (onTap != null)
            const Icon(Icons.chevron_right,
                color: Colors.white38, size: 20),
        ],
      ),
    );
  }

  // ─── Actions ───

  Future<void> _editName() async {
    final controller =
        TextEditingController(text: _profile!.name);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConfig.backgroundColor,
        title: const Text('이름 변경',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: '새 이름'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final updated = _profile!.copyWith(name: result);
      await _storageService.saveProfile(updated);
      await _loadData();
    }
  }

  Future<void> _editWeight() async {
    final controller = TextEditingController(
        text: _profile!.weightKg.toString());
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConfig.backgroundColor,
        title: const Text('체중 변경',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: '체중 (kg)',
            suffixText: 'kg',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (result != null) {
      final weight = double.tryParse(result);
      if (weight != null && weight > 0) {
        final updated = _profile!.copyWith(weightKg: weight);
        await _storageService.saveProfile(updated);
        await _loadData();
      }
    }
  }

  void _toggleRoutine(DailyRoutine routine, bool active) async {
    if (_profile == null) return;

    List<DailyRoutine> updatedRoutines;
    if (active) {
      updatedRoutines = [..._profile!.routines, routine];
    } else {
      updatedRoutines =
          _profile!.routines.where((r) => r.id != routine.id).toList();
    }

    final updated = _profile!.copyWith(routines: updatedRoutines);
    await _storageService.saveProfile(updated);
    await _loadData();
  }

  void _showDisclaimer() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConfig.backgroundColor,
        title: const Text('면책 조항',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Pet Life 앱에서 제공하는 건강 정보는 참고 목적으로만 제공되며, '
          '수의학적 진단이나 치료를 대체하지 않습니다.\n\n'
          '반려견의 건강에 관한 결정은 반드시 수의사와 상담하시기 바랍니다.\n\n'
          '건강 데이터는 학술 논문과 공인 기관의 통계를 기반으로 하며, '
          '개별 반려견에게 그대로 적용되지 않을 수 있습니다.',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('확인')),
        ],
      ),
    );
  }

  void _showSources() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConfig.backgroundColor,
        title: const Text('데이터 출처',
            style: TextStyle(color: Colors.white)),
        content: const SingleChildScrollView(
          child: Text(
            '• PMC: Life expectancy tables (13M+ dogs)\n'
            '  doi:10.3389/fvets.2023.1082102\n\n'
            '• UK Kennel Club mortality study (5,663 dogs)\n'
            '  doi:10.1186/s40575-018-0066-8\n\n'
            '• PLOS Genetics: 152 genetic disorders (100K+ dogs)\n'
            '  doi:10.1371/journal.pgen.1007361\n\n'
            '• CIDD: Canine Inherited Disorders Database\n'
            '  cidd.discoveryspace.ca\n\n'
            '• AVMA: Overweight dogs lifespan study (50K+ dogs)\n\n'
            '• Dog Aging Project — dogagingproject.org\n\n'
            '• AKC Breed Standards — akc.org\n\n'
            '• Human age formula: Tina Wang et al. (2019)\n'
            '  Cell Systems — 16 × ln(dog_age) + 31',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('확인')),
        ],
      ),
    );
  }

  void _confirmReset() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppConfig.backgroundColor,
        title: const Text('데이터 초기화',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          '모든 데이터가 삭제됩니다. 이 작업은 되돌릴 수 없습니다.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('취소')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _storageService.deleteProfile();
              await _storageService.setOnboardingComplete(false);
              await _storageService.saveLogs([]);
              if (mounted) {
                context.go('/onboarding');
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('초기화'),
          ),
        ],
      ),
    );
  }
}
