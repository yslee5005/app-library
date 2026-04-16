import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Anonymous-First 인증 (signInAnonymously)
  // TODO: Supabase 초기화

  runApp(
    const ProviderScope(
      child: BabyLetterApp(),
    ),
  );
}
