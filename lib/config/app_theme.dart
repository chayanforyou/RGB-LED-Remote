import 'package:flutter/material.dart';
import 'package:rgbremote/config/app_color.dart';

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
  );
}
