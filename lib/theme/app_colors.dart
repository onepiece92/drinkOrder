import 'package:flutter/material.dart';

/// Brand colour palette for La Petite Boulangerie.
/// Single source of truth — never hard-code colours elsewhere.
abstract final class AppColors {
  static const Color gold = Color(0xFFC9A55C);
  static const Color goldLight = Color(0xFFE4C780);
  static const Color goldDark = Color(0xFFA07D3A);
  static const Color background = Color(0xFF111111);
  static const Color card = Color(0xFF1E1E1E);
  static const Color text = Color(0xFFF5F0E8);
  static const Color textSecondary = Color(0xFF9A9590);
  static const Color textTertiary = Color(0xFF6B6560);
  static const Color border = Color(0x1FC9A55C); // rgba(201,165,92,.12)

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Gradient shortcuts
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldDark, gold, goldLight],
  );

  static const Gradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1510), Color(0xFF2A2015), Color(0xFF1A1510)],
  );

  static const Gradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, transparent],
  );
}
