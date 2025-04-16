import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  AppTheme._();

  static final dark = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: AppColors.kPrimaryColor,
    ),
    scaffoldBackgroundColor: AppColors.kPrimaryColor,
    primaryColor: AppColors.kPrimaryColor,
    appBarTheme: AppBarTheme(
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: AppColors.kPrimaryColor,
      iconTheme: IconThemeData(
        color: AppColors.kWhiteColor,
      ),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.kPrimaryColor,
      surfaceTintColor:AppColors.kPrimaryColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.kWhiteColor.withAlpha(200),
      ),
    ),
  );
}
