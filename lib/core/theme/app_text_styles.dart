import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // =========================
  // HEADINGS (Appzee-style)
  // =========================

  /// Create Account
  static TextStyle heading20SemiBold = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0,
    color: const Color(0xFF111827),
  );

  /// Screen titles
  static TextStyle heading24Bold = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: const Color(0xFF111827),
  );

  // =========================
  // BODY TEXT
  // =========================

  static TextStyle body16Regular = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: const Color(0xFF374151),
  );

  static TextStyle body14Regular = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: const Color(0xFF6B7280),
  );

  // =========================
  // BUTTONS
  // =========================

  static TextStyle button16SemiBold = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: Colors.white,
  );

  // =========================
  // INPUT FIELDS
  // =========================

  static TextStyle input16Regular = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF111827),
  );

  static TextStyle hint14Regular = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF9CA3AF),
  );
}
