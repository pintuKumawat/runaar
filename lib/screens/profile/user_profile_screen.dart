import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/core/utils/helpers/default_image/default_image.dart';
import 'package:runaar/models/profile/user_details_model.dart';
import 'package:runaar/provider/profile/user_details_provider.dart';
import 'package:runaar/screens/auth/login_screen.dart';
import 'package:runaar/screens/my_rides/my_rides_screen.dart';
import 'package:runaar/screens/profile/account/change_password_screen.dart';
import 'package:runaar/screens/profile/account/edit_profile_screen.dart';
import 'package:runaar/screens/profile/account/language_change_screen.dart';
import 'package:runaar/screens/subscription/subscription_screen.dart';
import 'package:runaar/screens/profile/account/verification_screen.dart';
import 'package:runaar/screens/profile/other/delete_account_screen.dart';
import 'package:runaar/screens/profile/other/refer_earn_screen.dart';
import 'package:runaar/screens/profile/other/wallet_screen.dart';
import 'package:runaar/screens/profile/vehicle/add_vehicle_screen.dart';
import 'package:runaar/screens/profile/vehicle/vehicle_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String userName = "Vinit Khatri";
  String userEmail = "vinit@gmail.com";
  String appVersion = "";
  double walletBalance = 1250.75;
  int referralPoints = 450;
  int userId = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getuserId().then((value) => loadData());
    });
    super.initState();

    _loadVersion();
  }

  Future<void> loadData() async {
    await context.read<UserDetailsProvider>().userDetails(userId: userId);
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = '${info.version}+${info.buildNumber}';
    });
  }

  Future<void> getuserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt(savedData.userId);
    setState(() {
      userId = id ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Consumer<UserDetailsProvider>(
      builder: (BuildContext context, userDetailsProvider, child) {
        final data = userDetailsProvider.response?.userDetail;
        return RefreshIndicator(
          onRefresh: loadData,
          child: Scaffold(
            appBar: AppBar(title: Text(data?.name ?? "name")),
            body: ListView(
              padding: 10.all,
              children: [
                _profileHeader(theme, data),
                10.height,

                /// WALLET & REFER CARDS
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Expanded(child: _referCard(theme, data)),
                    12.width,
                    Expanded(child: _walletCard(theme)),
                  ],
                ),

                12.height,
                _sectionTitle("Account", theme),
                _profileTile(Icons.person_outline, "Edit Profile", data, theme),
                _profileTile(Icons.subscriptions, "Subscription", data, theme),
                _profileTile(
                  Icons.lock_outline,
                  "Change Password",
                  data,
                  theme,
                ),
                _profileTile(Icons.language, "Language", data, theme),
                _profileTile(
                  Icons.verified_user_outlined,
                  "Verification",
                  data,
                  theme,
                ),

                12.height,
                _sectionTitle("Rides", theme),
                _profileTile(Icons.directions_car, "My Rides", data, theme),
                _profileTile(Icons.history, "Trip History", data, theme),

                12.height,

                _sectionTitle("Vehicle", theme),
                _profileTile(Icons.car_rental, "My Vehicles", data, theme),
                _profileTile(
                  Icons.add_circle_outline,
                  "Add Vehicle",
                  data,
                  theme,
                ),

                12.height,

                _sectionTitle("Support & Legal", theme),
                _profileTile(
                  Icons.support_agent,
                  "Contact Support",
                  data,
                  theme,
                ),
                _profileTile(Icons.help_outline, "FAQs", data, theme),
                _profileTile(
                  Icons.privacy_tip_outlined,
                  "Privacy Policy",
                  data,
                  theme,
                ),
                _profileTile(Icons.star_rate_outlined, "Rate App", data, theme),
                _profileTile(Icons.share_outlined, "Share App", data, theme),

                12.height,

                _sectionTitle("Danger Zone", theme),
                _profileTile(
                  Icons.delete_forever_outlined,
                  "Deactivate Account",
                  data,
                  theme,
                  danger: true,
                ),
                _profileTile(Icons.logout, "Logout", data, theme, danger: true),

                15.height,

                Center(
                  child: Text(
                    "App Version $appVersion",
                    style: theme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ),
                15.height,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _profileHeader(TextTheme theme, UserDetail? data) {
    return Container(
      decoration: BoxDecoration(
        color: appColor.themeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ListTile(
        contentPadding: 12.all,
        leading: defaultImage.userProvider(data?.profileImage, 30.r),
        title: Text(
          data?.name ?? "user",
          style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: RatingBarIndicator(
          rating: double.parse(data?.rating.toString() ?? "0.0"),
          itemBuilder: (context, index) =>
              Icon(Icons.star, color: Colors.amber),
          itemCount: 5,
          itemSize: 16.sp,
          unratedColor: Colors.grey.shade400,
          direction: Axis.horizontal,
        ),
      ),
    );
  }

  Widget _walletCard(TextTheme theme) {
    return Card(
      elevation: 3,

      color: appColor.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => appNavigator.push(WalletScreen()),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: appColor.secondColor,
                    size: 20.sp,
                  ),
                  8.width,
                  Text(
                    "₹${walletBalance.toStringAsFixed(2)}",
                    style: theme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: appColor.buttonColor,
                    ),
                  ),
                ],
              ),

              2.height,

              Text(
                "Wallet",
                style: theme.bodySmall?.copyWith(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _referCard(TextTheme theme, UserDetail? data) {
    return Card(
      elevation: 3,
      // shadowColor: Colors.black26,
      color: appColor.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () =>
            appNavigator.push(ReferEarnScreen(referCode: data?.referBy)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 10.h, // :arrow_left: compact height
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Row: Icon + Points
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_giftcard_rounded,
                    color: appColor.secondColor,
                    size: 20.sp,
                  ),
                  8.width,
                  Text(
                    "$referralPoints pts",
                    style: theme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              2.height, // :arrow_left: reduced spacing
              /// Label
              Text(
                "Refer & Earn",
                style: theme.bodySmall?.copyWith(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, TextTheme theme) {
    return Padding(
      padding: 6.vertical,
      child: Text(title, style: theme.titleMedium),
    );
  }

  Widget _profileTile(
    IconData icon,
    String title,
    UserDetail? data,
    TextTheme theme, {
    bool danger = false,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          size: 24.sp,
          color: danger ? Colors.red : appColor.mainColor,
        ),
        title: Text(
          title,
          style: theme.bodyLarge?.copyWith(
            color: danger ? Colors.red : appColor.textColor,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14.sp),
        onTap: () => _handleTap(title, data),
      ),
    );
  }

  void _handleTap(String title, UserDetail? data) {
    switch (title) {
      case "Edit Profile":
        appNavigator.push(
          EditProfileScreen(
            image: data?.profileImage,
            userId: userId,
            userName: data?.name,
            email: data?.email,
            dob: data?.dob,
            gender: data?.gender,
          ),
        );
        break;
      case "Change Password":
        appNavigator.push(ChangePasswordScreen(userId: userId));
        break;
        case "Subscription":
        // Navigate to Subscription Screen,
        appNavigator.push(SubscriptionScreen(userId: userId));
        break;
      case "Language":
        appNavigator.push(LanguageChangeScreen());
        break;
      case "Verification":
        appNavigator.push(
          VerificationScreen(
            isLicenceVerified: data?.isLicenceVerified,
            isDocumentVerified: data?.isDocumentVerified,
            isNumberVerified: data?.isNumberVerified,
            isEmailVerified: data?.isEmailVerified,
          ),
        );
        break;
      case "My Rides":
        appNavigator.push(MyRidesScreen(initialIndex: 0));
        break;
      case "Trip History":
        appNavigator.push(MyRidesScreen(initialIndex: 1));
        break;
      case "My Vehicles":
        appNavigator.push(VehicleListScreen(userId: userId));
        break;
      case "Add Vehicle":
        appNavigator.push(AddVehicleScreen(userId: userId));
        break;
      case "Deactivate Account":
        appNavigator.push(DeleteAccountScreen(userId: userId));
        break;
      case "Logout":
        _showLogoutSheet();
        break;
      default:
        break;
    }
  }

  void _showLogoutSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => Padding(
        padding: 20.all,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout, size: 40.sp, color: Colors.red.shade300),
            16.height,
            Text("Logout", style: Theme.of(context).textTheme.titleLarge),
            8.height,
            Text(
              "Are you sure you want to logout?",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            20.height,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                12.width,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _logout(),
                    // appNavigator.pushAndRemoveUntil(LoginScreen());
                    child: const Text("Logout"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(savedData.userId, 0);
    prefs.setBool(savedData.isLoggedIn, false);
    await Future.delayed(Duration(milliseconds: 300));
    appSnackbar.showSingleSnackbar(context, "Logout successfull");
    appNavigator.pushAndRemoveUntil(LoginScreen());
  }
}
