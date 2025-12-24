import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/screen_util_setup.dart';
import 'package:runaar/core/theme/app_theme.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:runaar/provider/home_provider.dart';
import 'package:runaar/provider/language_provider.dart';
import 'package:runaar/provider/auth/validate/login_provider.dart';
import 'package:runaar/provider/auth/validate/signup_provider.dart';
import 'package:runaar/screens/auth/login_screen.dart';
import 'package:runaar/screens/home/web_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),

        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_)=>HomeProvider()),
      ],
      child: const ScreenUtilSetup(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, lanProvider, child) {
        // If no language selected yet → set English
        final locale = lanProvider.appLocale ?? const Locale("en");
        return SafeArea(
          child: MaterialApp(
            // navigatorKey: navigatorKey,
            locale: locale,
            supportedLocales: const [Locale('en'), Locale('hi')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

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
            home:LoginScreen(),
            //LocalWebViewScreen()
            // LoginScreen(),
          ),
        );
      },
    );
  }
}
