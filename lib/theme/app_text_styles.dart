import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system using DM Serif Display (headings) + DM Sans (body).
/// Single source of truth — never define TextStyles inline.
abstract final class AppTextStyles {
  // ─── Heading / Playfair Display ─────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.5,
  );

  static TextStyle get h1 => displayLarge;

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    letterSpacing: -0.5,
  );

  static TextStyle get h2 => displayMedium;

  static TextStyle get headlineLarge => GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static TextStyle get headlineMedium => GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static TextStyle get h3 => headlineMedium;

  static TextStyle get headlineSmall => GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static TextStyle get titleLarge => GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  // ─── Sub-title / Cormorant Garamond ─────────────────────────
  static TextStyle get subtitleItalic => GoogleFonts.cormorantGaramond(
    fontSize: 17,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    color: AppColors.textSecondary,
  );

  // ─── Body / Outfit ──────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.outfit(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static TextStyle get bodyMedium => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static TextStyle get bodySmall => GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get label => GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 2.5,
  );

  static TextStyle get labelSmall => GoogleFonts.outfit(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
  );

  static TextStyle get caption => GoogleFonts.outfit(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    letterSpacing: 0.3,
  );

  static TextStyle get price => GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.goldLight,
  );

  static TextStyle get priceLarge => GoogleFonts.playfairDisplay(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.goldLight,
  );

  static TextStyle get buttonPrimary => GoogleFonts.outfit(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    letterSpacing: 1.0,
  );

  static TextStyle get navLabel =>
      GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w400);
}
