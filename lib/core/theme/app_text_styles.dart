import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // AppBar
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 43 / 24,
    color: AppColors.textPrimary,
  );

  // Buttons
  static const TextStyle button = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  // Body
  static const TextStyle body = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // Small Text
  static const TextStyle small = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.0,
    color: AppColors.black,
  );

  // TextField
  static const TextStyle textField = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  // Numbers
  static const TextStyle number = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  // Error Message
  static const TextStyle errorMessage = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.0,
    color: AppColors.error,
  );
}
