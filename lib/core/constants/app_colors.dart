import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevents instantiation

  // ================= BACKGROUND =================
  static const Color background = Color(0xFF000000); // main background
  static const Color surface = Color(0xFF121212);    // cards, lists
  static const Color surfaceDark = Color(0xFF1C1C1C); // dialogs, sheets

  // ================= PRIMARY (YELLOW) =================
  static const Color primary = Color(0xFFFFD400);     // main yellow
  static const Color primaryDark = Color(0xFFE6C200); // pressed state

  // ================= TEXT =================
  static const Color textPrimary = Color(0xFFFFFFFF); // headings
  static const Color textSecondary = Color(0xFFB3B3B3); // labels
  static const Color textMuted = Color(0xFF7A7A7A); // hints
  static const Color textThird = Color(0xFF3B82F6); // blue//forget_pass

  // ================= INPUT =================
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputText = Color(0xFF000000);
  static const Color inputHint = Color(0xFF9E9E9E);

  // ================= BUTTON =================
  static const Color buttonPrimary = primary;
  static const Color buttonDisabled = Color(0xFF4D4D4D);

  // ================= STATUS =================
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFFC107);
  static const Color danger = Color(0xFFFF4D4F); // delete / remove

  // ================= BORDER / DIVIDER =================
  static const Color divider = Color(0xFF2A2A2A);
  static const Color cardBackground = Color(0xFF111111);
  static const Color fieldBackground = Color(0xFF1C1C1E);
  static const Color primaryYellow = Color(0xFFFFE600);
  static const Color textGrey = Color(0xFF8E8E93);
  static const Color textWhite = Colors.white;
}
