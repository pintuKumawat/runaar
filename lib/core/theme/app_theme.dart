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

      dividerTheme: DividerThemeData(color: Colors.black12),

      appBarTheme: AppBarTheme(
        backgroundColor: appColor.mainColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,

        // shape: RoundedRectangleBorder(
        //   borderRadius: .only(
        //     bottomLeft: Radius.circular(15.r),
        //     bottomRight: Radius.circular(15.r),
        //   ),
        // ),
        titleTextStyle: customTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: appColor.buttonColor),
        toolbarHeight: 45.h,

        actionsIconTheme: IconThemeData(
          color: appColor.backgroundColor,
          size: 20.sp,
        ),

        actionsPadding: EdgeInsets.only(right: 10.w),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,

        backgroundColor: appColor.mainColor,
        selectedItemColor: appColor.buttonColor,
        selectedIconTheme: IconThemeData(
          color: appColor.buttonColor,
          size: 24.sp,
        ),
        unselectedIconTheme: IconThemeData(color: Colors.white60, size: 22.sp),
        selectedLabelStyle: TextStyle(
          fontWeight: .w600,
          color: Colors.white,
          fontSize: 12.sp,
        ),

        type: BottomNavigationBarType.fixed,
        unselectedItemColor: appColor.buttonColor.withOpacity(.5),

        unselectedLabelStyle: TextStyle(
          fontWeight: .w400,
          color: Colors.white60,
          fontSize: 12.sp,
        ),
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
            (states) => Colors.white,
          ),
        ),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),

      tabBarTheme: TabBarThemeData(
        indicatorColor: appColor.buttonColor,
        labelColor: appColor.buttonColor,
        unselectedLabelColor: appColor.buttonColor,
        unselectedLabelStyle: customTextTheme.labelMedium?.copyWith(
          color: appColor.buttonColor,
        ),
        labelStyle: customTextTheme.titleMedium?.copyWith(
          color: appColor.buttonColor,
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: appColor.mainColor.withOpacity(0.3),
        circularTrackColor: appColor.textColor,
      ),

      iconTheme: IconThemeData(color: appColor.textColor, size: 22.sp),

      inputDecorationTheme: InputDecorationThemeData(
        alignLabelWithHint: true,
        fillColor: Colors.white70,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.r),
          borderRadius: .circular(14.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColor.mainColor, width: 2.r),
          borderRadius: .circular(14.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.r),
          borderRadius: .circular(14.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.r),
          borderRadius: .circular(14.r),
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
          iconSize: WidgetStatePropertyAll(24.sp),
        ),
      ),

      cardTheme: CardThemeData(
        color: Color.fromARGB(255, 239, 239, 239),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: .all(5.w), // 🔥 responsive
        shape: RoundedRectangleBorder(borderRadius: .circular(0.r)),
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
