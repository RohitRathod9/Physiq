import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// A stub for the app's design system.

class AppColors {
  static const Color background = Color(0xFFF5F1ED);
  static const Color primary = Color(0xFF000000);
  static const Color card = Colors.white;
  static const Color secondaryText = Color(0xFF7B7B7B);
}

class AppTextStyles {
  static final TextStyle h1 = GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary);
  static final TextStyle button = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white);
}
