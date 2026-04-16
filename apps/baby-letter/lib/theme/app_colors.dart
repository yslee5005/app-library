import 'package:flutter/material.dart';

/// 아기의 편지 앱 컬러 시스템
/// 따뜻한 코랄 + 앰버 톤 — 의료 앱이 아닌 "편지를 받는" 감성
abstract final class AppColors {
  // Primary
  static const coral = Color(0xFFFF8A80);
  static const coralDark = Color(0xFFE57373);
  static const coralLight = Color(0xFFFFCDD2);

  // Secondary
  static const amber = Color(0xFFFFD54F);
  static const amberDark = Color(0xFFFFC107);
  static const amberLight = Color(0xFFFFF8E1);

  // Background & Surface
  static const cream = Color(0xFFFFF8E1);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFFFF3E0);

  // Text
  static const textPrimary = Color(0xFF3E2723);
  static const textSecondary = Color(0xFF8D6E63);
  static const textHint = Color(0xFFBCAAA4);

  // Semantic
  static const success = Color(0xFF81C784);
  static const successLight = Color(0xFFE8F5E9);
  static const warning = Color(0xFFFFD54F);
  static const warningLight = Color(0xFFFFF8E1);
  static const danger = Color(0xFFEF5350);
  static const dangerLight = Color(0xFFFFEBEE);
  static const info = Color(0xFF64B5F6);
  static const infoLight = Color(0xFFE3F2FD);

  // Specific
  static const letterCard = Color(0xFFFFF3E0);
  static const feedingBlue = Color(0xFF64B5F6);
  static const sleepPurple = Color(0xFFCE93D8);
  static const diaperGreen = Color(0xFF81C784);
}
