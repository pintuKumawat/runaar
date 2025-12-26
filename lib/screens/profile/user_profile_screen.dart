import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/screens/auth/login_screen.dart';
import 'package:runaar/screens/my_rides/my_rides_screen.dart';
import 'package:runaar/screens/profile/account/change_password_screen.dart';
import 'package:runaar/screens/profile/account/edit_profile_screen.dart';
import 'package:runaar/screens/profile/account/language_change_screen.dart';
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


   Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(userName)),
      body: ListView(
        padding: 10.all,
        children: [
          _profileHeader(theme),
          10.height,

          /// WALLET & REFER CARDS
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(child: _referCard(theme)),
              12.width,
              Expanded(child: _walletCard(theme)),
            ],
          ),

          12.height,
          _sectionTitle("Account", theme),
          _profileTile(Icons.person_outline, "Edit Profile", theme),
          _profileTile(Icons.lock_outline, "Change Password", theme),
          _profileTile(Icons.language, "Language", theme),
          _profileTile(Icons.verified_user_outlined, "Verification", theme),

          12.height,
          _sectionTitle("Rides", theme),
          _profileTile(Icons.directions_car, "My Rides", theme),
          _profileTile(Icons.history, "Trip History", theme),

          12.height,

          _sectionTitle("Vehicle", theme),
          _profileTile(Icons.car_rental, "My Vehicles", theme),
          _profileTile(Icons.add_circle_outline, "Add Vehicle", theme),

          12.height,

          _sectionTitle("Support & Legal", theme),
          _profileTile(Icons.support_agent, "Contact Support", theme),
          _profileTile(Icons.help_outline, "FAQs", theme),
          _profileTile(Icons.privacy_tip_outlined, "Privacy Policy", theme),
          _profileTile(Icons.star_rate_outlined, "Rate App", theme),
          _profileTile(Icons.share_outlined, "Share App", theme),

          12.height,

          _sectionTitle("Danger Zone", theme),
          _profileTile(
            Icons.delete_forever_outlined,
            "Deactivate Account",
            theme,
            danger: true,
          ),
          _profileTile(Icons.logout, "Logout", theme, danger: true),

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
    );
  }

  Widget _profileHeader(TextTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: appColor.themeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ListTile(
        contentPadding: 12.all,
        leading: CircleAvatar(
          radius: 28.r,
          backgroundColor: appColor.backgroundColor,
          child: Icon(Icons.person, size: 30.sp, color: appColor.mainColor),
        ),
        title: Text(
          userName,
          style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            RatingBarIndicator(
              rating: 4.6,
              itemBuilder: (context, index) =>
                  Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 16.sp,
              unratedColor: Colors.grey.shade300,
              direction: Axis.horizontal,
            ),
            3.width,
            Text("(4.6)", style: theme.bodySmall),
          ],
        ),
        onTap: () {
          // Navigate to profile details
        },
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
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 10.h, // :arrow_left: reduced height
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Row: Icon + Balance
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

  Widget _referCard(TextTheme theme) {
    return Card(
      elevation: 3,
      // shadowColor: Colors.black26,
      color: appColor.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => appNavigator.push(ReferEarnScreen()),
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
        onTap: () => _handleTap(title),
      ),
    );
  }

  void _handleTap(String title) {
    switch (title) {
      case "Edit Profile":
        appNavigator.push(EditProfileScreen(userId: 1));
        break;
      case "Change Password":
        appNavigator.push(ChangePasswordScreen(userId: 1));
        break;
      case "Language":
        appNavigator.push(LanguageChangeScreen());
        break;
      case "Verification":
        appNavigator.push(VerificationScreen());
        break;
      case "My Rides":
        appNavigator.push(MyRidesScreen(initialIndex: 0));
        break;
      case "Trip History":
        appNavigator.push(MyRidesScreen(initialIndex: 1));
        break;
      case "My Vehicles":
        appNavigator.push(VehicleListScreen(userId: 1));
        break;
      case "Add Vehicle":
        appNavigator.push(AddVehicleScreen(userId: 1));
        break;
      case "Deactivate Account":
        appNavigator.push(DeleteAccountScreen(userId: 1));
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
