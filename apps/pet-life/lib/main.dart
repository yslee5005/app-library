import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'services/breed_data_service.dart';
import 'services/pet_storage_service.dart';
import 'theme/pet_life_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load breed data
  await BreedDataService().loadBreeds();

  // Check onboarding status
  final isOnboarded = await PetStorageService().isOnboardingComplete();

  runApp(PetLifeApp(isOnboarded: isOnboarded));
}

class PetLifeApp extends StatelessWidget {
  final bool isOnboarded;

  const PetLifeApp({super.key, required this.isOnboarded});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(isOnboarded: isOnboarded);

    return MaterialApp.router(
      title: 'Pet Life',
      debugShowCheckedModeBanner: false,
      theme: PetLifeTheme.darkTheme,
      routerConfig: appRouter.router,
    );
  }
}
