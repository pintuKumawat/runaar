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

      // textTheme: GoogleFonts.interTextTheme(
      //   customTextTheme,
      // ).apply(fontFamilyFallback: ['Noto Sans Devanagari']),
      textTheme: GoogleFonts.interTextTheme(
        customTextTheme,
      ).apply(fontFamilyFallback: ['sans-serif']),

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

        actionsPadding: .only(right: 10.w),
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
        color: appColor.buttonColor,
        circularTrackColor: appColor.textColor,
      ),

      iconTheme: IconThemeData(color: appColor.textColor, size: 22.sp),

      inputDecorationTheme: InputDecorationThemeData(
        alignLabelWithHint: true,
        fillColor: Colors.white70,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: .5.r),
          // borderRadius: .circular(14.r),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: appColor.mainColor, width: 1.r),
          // borderRadius: .circular(14.r),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.r),
          // borderRadius: .circular(14.r),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.r),
          // borderRadius: .circular(14.r),
        ),

        floatingLabelBehavior: FloatingLabelBehavior.always,

        hintStyle: customTextTheme.bodyLarge?.copyWith(
          color: Colors.grey.shade600,
        ),

        labelStyle: customTextTheme.titleLarge?.copyWith(
          color: appColor.textColor,
        ),

        errorStyle: customTextTheme.bodySmall?.copyWith(color: Colors.red),

        errorMaxLines: 1,

        prefixIconColor: appColor.textColor,
        suffixIconColor: appColor.textColor,
      ),

      snackBarTheme: SnackBarThemeData(
        contentTextStyle: customTextTheme.titleMedium?.copyWith(
          color: appColor.buttonColor,
        ),
        backgroundColor: appColor.mainColor,
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

      popupMenuTheme: PopupMenuThemeData(color: Colors.white, iconSize: 22.sp),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: customTextTheme.labelMedium,
      ),
    );
  }
}

final AppTheme appTheme = AppTheme();
