import 'package:flutter/material.dart';
import 'package:tentwenty_app_test/config/constants/colors.dart';

class AppTheme {
// Light Theme
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.ghostWhite,

    /// =============== App  Bar ================
    appBarTheme: AppBarTheme(backgroundColor: AppColors.white),

    /// =============== Bottom Nav Bar ================
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.bottomNavigationBar,
      selectedItemColor: AppColors.lightSilver,
      unselectedItemColor: AppColors.silverGray,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: AppColors.silverGray,
      ),
      elevation: 0,
    ),
  );
}
