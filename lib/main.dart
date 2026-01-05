import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/responsive/screen_util_setup.dart';
import 'package:runaar/core/theme/app_theme.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/firebase_options.dart';
import 'package:runaar/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:runaar/provider/auth/forgot_password_provider.dart';
import 'package:runaar/provider/auth/otp_verify_provider.dart';
import 'package:runaar/provider/home/booking_request_provider.dart';
import 'package:runaar/provider/home/home_provider.dart';
import 'package:runaar/provider/language/language_provider.dart';
import 'package:runaar/provider/auth/login_provider.dart';
import 'package:runaar/provider/auth/signup_provider.dart';
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
import 'package:runaar/provider/profile/account/reset_password_provider.dart';
import 'package:runaar/provider/profile/account/user_deactivate_provider.dart';
import 'package:runaar/provider/profile/user_details_provider.dart';
import 'package:runaar/provider/profile/user_profile_update_provider.dart';
import 'package:runaar/provider/vehicle/add_vehicle_provider.dart';
import 'package:runaar/provider/offerProvider/offer_provider.dart';
import 'package:runaar/provider/vehicle/delete_vehicle_provider.dart';
import 'package:runaar/provider/vehicle/vehicle_details_provider.dart';
import 'package:runaar/provider/vehicle/vehicle_list_provider.dart';
import 'package:runaar/screens/auth/login_screen.dart';
import 'package:runaar/screens/auth/sign_up_screen.dart';
import 'package:runaar/screens/home/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        ChangeNotifierProvider(create: (_)=>UserDetailsProvider()),
        ChangeNotifierProvider(create: (_)=>ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_)=>UserDeactivateProvider()),
        ChangeNotifierProvider(create: (_)=>ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_)=>OtpVerifyProvider())
      ],
      child: const ScreenUtilSetup(child: MyApp()),
    ),
  );
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

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
        leading: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Image.asset(
            "assets/images/logo.png",
            height: 28,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _invoiceHeader(theme),
            const SizedBox(height: 16),
            _customerDetails(theme),
            const SizedBox(height: 16),
            _itemTable(theme),
            const SizedBox(height: 16),
            _totalSection(theme),
          ],
        ),
      ),
    );
  }

  /// -------- Invoice Header --------
  Widget _invoiceHeader(TextTheme theme) {
    return Text("Date: 06 Jan 2026", style: theme.titleMedium);
  }

  /// -------- Customer Details --------
  Widget _customerDetails(TextTheme theme) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Billed To",
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text("Vinit Khatri", style: theme.bodyMedium),
            Text("vinit@email.com", style: theme.bodyMedium),
            Text("+91 9XXXXXXXXX", style: theme.bodyMedium),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Billed To",
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text("Vinit Khatri", style: theme.bodyMedium),
            Text("vinit@email.com", style: theme.bodyMedium),
            Text("+91 9XXXXXXXXX", style: theme.bodyMedium),
          ],
        ),
      ],
    );
  }

  /// -------- Items Table --------
  Widget _itemTable(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 12.all,
        child: Column(
          children: [
            _tableRow(
              theme,
              title: "Product",
              qty: "Qty",
              price: "Price",
              isHeader: true,
            ),
            const Divider(),
            _tableRow(
              theme,
              title: "Custom MDF Frame",
              qty: "1",
              price: "₹799",
            ),
            _tableRow(theme, title: "Printed Pillow", qty: "2", price: "₹998"),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(
    TextTheme theme, {
    required String title,
    required String qty,
    required String price,
    bool isHeader = false,
  }) {
    final style = isHeader
        ? theme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
        : theme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text(title, style: style)),
          Expanded(flex: 2, child: Text(qty, style: style)),
          Expanded(
            flex: 2,
            child: Text(price, style: style, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  /// -------- Total Section --------
  Widget _totalSection(TextTheme theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: .end,
            children: [
              _amountRow(theme, "Subtotal", "₹1797"),
              _amountRow(theme, "Delivery", "₹50"),
              const Divider(),
              _amountRow(theme, "Total", "₹1847", isBold: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _amountRow(
    TextTheme theme,
    String label,
    String value, {
    bool isBold = false,
  }) {
    final style = isBold
        ? theme.titleMedium?.copyWith(fontWeight: FontWeight.w600)
        : theme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
