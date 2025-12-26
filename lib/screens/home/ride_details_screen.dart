import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/screens/home/confirm_booking_screen.dart';

class RideDetailsScreen extends StatelessWidget {
  final String tripId;
  const RideDetailsScreen({super.key, required this.tripId});

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
            onPressed: () => appNavigator.push(ConfirmBookingScreen()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_seat, size: 20.sp),
                8.width,
                const Text('Request to book'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: 10.hv(10),
                    child: Text(
                      'Saturday, 20 December',
                      style: theme.titleSmall?.copyWith(fontWeight: .w600),
                    ),
                  ),

                  _routeCard(theme),

                  _priceCard(theme),

                  _driverCard(theme),

                  _vehicleDetails(theme),

                  _passengerList(theme),

                  _infoTile(
                    icon: FontAwesomeIcons.whatsapp,
                    title: 'Chat with driver',
                    theme: theme,
                  ),
                  _infoTile(
                    icon: Icons.report,
                    title: 'Report ride',
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleDetails(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vehicle Details",
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            12.height,
            _infoRow(theme, "Car Model", "Baleno"),
            _infoRow(theme, "Color", "Grey"),
            _infoRow(theme, "Number", "GJ 01 AB 4567"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(TextTheme theme, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.titleSmall),
          Text(value, style: theme.titleMedium),
        ],
      ),
    );
  }

  Widget _passengerList(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Passengers (2)",
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            12.height,
            _passengerTile(theme, "Rahul Patel", 4.3),
            _passengerTile(theme, "Neha Verma", 4.1),
          ],
        ),
      ),
    );
  }

  Widget _passengerTile(TextTheme theme, String name, double rating) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: Icon(Icons.person),
      ),
      title: Text(name, style: theme.titleSmall),
      subtitle: RatingBarIndicator(
        rating: rating,
        itemBuilder: (_, _) => const Icon(Icons.star, color: Colors.amber),
        itemCount: 5,
        itemSize: 16.sp,
      ),
      trailing: Text("1 Seat", style: theme.titleSmall),
    );
  }

  Widget _routeCard(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Row(
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
          margin: 3.all,
          color: appColor.mainColor,
        ),
        Text('0h59', style: theme.bodySmall),
        Container(
          height: 15.h,
          width: 2.w,
          margin: 3.all,
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

  Widget _priceCard(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Seats left", style: theme.bodyMedium),
                Text(
                  "2",
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            4.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('price/seat', style: theme.bodyMedium),
                Text(
                  '₹ 190.00',
                  style: theme.titleMedium?.copyWith(
                    color: appColor.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _driverCard(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Posted By:",
              style: theme.bodySmall?.copyWith(color: Colors.black45),
            ),
            ListTile(
              contentPadding: 5.vertical,
              leading: CircleAvatar(
                radius: 24.r,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, size: 28.sp),
              ),
              title: Text(
                'Nihit Singh',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: RatingBarIndicator(
                  rating: 4.6,
                  itemBuilder: (_, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 16.sp,
                  unratedColor: Colors.grey.shade300,
                ),
              ),
              trailing: Icon(Icons.phone),
              
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required TextTheme theme,
  }) {
    return Card(
      child: Padding(
        padding: 12.all,
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: appColor.secondColor),
            12.width,
            Text(
              title,
              style: theme.bodyMedium?.copyWith(color: appColor.secondColor),
            ),
            Spacer(),
            Icon(Icons.keyboard_arrow_right_outlined),
          ],
        ),
      ),
    );
  }
}
