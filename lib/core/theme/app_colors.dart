import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8F8F8);
  static const Color lightPrimary = Color(0xFF000000);
  static const Color lightSecondary = Color(0xFF666666);
  static const Color lightAccent = Color(0xFF333333);
  static const Color lightBorder = Color(0xFFE5E5E5);
  static const Color lightText = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightCard = Color(0xFFFFFFFF);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkPrimary = Color(0xFFFFFFFF);
  static const Color darkSecondary = Color(0xFFB3B3B3);
  static const Color darkAccent = Color(0xFFE5E5E5);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkCard = Color(0xFF1A1A1A);
  
  // Common Colors
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFFCC00);
  static const Color info = Color(0xFF007AFF);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF333333)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
