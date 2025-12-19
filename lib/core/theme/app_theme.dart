import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart'
    show PlatformExtensions;
import 'package:runaar/core/theme/app_text.dart';

class AppTheme {
  ThemeData lightTheme(BuildContext context) {
    final customTextTheme = AppTextSize.getTextTheme(context);

    return ThemeData(
      brightness: Brightness.light,

      textTheme: GoogleFonts.interTextTheme(
        customTextTheme,
      ).apply(fontFamilyFallback: ['Noto Sans Devanagari']),

      scaffoldBackgroundColor: appColor.backgroundColor,

      colorScheme: ColorScheme.light(
        primary: appColor.mainColor,
        onPrimary: appColor.textColor,
        surface: appColor.themeColor,
        onSurface: appColor.textColor,
      ),

      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,

      dividerTheme: DividerThemeData(color: Colors.black45),

      appBarTheme: AppBarTheme(
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.textColor,
        centerTitle: true,
        elevation: 1,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
          ),
        ),
        titleTextStyle: customTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: appColor.backgroundColor,
        ),

        toolbarHeight: 45.h,

        actionsIconTheme: IconThemeData(
          color: appColor.backgroundColor,
          size: 20.sp,
        ),

        actionsPadding: EdgeInsets.only(right: 10.w),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appColor.themeColor,
        selectedItemColor: appColor.mainColor,

        selectedLabelStyle: customTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),

        type: BottomNavigationBarType.shifting,
        elevation: 2,
        landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
        unselectedItemColor: appColor.textColor.withOpacity(.5),

        unselectedLabelStyle: customTextTheme.bodyMedium,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          alignment: Alignment.center,

          //shape: WidgetStateOutlinedBorder.fromMap(),
          textStyle: WidgetStateTextStyle.resolveWith(
            (states) => customTextTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: context.isMobile
                  ? 20.sp
                  : context.isTablet
                  ? 13.sp
                  : 9.sp,
            ),
          ),

          backgroundColor: WidgetStateColor.resolveWith(
            (states) => appColor.mainColor,
          ),

          foregroundColor: WidgetStateColor.resolveWith(
            (states) => appColor.themeColor,
          ),
        ),
      ),

      tabBarTheme: TabBarThemeData(indicatorColor: appColor.textColor),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: appColor.mainColor.withOpacity(0.3),
        circularTrackColor: appColor.textColor,
      ),

      iconTheme: IconThemeData(color: appColor.textColor, size: 22.sp),

      inputDecorationTheme: InputDecorationThemeData(
        alignLabelWithHint: true,

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.r),
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColor.mainColor, width: 2.r),
          borderRadius: BorderRadius.circular(10.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.r),
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.r),
          borderRadius: BorderRadius.circular(10.r),
        ),

        floatingLabelBehavior: FloatingLabelBehavior.always,

        hintStyle: customTextTheme.bodyLarge?.copyWith(
          color: Colors.grey.shade600,
        ),

        labelStyle: customTextTheme.titleLarge?.copyWith(
          color: appColor.textColor,
        ),

        errorStyle: customTextTheme.bodyMedium?.copyWith(color: Colors.red),

        errorMaxLines: 2,

        prefixIconColor: appColor.textColor,
        suffixIconColor: appColor.textColor,
      ),

      snackBarTheme: SnackBarThemeData(
        contentTextStyle: customTextTheme.titleMedium,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey.shade800,
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateColor.resolveWith(
            (states) => appColor.textColor,
          ),
          textStyle: WidgetStateTextStyle.resolveWith(
            (states) => customTextTheme.titleLarge!.copyWith(
              fontSize: 18.sp, // 🔥 responsive
            ),
          ),
          iconSize: WidgetStatePropertyAll(24.sp), // 🔥 responsive
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white70,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shadowColor: appColor.mainColor.withOpacity(0.5),
        margin: .all(5.w), // 🔥 responsive
        shape: RoundedRectangleBorder(
          borderRadius: .circular(8.r)
        )
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: Colors.black87,
        titleTextStyle: customTextTheme.titleLarge!.copyWith(
          fontSize: 18.sp, // 🔥 responsive
        ),
      ),
    );
  }
}

final AppTheme appTheme = AppTheme();
