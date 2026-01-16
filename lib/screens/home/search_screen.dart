import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/default_image/default_image.dart';
import 'package:runaar/provider/home/home_provider.dart';
import 'package:runaar/screens/home/ride_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: RefreshIndicator(
        onRefresh: () async => context.read<HomeProvider>(),
        child: homeProvider.isLoading
            ? const CircularProgressIndicator()
            : homeProvider.errorMessage != null
            ? Center(child: Text(homeProvider.errorMessage ?? ""))
            : ListView.builder(
                padding: 10.all,
                itemCount: homeProvider.response?.availableRide?.length,
                itemBuilder: (context, index) {
                  final data = homeProvider.response?.availableRide?[index];
                  return _rideCard(
                    theme: theme,
                    price: data?.seatPrice ?? "",
                    startTime: removeSeconds(data?.originTime ?? ""),
                    duration: getTimeDifference(
                      data?.originTime ?? "",
                      data?.destinationTime ?? "",
                    ),
                    endTime: removeSeconds(data?.originTime ?? ""),
                    from: data?.originCity ?? "",
                    to: data?.destinationCity ?? "",
                    personName: data?.personName ?? "",
                    tripId: data?.tripId ?? 0,
                    date: formatDate(data?.deptDate ?? ""),
                    personImage: data?.personImage,
                    rating: data?.personRatings,
                    personNumber: data?.personPhoneNumber,
                    distance: data?.distanceFromSearch ?? "",
                  );
                },
              ),
      ),
    );
  }

  Widget _rideCard({
    required TextTheme theme,
    required String price,
    required String startTime,
    required String duration,
    required String endTime,
    required String from,
    required String to,
    required String personName,
    required int tripId,
    required String date,
    required String distance,
    int? rating,
    String? personImage,
    String? personNumber,
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
                        '₹$price/seat',
                        style: theme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$distance km away",
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
                contentPadding: 2.vertical,
                leading: defaultImage.userProvider(personImage, 24.r),
                title: Text(
                  personName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: RatingBarIndicator(
                    rating: double.parse("$rating"),
                    itemBuilder: (_, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 16.sp,
                    unratedColor: Colors.grey.shade400,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    var num = "+91$personNumber";
                    launch("tel:$num");
                  },
                  child: Icon(Icons.phone),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _locationText(String text, TextTheme theme) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 18.sp, color: appColor.mainColor),
        6.width,
        Text(text, style: theme.titleMedium),
      ],
    );
  }

  String removeSeconds(String time) {
    final parts = time.split(':');
    return "${parts[0]}:${parts[1]}";
  }

  String getTimeDifference(String originTime, String destinationTime) {
    Duration toDuration(String time) {
      final parts = time.split(':');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      return Duration(hours: hours, minutes: minutes);
    }

    Duration origin = toDuration(originTime);
    Duration destination = toDuration(destinationTime);
    Duration diff = destination - origin;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(diff.inHours)}:${twoDigits(diff.inMinutes.remainder(60))}";
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat("dd MMM yy").format(date).toUpperCase();
  }
}
