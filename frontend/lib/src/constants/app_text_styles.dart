import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final headline = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
  static final body = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );
  static final button = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
  static final caption = GoogleFonts.roboto(
    fontSize: 13,
    color: AppColors.textLight,
  );
  static final appBarTitle = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: -0.5,
  );
  static final sectionTitle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static final subtext = GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.subtextGray,
  );
} 