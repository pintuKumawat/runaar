// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:runaar/screens/home/home_screen.dart';
// import 'package:runaar/screens/my_rides/my_rides_screen.dart';
// import 'package:runaar/screens/notification/notification_screen.dart';
// import 'package:runaar/screens/offer/offer_ride_screen.dart';
// import 'package:runaar/screens/profile/user_profile_screen.dart';

// class BottomNav extends StatefulWidget {
//   const BottomNav({super.key});

//   @override
//   State<BottomNav> createState() => _BottomNavState();
// }

// class _BottomNavState extends State<BottomNav> {
//   int _currentIndex = 2; // Home default
//   late final List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _pages = const [
//       OfferRide(), // Offer Ride
//       MyRidesScreen(), // My Rides
//       HomeScreen(),
//       NotificationScreen(), // Notifications
//       UserProfileScreen(),
//     ];
//   }

//   void _onTabSelected(int index) {
//     setState(() => _currentIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: IndexedStack(index: _currentIndex, children: _pages),
//         bottomNavigationBar: BottomNavigationBar(
          
//           currentIndex: _currentIndex,
//           onTap: (value) => _onTabSelected(value),
//           items: [
//             BottomNavigationBarItem(
//               icon: FaIcon(FontAwesomeIcons.carSide),
//               label: "Offer Ride",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.history_rounded),
//               label: "My Rides",
//             ),
//             BottomNavigationBarItem(
//               icon: FaIcon(FontAwesomeIcons.car),
//               label: "Find Ride",
//             ),
//             BottomNavigationBarItem(
//               icon: FaIcon(FontAwesomeIcons.bell),
//               label: "Notifications",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.account_circle,),
//               label: "Person",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/screens/home/home_screen.dart';
import 'package:runaar/screens/my_rides/my_rides_screen.dart';
import 'package:runaar/screens/notification/notification_screen.dart';
import 'package:runaar/screens/offer/offer_ride_screen.dart';
import 'package:runaar/screens/profile/user_profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 2; // Home default
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      OfferRide(), // Offer Ride
      MyRidesScreen(), // My Rides
      HomeScreen(),
      NotificationScreen(), // Notifications
      UserProfileScreen(),
    ];
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final textScale = context.textScale;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
    
      /// 🔻 CUSTOM BOTTOM BAR
      bottomNavigationBar: Container(
        height: (kBottomNavigationBarHeight + 12.h) * textScale,
        decoration: BoxDecoration(color: appColor.mainColor),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            _buildNavItem(
              icon: FontAwesomeIcons.carSide,
              index: 0,
              label: "Offer Ride",
            ),
            _buildNavItem(icon: Icons.history, index: 1, label: "My Rides"),
    
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -5.h),
                child: GestureDetector(
                  onTap: () => _onTabSelected(2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 24.sp * 2,
                    height: 24.sp * 2,
                    decoration: BoxDecoration(
                      color: appColor.mainColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: appColor.backgroundColor.withOpacity(0.45),
                          blurRadius: 5.r,
                          offset: Offset(0, 1.h),
                        ),
                      ],
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.car,
                        size: _currentIndex == 2 ? 24.sp : 20.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    
            _buildNavItem(
              icon: Icons.notifications,
              index: 3,
              label: "Notifications",
            ),
            _buildNavItem(
              icon: Icons.account_circle,
              index: 4,
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;

    final Color selectedColor = Colors.white;
    final Color unselectedColor = Colors.white60;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabSelected(index),
        borderRadius: .circular(12.r),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: .symmetric(vertical: isSelected ? 6.h : 8.h),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                icon,
                size: isSelected ? 24.sp : 22.sp,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              4.height,
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: isSelected ? 14.sp : 13.sp,
                  fontWeight: isSelected ? .w600 : .w400,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
                child: Text(label, maxLines: 1, overflow: .ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
