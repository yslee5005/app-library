import 'package:flutter/material.dart';
import 'home_pregnant_view.dart';

/// B1/B2. 홈탭 메인
/// 임신 중 / 출산 후 분기
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: UserState에서 모드 가져오기
    // 지금은 임신 중 모드를 기본으로 표시
    return const HomePregnantView(currentWeek: 24);
  }
}
