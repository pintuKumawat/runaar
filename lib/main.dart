import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:runaar/core/responsive/screen_util_setup.dart';
import 'package:runaar/core/theme/app_theme.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/screens/home/bottom_nav.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ScreenUtilSetup(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        ScreenUtil.init(context);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: widget!,
        );
      },
      title: 'Flutter Demo',
      navigatorKey: appNavigator.navigateKey,
      debugShowCheckedModeBanner: false,
      theme: appTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      home: BottomNav(),
    );
  }
}
