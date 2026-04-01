import 'package:flutter/material.dart';

/// Border radius constants for consistent rounding.
abstract final class AppRadius {
  /// 4.0
  static const double sm = 4.0;

  /// 8.0
  static const double md = 8.0;

  /// 12.0
  static const double lg = 12.0;

  /// 16.0
  static const double xl = 16.0;

  /// Circular [BorderRadius] helpers.
  static final BorderRadius smAll = BorderRadius.circular(sm);
  static final BorderRadius mdAll = BorderRadius.circular(md);
  static final BorderRadius lgAll = BorderRadius.circular(lg);
  static final BorderRadius xlAll = BorderRadius.circular(xl);
}
