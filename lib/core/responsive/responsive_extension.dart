import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ------- SIZE EXTENSIONS (w, h, sp, r) -------
extension SizeExtensions on num {
  double get w => ScreenUtil().setWidth(toDouble());
  double get h => ScreenUtil().setHeight(toDouble());
  double get sp => ScreenUtil().setSp(toDouble());
  double get r => ScreenUtil().radius(toDouble());

  SizedBox get height => SizedBox(height: ScreenUtil().setHeight(toDouble()));
  SizedBox get width => SizedBox(width: ScreenUtil().setWidth(toDouble()));
}

/// ------- PADDING EXTENSIONS -------
extension PaddingExtensions on num {
  EdgeInsets get all => EdgeInsets.all(ScreenUtil().setWidth(toDouble()));
  EdgeInsets get horizontal =>
      EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(toDouble()));
  EdgeInsets get vertical =>
      EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(toDouble()));
  EdgeInsets hv(double v) => EdgeInsets.symmetric(
    horizontal: ScreenUtil().setWidth(toDouble()),
    vertical: ScreenUtil().setHeight(v),
  );
}

/// ------- PLATFORM EXTENSIONS -------
extension PlatformExtensions on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 600;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= 600 &&
      MediaQuery.of(this).size.width < 1024;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1024;
  double get textScale => MediaQuery.textScaleFactorOf(this).clamp(1.0, 1.3);

  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;
  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;
  bool get isMac => Theme.of(this).platform == TargetPlatform.macOS;
  bool get isWindows => Theme.of(this).platform == TargetPlatform.windows;

}
