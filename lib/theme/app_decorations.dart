import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Shared decorations, shadows and border-radius constants for Liquid Gold.
abstract final class AppDecorations {
  // ─── Border Radii ───────────────────────────────────────────
  static const double radiusXS = 8.0;
  static const double radiusS = 10.0;
  static const double radiusSM = 12.0;
  static const double radiusM = 16.0;
  static const double radiusML = 20.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 32.0;
  static const double radiusXXL = 40.0;
  static const double radiusCard = 24.0;
  static const double radiusPill = 50.0;

  // ─── Box Shadows ────────────────────────────────────────────
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> cardShadowHovered = [
    BoxShadow(color: Color(0x3F000000), blurRadius: 20, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> goldGlow = [
    BoxShadow(color: Color(0x33C9A55C), blurRadius: 15, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> sheetShadow = [
    BoxShadow(color: Colors.black45, blurRadius: 40, offset: Offset(0, -10)),
  ];

  // ─── Common Decorations ─────────────────────────────────────
  static BoxDecoration get card => BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(radiusCard),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: cardShadow,
      );

  static BoxDecoration get cardHovered => BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(radiusCard),
        border:
            Border.all(color: AppColors.gold.withValues(alpha: 0.3), width: 1),
        boxShadow: cardShadowHovered,
      );

  static BoxDecoration get productImage => BoxDecoration(
        borderRadius: BorderRadius.circular(radiusM),
        color: AppColors.gold.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.1)),
      );

  static BoxDecoration get primaryButton => BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(radiusML),
        boxShadow: goldGlow,
      );

  static BoxDecoration get glassPill => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(radiusPill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      );

  static BoxDecoration get goldPill => BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(radiusPill),
        boxShadow: goldGlow,
      );

  static BoxDecoration get bottomSheet => const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radiusXXL),
          topRight: Radius.circular(radiusXXL),
        ),
      );
}
