// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';

// import 'package:runaar/core/constants/app_color.dart';
// import 'package:runaar/core/responsive/responsive_extension.dart';

// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});

//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   File? pickedImage;

//   /// MOCK DATA
//   final String name = "Vinit Khatri";
//   final String imageUrl =
//       "https://static.vecteezy.com/system/resources/previews/029/364/941/non_2x/3d-carton-of-boy-going-to-school-ai-photo.jpg";
//   final double rating = 4.3;
//   final int age = 22;
//   final int rides = 18;
//   final DateTime joined = DateTime(2023, 5);

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings, size: 22.sp),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         color: appColor.mainColor,
//         onRefresh: () async {},
//         child: ListView(
//           padding: 10.all,
//           children: [
//             _profileHeader(context, textTheme),
//             4.height,
//             const Divider(),
//             4.height,
//             _sectionCard(
//               context,
//               title: "Ride Preferences",
//               trailing: Icon(Icons.edit, color: appColor.mainColor),
//               children: [
//                 _preferenceRow(Icons.chat, "Chatty", textTheme),
//                 _preferenceRow(Icons.music_note, "Likes Music", textTheme),
//                 _preferenceRow(Icons.smoke_free, "No Smoking", textTheme),
//               ],
//             ),

//             _sectionCard(
//               context,
//               title: "Verifications",
//               children: [
//                 _verifyRow("Government ID", true, textTheme),
//                 _verifyRow("Driving License", true, textTheme),
//                 _verifyRow("Email", true, textTheme),
//                 _verifyRow("Phone", true, textTheme),
//               ],
//             ),

//             _sectionCard(
//               context,
//               title: "Statistics",
//               children: [
//                 _infoRow(Icons.route, "$rides rides published", textTheme),
//                 _infoRow(
//                   Icons.calendar_month,
//                   "Member since ${DateFormat('MMM yyyy').format(joined)}",
//                   textTheme,
//                 ),
//               ],
//             ),

//             12.height,

//             TextButton(
//               onPressed: () {},
//               child: Text(
//                 "+ Add New Vehicle",
//                 style: textTheme.titleMedium?.copyWith(
//                   color: appColor.secondColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             40.height,
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= PROFILE HEADER =================

//   Widget _profileHeader(BuildContext context, TextTheme textTheme) {
//     return Container(
//       padding: 10.all,
//       decoration: BoxDecoration(
//         color: appColor.themeColor.withOpacity(0.35),
//         borderRadius: BorderRadius.circular(18.r),
//       ),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               CircleAvatar(
//                 radius: 46.r,
//                 backgroundColor: appColor.backgroundColor,
//                 child: ClipOval(
//                   child: CachedNetworkImage(
//                     imageUrl: imageUrl,
//                     width: 92.w,
//                     height: 92.h,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: Container(
//                   padding: 6.all,
//                   decoration: BoxDecoration(
//                     color: appColor.mainColor,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.camera_alt,
//                     size: 16.sp,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           12.height,

//           Text(
//             name,
//             style: textTheme.titleLarge?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: appColor.mainColor,
//             ),
//           ),

//           4.height,

//           Text("$age years", style: textTheme.bodySmall),

//           8.height,

//           RatingBarIndicator(
//             rating: rating,
//             itemBuilder: (_, _) =>
//                 Icon(Icons.star, color: appColor.secondColor),
//             itemSize: 20.sp,
//           ),

//           6.height,

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FaIcon(
//                 FontAwesomeIcons.award,
//                 size: 16.sp,
//                 color: appColor.secondColor,
//               ),
//               6.width,
//               Text(
//                 "Intermediate",
//                 style: textTheme.bodyMedium?.copyWith(
//                   color: appColor.secondColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ================= SECTION CARD =================

//   Widget _sectionCard(
//     BuildContext context, {
//     required String title,
//     required List<Widget> children,
//     Widget? trailing,
//   }) {
//     final textTheme = Theme.of(context).textTheme;

//     return Container(
//       // margin: 8.vertical,
//       padding: 10.all,
//       decoration: BoxDecoration(
//         color: appColor.backgroundColor,
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: appColor.mainColor,
//                 ),
//               ),
//               if (trailing != null) trailing,
//             ],
//           ),
//           3.height,
//           ...children,
//           3.height,
//           const Divider(),
//         ],
//       ),
//     );
//   }

//   // ================= ROW HELPERS =================

//   Widget _infoRow(IconData icon, String text, TextTheme textTheme) {
//     return Padding(
//       padding: 6.vertical,
//       child: Row(
//         children: [
//           Icon(icon, size: 18.sp, color: appColor.mainColor),
//           8.width,
//           Expanded(child: Text(text, style: textTheme.bodyMedium)),
//         ],
//       ),
//     );
//   }

//   Widget _preferenceRow(IconData icon, String text, TextTheme textTheme) {
//     return Padding(
//       padding: 4.vertical,
//       child: Row(
//         children: [
//           Icon(icon, size: 18.sp),
//           8.width,
//           Expanded(child: Text(text, style: textTheme.bodyMedium)),
//         ],
//       ),
//     );
//   }

//   Widget _verifyRow(String text, bool verified, TextTheme textTheme) {
//     return Padding(
//       padding: 4.vertical,
//       child: Row(
//         children: [
//           Icon(
//             verified ? Icons.verified : Icons.cancel,
//             size: 18.sp,
//             color: verified ? Colors.green : Colors.grey,
//           ),
//           8.width,
//           Expanded(child: Text(text, style: textTheme.bodyMedium)),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/screens/auth/login_screen.dart';
import 'package:runaar/screens/my_rides/my_rides_screen.dart';
import 'package:runaar/screens/profile/account/change_password_screen.dart';
import 'package:runaar/screens/profile/account/edit_profile_screen.dart';
import 'package:runaar/screens/profile/account/language_change_screen.dart';
import 'package:runaar/screens/profile/account/verification_screen.dart';
import 'package:runaar/screens/profile/delete_account_screen.dart';
import 'package:runaar/screens/profile/vehicle/add_vehicle_screen.dart';
import 'package:runaar/screens/profile/vehicle/vehicle_list.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String userName = "Vinit Khatri";
  String userEmail = "vinit@gmail.com";
  String appVersion = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(userName)),
      body: ListView(
        padding: 10.all,
        children: [
          _profileHeader(theme),

          20.height,
          _sectionTitle("Account", theme),
          _profileTile(Icons.person_outline, "Edit Profile", theme),
          _profileTile(Icons.lock_outline, "Change Password", theme),
          _profileTile(Icons.language, "Language", theme),
          _profileTile(Icons.verified_user_outlined, "Verification", theme),

          12.height,
          _sectionTitle("Rides", theme),
          _profileTile(Icons.directions_car, "My Rides", theme),
          _profileTile(Icons.history, "Trip History", theme),
          _profileTile(Icons.star_outline, "My Ratings", theme),

          12.height,

          _sectionTitle("Vehicle", theme),
          _profileTile(Icons.car_rental, "My Vehicles", theme),
          _profileTile(Icons.add_circle_outline, "Add Vehicle", theme),

          12.height,

          _sectionTitle("Payments", theme),
          _profileTile(Icons.account_balance_wallet_outlined, "Wallet", theme),
          _profileTile(Icons.receipt_long, "Transaction History", theme),

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
            "Delete Account",
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
        appNavigator.push(VehicleList(userId: 1));
        break;
      case "Add Vehicle":
        appNavigator.push(AddVehicleScreen(userId: 1));
        break;
      case "Delete Account":
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
                    onPressed: () {
                      appNavigator.pushAndRemoveUntil(LoginScreen());
                    },
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
}
