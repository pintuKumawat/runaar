import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/provider/offerProvider/offer_provider.dart';
import 'package:runaar/screens/home/bottom_nav.dart';

class OfferRideDetailsScreen extends StatefulWidget {
  const OfferRideDetailsScreen({super.key});

  @override
  State<OfferRideDetailsScreen> createState() => _OfferRideDetailsScreenState();
}

class _OfferRideDetailsScreenState extends State<OfferRideDetailsScreen> {
  final TextEditingController priceController = TextEditingController();

  bool luggageAllowed = true;
  bool petsAllowed = false;
  bool smokingAllowed = false;
  int seats = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ride Details')),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: () => appNavigator.pushAndRemoveUntil(
              BottomNav(initialIndex: 1, rideIndex: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.publish, size: 20.sp),
                8.width,
                const Text('PUBLISH RIDE'),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _routeCard(theme),
            16.height,
            Text('Add ride preferences', style: theme.titleMedium),
            8.height,

            _priceInput(theme),

            _sectionTitle('Allowances'),
            _switchTile(
              title: 'Luggage allowed',
              value: luggageAllowed,
              icon: Icons.luggage,
              onChanged: (v) => setState(() => luggageAllowed = v),
              theme: theme,
            ),
            _switchTile(
              title: 'Pets allowed',
              value: petsAllowed,
              icon: Icons.pets,
              onChanged: (v) => setState(() => petsAllowed = v),
              theme: theme,
            ),

            _sectionTitle('Preferences'),
            _switchTile(
              title: 'Smoking allowed',
              value: smokingAllowed,
              icon: Icons.smoking_rooms,
              onChanged: (v) => setState(() => smokingAllowed = v),
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- WIDGETS ----------------
  Widget _routeCard(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _timeLine(theme),
            14.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _locationBlock(
                    time: '14:00',
                    city: 'Jaipur',
                    address:
                        '54, Radha Mukut Vihar Patel Marg, New Sanganer Rd, Mansarovar',
                    theme: theme,
                  ),
                  18.height,
                  _locationBlock(
                    time: '15:00',
                    city: 'Reengus',
                    address: 'Ringas Junction',
                    theme: theme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeLine(TextTheme theme) {
    return Column(
      children: [
        Text('14:00', style: theme.bodyMedium),
        Container(
          height: 15.h,
          width: 2.w,
          margin: 6.all,
          color: appColor.mainColor,
        ),
        Text('0h59', style: theme.bodySmall),
        Container(
          height: 15.h,
          width: 2.w,
          margin: 6.all,
          color: appColor.mainColor,
        ),
        Text('15:00', style: theme.bodyMedium),
      ],
    );
  }

  Widget _locationBlock({
    required String time,
    required String city,
    required String address,
    required TextTheme theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, size: 18.sp, color: appColor.mainColor),
            6.width,
            Text(
              city,
              style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        4.height,
        Text(address, style: theme.bodySmall),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
      ),
    );
  }

  Widget _priceInput(TextTheme theme) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          TextField(
            controller: priceController,
            
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.currency_rupee, color: appColor.mainColor),
              hintText: 'Enter Price/seat',
              hintStyle: theme.bodyMedium,
            ),
          ),
          _seatSelector(theme),
        ],
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required bool value,
    required IconData icon,
    required Function(bool) onChanged,
    required TextTheme theme,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      // padding: 14.all,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(14.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: appColor.mainColor),
          12.width,
          Expanded(child: Text(title, style: theme.bodyLarge)),
          Switch(
            value: value,
            activeColor: appColor.mainColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _seatSelector(TextTheme theme) {
    return Consumer<OfferProvider>(
      builder: (BuildContext context, provider,child) {  
      return Container(
        padding: 14.hv(16),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Number of Seats', style: theme.titleSmall),
            Row(
              children: [
                _seatButton(Icons.remove, () {
                 provider.decrement();
                }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Text('${provider.seats}', style: theme.titleMedium),
                ),
                _seatButton(Icons.add, () {
                provider.increment();
                }),
              ],
            ),
          ],
        ),
      );
      }
    );
  }

  Widget _seatButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(20.r),
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: appColor.backgroundColor,
        child: Icon(icon, color: appColor.mainColor, size: 18.sp),
      ),
    );
  }
}
