import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // =========================
  // HEADINGS
  // =========================

  /// Screen title / AppBar
  static TextStyle heading24Bold = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: const Color(0xFF111827),
  );

  /// Section title
  static TextStyle heading20SemiBold = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: const Color(0xFF111827),
  );

  /// Card title
  static TextStyle heading18SemiBold = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: const Color(0xFF111827),
  );

  /// Small heading
  static TextStyle heading16SemiBold = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: const Color(0xFF111827),
  );

  // =========================
  // BODY TEXT
  // =========================

  static TextStyle body16Regular = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: const Color(0xFF374151),
  );

  static TextStyle body16SemiBold = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: const Color(0xFF374151),
  );

  static TextStyle body14Regular = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: const Color(0xFF6B7280),
  );

  static TextStyle body14Medium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.45,
    color: const Color(0xFF4B5563),
  );

  static TextStyle body14SemiBold = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: const Color(0xFF374151),
  );

  // =========================
  // CAPTION / LABEL
  // =========================

  static TextStyle caption12Regular = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: const Color(0xFF9CA3AF),
  );

  static TextStyle label12Medium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: const Color(0xFF6B7280),
  );

  static TextStyle overline10Medium = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
    color: const Color(0xFF9CA3AF),
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

  static TextStyle button14Medium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
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

  static TextStyle error12Regular = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: const Color(0xFFDC2626),
  );

  // =========================
  // LINKS / STATUS
  // =========================

  static TextStyle link14Medium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF2563EB),
  );

  static TextStyle success14Medium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF16A34A),
  );

  static TextStyle warning14Medium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xFFF59E0B),
  );

  // =========================
  // CHIP / BADGE
  // =========================

  static TextStyle badge12SemiBold = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: Colors.white,
  );
}
