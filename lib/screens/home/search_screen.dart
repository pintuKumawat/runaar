import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/screens/home/ride_details_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Available Rides')),
      body: ListView(
        padding: 10.all,
        children: [
          _rideCard(
            theme: theme,
            tripId: "100",
            price: '200',
            startTime: '11:10',
            duration: '0h 50m',
            endTime: '12:00',
            from: 'Jaipur',
            to: 'Reengus',
            name: 'Sushil',
            rating: '1.0',
            date: '22 Sep 2025',
          ),

          _rideCard(
            theme: theme,
            tripId: "101",
            price: '170',
            startTime: '11:30',
            duration: '1h 00m',
            endTime: '12:30',
            from: 'Jaipur',
            to: 'Reengus',
            name: 'Pradeep',
            date: '23 Sep 2025', 
          ),

          _rideCard(
            theme: theme,
            tripId: "102",
            price: '240',
            startTime: '11:30',
            duration: '1h 00m',
            endTime: '12:30',
            from: 'Jaipur',
            to: 'Reengus',
            name: 'Rajendra',
            rating: '4.3',
            date: '24 Sep 2025',
          ),
        ],
      ),
    );
  }

  /// ---------------- RIDE CARD ----------------

  Widget _rideCard({
    required TextTheme theme,
    required String price,
    required String startTime,
    required String duration,
    required String endTime,
    required String from,
    required String to,
    required String name,
    required String tripId,
    required String date, 
    String? rating,
  }) {
    return InkWell(
      onTap: () => appNavigator.push(RideDetailsScreen(tripId: tripId)),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: 10.all,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _timeLine(startTime, duration, endTime, theme),

                  14.width,

                  /// FROM → TO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _locationText(from, theme),
                        47.height,
                        _locationText(to, theme),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 50.h,
                    children: [
                      Text(
                        '₹ $price',
                        style: theme.titleLarge?.copyWith(
                          color: appColor.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        date,
                        style: theme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            /// FOOTER
            ListTile(
              contentPadding: 10.all,
              leading: CircleAvatar(
                radius: 22.r,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, size: 26.sp),
              ),
              title: Text(name, style: theme.bodyLarge),
              subtitle: rating != null
                  ? RatingBarIndicator(
                      rating: double.parse(rating),
                      itemBuilder: (_, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 16.sp,
                      unratedColor: Colors.grey.shade300,
                    )
                  : null,
              trailing: Icon(Icons.directions_car, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- TIMELINE ----------------

  Widget _timeLine(String start, String duration, String end, TextTheme theme) {
    return Column(
      children: [
        Text(start, style: theme.bodyMedium),

        Container(
          height: 15.h,
          width: 2.w,
          color: appColor.mainColor,
          margin: 6.all,
        ),
        Text(duration, style: theme.bodySmall),
        Container(
          height: 15.h,
          width: 2.w,
          color: appColor.mainColor,
          margin: 6.all,
        ),
        Text(end, style: theme.bodyMedium),
      ],
    );
  }

  /// ---------------- LOCATION TEXT ----------------

  Widget _locationText(String text, TextTheme theme) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 18.sp, color: appColor.mainColor),
        6.width,
        Text(text, style: theme.titleMedium),
      ],
    );
  }
}
