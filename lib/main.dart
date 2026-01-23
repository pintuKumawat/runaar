import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/screen_util_setup.dart';
import 'package:runaar/core/services/notification_service.dart';
import 'package:runaar/core/theme/app_theme.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/firebase_options.dart';
import 'package:runaar/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:runaar/provider/auth/forgot_password_provider.dart';
import 'package:runaar/provider/auth/otp_verify_provider.dart';
import 'package:runaar/provider/auth/reset_password_provider.dart';
import 'package:runaar/provider/home/booking_request_provider.dart';
import 'package:runaar/provider/home/home_provider.dart';
import 'package:runaar/provider/language/language_provider.dart';
import 'package:runaar/provider/auth/login_provider.dart';
import 'package:runaar/provider/auth/signup_provider.dart';
import 'package:runaar/provider/my_rides/booking_detail_provider.dart';
import 'package:runaar/provider/my_rides/booking_list_provider.dart';
import 'package:runaar/provider/my_rides/passenger_published_list_provider.dart';
import 'package:runaar/provider/my_rides/published_detail_model.dart';
import 'package:runaar/provider/my_rides/published_list_provider.dart';
import 'package:runaar/provider/my_rides/request_list_provider.dart';
import 'package:runaar/provider/my_rides/request_response_provider.dart';
import 'package:runaar/provider/my_rides/trip_status_update_provider.dart';
import 'package:runaar/provider/notification/notification_provider.dart';
import 'package:runaar/provider/profile/account/change_password_provider.dart';
import 'package:runaar/provider/subscription/active_subscription_provider.dart';
import 'package:runaar/provider/subscription/subscription_create_provider.dart';
import 'package:runaar/provider/subscription/subscription_provider.dart';
import 'package:runaar/provider/profile/account/user_deactivate_provider.dart';
import 'package:runaar/provider/profile/user_details_provider.dart';
import 'package:runaar/provider/profile/user_profile_update_provider.dart';
import 'package:runaar/provider/subscription/subscription_status_provider.dart';
import 'package:runaar/provider/subscription/subscription_verify_provider.dart';
import 'package:runaar/provider/vehicle/active_vehicle_provider.dart';
import 'package:runaar/provider/vehicle/add_vehicle_provider.dart';
import 'package:runaar/provider/offerProvider/offer_provider.dart';
import 'package:runaar/provider/vehicle/delete_vehicle_provider.dart';
import 'package:runaar/provider/vehicle/vehicle_details_provider.dart';
import 'package:runaar/provider/vehicle/vehicle_list_provider.dart';
import 'package:runaar/screens/auth/login_screen.dart';
import 'package:runaar/screens/auth/sign_up_screen.dart';
import 'package:runaar/screens/home/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📨 Background Notification: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AddVehicleProvider()),
        ChangeNotifierProvider(create: (_) => OfferProvider()),
        ChangeNotifierProvider(create: (_) => DeleteVehicleProvider()),
        ChangeNotifierProvider(create: (_) => VehicleDetailsProvider()),
        ChangeNotifierProvider(create: (_) => DeleteVehicleProvider()),
        ChangeNotifierProvider(create: (_) => VehicleListProvider()),
        ChangeNotifierProvider(create: (_) => PublishedListProvider()),
        ChangeNotifierProvider(create: (_) => PublishedDetailProvier()),
        ChangeNotifierProvider(create: (_) => BookingListProvider()),
        ChangeNotifierProvider(create: (_) => BookingDetailProvider()),
        ChangeNotifierProvider(create: (_) => RequestListProvider()),
        ChangeNotifierProvider(create: (_) => PassengerPublishedListProvider()),
        ChangeNotifierProvider(create: (_) => BookingRequestProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileUpdateProvider()),
        ChangeNotifierProvider(create: (_) => UserDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => UserDeactivateProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_) => OtpVerifyProvider()),
        ChangeNotifierProvider(create: (_) => TripStatusUpdateProvider()),
        ChangeNotifierProvider(create: (_) => RequestResponseProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionCreateProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionVerifyProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionStatusProvider()),
        ChangeNotifierProvider(create: (_) => ActiveSubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => ActiveVehicleProvider()),
      ],
      child: const ScreenUtilSetup(child: MyApp()),
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isLoggedIn;
  bool? isFirstLaunch;

  Future<void> _loadAppState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoggedIn = prefs.getBool(savedData.isLoggedIn);
      isFirstLaunch = prefs.getBool(savedData.isFirstLauch);
    });

    debugPrint(
      "🚀 App Started | isLoggedIn: $isLoggedIn | firstLaunch: $isFirstLaunch ",
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAppState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await NotificationService.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, lanProvider, child) {
        final locale = lanProvider.appLocale ?? const Locale("en");
        return SafeArea(
          child: MaterialApp(
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
            home: _getHome(),
            // home: const InvoicePage(),
          ),
        );
      },
    );
  }

  Widget _getHome() {
    if (isFirstLaunch ?? true) {
      return SignupScreen();
    }

    if (isLoggedIn ?? false) {
      return const BottomNav(initialIndex: 2);
    }

    return const LoginScreen();
  }
}
