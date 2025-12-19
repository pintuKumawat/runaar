import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/screens/home/home_screen.dart';
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
      SizedBox(), // Offer Ride
      SizedBox(), // My Rides
      HomeScreen(),
      SizedBox(), // Notifications
      UserProfileScreen(),
    ];
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = 24.sp;
    final textScale = context.textScale;

    return SafeArea(
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),

        /// 🔻 CUSTOM BOTTOM BAR
        bottomNavigationBar: Container(
          height: (kBottomNavigationBarHeight + 12.h) * textScale,
          decoration: BoxDecoration(
            color: appColor.themeColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 18.r,
                offset: Offset(0, -4.h),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildNavItem(
                icon: FontAwesomeIcons.carSide,
                index: 0,
                label: "Offer Ride",
                iconSize: iconSize,
              ),
              _buildNavItem(
                icon: Icons.history,
                index: 1,
                label: "My Rides",
                iconSize: iconSize,
              ),

              /// ⭐ CENTER ACTION (Find Ride)
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, -28.h),
                  child: GestureDetector(
                    onTap: () => _onTabSelected(2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: iconSize * 2,
                      height: iconSize * 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            appColor.mainColor,
                            appColor.themeColor.withOpacity(0.9),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: appColor.backgroundColor.withOpacity(0.45),
                            blurRadius: 16.r,
                            offset: Offset(0, 6.h),
                          ),
                        ],
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.car,
                          size: iconSize,
                          color: _currentIndex == 2
                              ? appColor
                                    .mainColor
                              : Colors.white
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
                iconSize: iconSize,
              ),
              _buildNavItem(
                icon: Icons.account_circle,
                index: 4,
                label: "Profile",
                iconSize: iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 NAV ITEM
  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
    required double iconSize,
  }) {
    final bool isSelected = _currentIndex == index;

    final Color selectedColor = appColor.mainColor;
    final Color unselectedColor = appColor.mainColor.withOpacity(0.55);

    return Expanded(
      child: InkWell(
        onTap: () => _onTabSelected(index),
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: isSelected ? 6.h : 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              4.height,
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
