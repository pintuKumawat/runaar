import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/provider/home_provider.dart';
import 'package:runaar/screens/home/ride_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final homeProvider = context.watch<HomeProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Available Rides')),
      body: ListView.builder(padding: 10.all, itemBuilder: (context, index) {}),
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
        child: Padding(
          padding: 10.all,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _timeLine(startTime, duration, endTime, theme),

                  14.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _locationText(from, theme),
                        60.height,
                        _locationText(to, theme),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 23.h,
                    children: [
                      Text(
                        '₹ $price',
                        style: theme.titleMedium?.copyWith(
                          color: appColor.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "0.5 km away",
                        style: theme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
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
              8.height,
              const Divider(),

              /// FOOTER
              Text(
                "Posted By:",
                style: theme.bodySmall?.copyWith(color: Colors.black45),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.person, size: 28.sp),
                ),
                title: Text(
                  'Nihit Singh',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
      ),
    );
  }

  /// ---------------- TIMELINE ----------------

  Widget _timeLine(String start, String duration, String end, TextTheme theme) {
    return Column(
      children: [
        Text(start, style: theme.bodyMedium),

        Container(
          height: 12.h,
          width: 2.w,
          color: appColor.mainColor,
          margin: 6.all,
        ),
        Text(duration, style: theme.bodySmall),
        Container(
          height: 12.h,
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
