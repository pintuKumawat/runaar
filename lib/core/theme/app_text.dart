import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:runaar/core/constants/app_color.dart';

class AppTextSize {
  AppTextSize._();

  static TextTheme getTextTheme(BuildContext context) {
    return TextTheme(
      headlineLarge: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),

      headlineSmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.normal,
        color: appColor.textColor,
      ),

      titleLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.normal,
        color: appColor.textColor,
      ),

      titleMedium: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: appColor.textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: appColor.textColor,
      ),

      bodyLarge: TextStyle(fontSize: 18.sp, color: appColor.textColor),

      bodyMedium: TextStyle(fontSize: 16.sp, color: appColor.textColor),

      bodySmall: TextStyle(
        fontSize: 14.sp,
        color: appColor.textColor.withOpacity(0.8),
      ),
    );
  }
}
