import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';

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
            onPressed: () {},
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
              padding: 0.all,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saturday, 20 December',
                    style: theme.titleSmall?.copyWith(fontWeight: .w600),
                  ),

                  6.height,
                  _routeCard(theme),

                  6.height,
                  _priceCard(theme),

                  6.height,
                  _driverCard(theme),

                  6.height,
                  _infoTile(
                    icon: Icons.verified,
                    title: 'Verified Profile',
                    theme: theme,
                  ),
                  _infoTile(
                    icon: Icons.warning_amber_rounded,
                    title: 'Sometimes cancels rides',
                    theme: theme,
                  ),
                  _infoTile(
                    icon: Icons.info_outline,
                    title:
                        "Your booking won't be confirmed until the driver approves",
                    theme: theme,
                  ),
                  // _infoTile(
                  //   icon: Icons.group,
                  //   title: 'Max 2 in the back',
                  //   theme: theme,
                  // ),
                  _infoTile(
                    icon: Icons.directions_car,
                    title: 'MAHINDRA Scorpio · Black',
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

  Widget _priceCard(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1 passenger', style: theme.bodyMedium),
            Text(
              '₹ 190.00',
              style: theme.titleMedium?.copyWith(
                color: appColor.mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _driverCard(TextTheme theme) {
    return Card(
      child: ListTile(
        contentPadding: 12.all,
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
            itemBuilder: (_, _) => const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 16.sp,
            unratedColor: Colors.grey.shade300,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // Navigate to driver profile / details
        },
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required TextTheme theme,
  }) {
    return Padding(
      padding: .only(left: 12.w, bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: appColor.mainColor),
          12.width,
          Expanded(child: Text(title, style: theme.bodyMedium)),
        ],
      ),
    );
  }
}
