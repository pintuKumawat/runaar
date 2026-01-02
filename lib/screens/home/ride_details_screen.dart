import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/default_image/default_image.dart';
import 'package:runaar/provider/my_rides/passenger_published_list_provider.dart';
import 'package:runaar/provider/my_rides/published_detail_model.dart';
import 'package:runaar/screens/home/confirm_booking_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class RideDetailsScreen extends StatefulWidget {
  final int tripId;
  const RideDetailsScreen({super.key, required this.tripId});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  Future<void> _fetchData() async {
    await context.read<PublishedDetailProvier>().publishedDetail(
      tripId: widget.tripId,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ride Details')),
      bottomNavigationBar: Consumer<PublishedDetailProvier>(
        builder: (context, provider, child) {
          return provider.response?.trip?.availableSeats == "0"
              ? BottomAppBar(
                  child: SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: null,
                      child: Text('No Seats Available'),
                    ),
                  ),
                )
              : _bottomButton();
        },
      ),
      body: Consumer<PublishedDetailProvier>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: _fetchData,
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage != null
                ? Center(child: Text(provider.errorMessage ?? ""))
                : provider.response?.trip == null
                ? const Center(child: Text("No ride details available"))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Padding(
                          padding: 10.all,
                          child: Text(
                            formatTripDate(
                              provider.response?.trip?.tripDate ?? "",
                            ),
                            style: theme.titleMedium,
                          ),
                        ),
                        _routeCard(theme, provider),
                        _priceCard(theme, provider),
                        _driverCard(theme, provider),
                        _vehicleDetails(theme, provider),
                        _passengerList(theme),
                        _infoTile(
                          icon: FontAwesomeIcons.whatsapp,
                          title: 'Chat with driver',
                          theme: theme,
                          onTap: () {
                            final phone =
                                provider.response?.trip?.personPhoneNumber;
                            if (phone != null && phone.isNotEmpty) {
                              launch(
                                "https://wa.me/91$phone?text=Hi, I'm interested in your ride",
                              );
                            }
                          },
                        ),
                        _infoTile(
                          icon: Icons.report,
                          title: 'Report ride',
                          theme: theme,
                          onTap: () {},
                        ),
                        20.height,
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _bottomButton() {
    return BottomAppBar(
      child: Consumer<PublishedDetailProvier>(
        builder: (context, provider, child) {
          final data = provider.response?.trip;
          return SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () => appNavigator.push(
                ConfirmBookingScreen(
                  date: formatTripDate(provider.response?.trip?.tripDate ?? ""),
                  originTime: formatTimeToAMPM(data?.originTime ?? ""),
                  originCity: data?.originCity ?? "Origin",
                  originAddress: data?.originAddress ?? "Address not available",
                  destinationTime: formatTimeToAMPM(
                    data?.destinationTime ?? "",
                  ),
                  destinationCity: data?.destinationCity ?? "Destination",
                  destinationAddress:
                      data?.destinationAddress ?? "Address not available",
                  seatPrice: double.parse(data?.seatPrice ?? "0"),
                  tripId: widget.tripId,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_seat, size: 20.sp),
                  8.width,
                  const Text('Request to book'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _routeCard(TextTheme theme, PublishedDetailProvier prov) {
    final data = prov.response?.trip;
    return Card(
      child: Padding(
        padding: 10.all,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _timeLine(theme, prov),
            14.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _locationBlock(
                    time: formatTimeToAMPM(data?.originTime ?? ""),
                    city: data?.originCity ?? "Origin",
                    address: data?.originAddress ?? "Address not available",
                    theme: theme,
                    isOrigin: true,
                  ),
                  18.height,
                  _locationBlock(
                    time: formatTimeToAMPM(data?.destinationTime ?? ""),
                    city: data?.destinationCity ?? "Destination",
                    address:
                        data?.destinationAddress ?? "Address not available",
                    theme: theme,
                    isOrigin: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeLine(TextTheme theme, PublishedDetailProvier prov) {
    final data = prov.response?.trip;
    return Column(
      children: [
        Text(formatTimeToAMPM(data?.originTime ?? ""), style: theme.bodyMedium),
        Container(
          height: 15.h,
          width: 2.w,
          margin: 3.all,
          color: appColor.mainColor,
        ),
        Text(
          getTimeDifference(
            data?.originTime ?? "",
            data?.destinationTime ?? "",
          ),
          style: theme.bodySmall,
        ),
        Container(
          height: 15.h,
          width: 2.w,
          margin: 3.all,
          color: appColor.mainColor,
        ),
        Text(
          formatTimeToAMPM(data?.destinationTime ?? ""),
          style: theme.bodyMedium,
        ),
      ],
    );
  }

  Widget _locationBlock({
    required String time,
    required String city,
    required String address,
    required TextTheme theme,
    required bool isOrigin,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isOrigin ? Icons.radio_button_checked : Icons.location_on,
              size: 18.sp,
              color: appColor.mainColor,
            ),
            6.width,
            Text(
              city,
              style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        4.height,
        Text(
          address,
          style: theme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _priceCard(TextTheme theme, PublishedDetailProvier prov) {
    final data = prov.response?.trip;
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
                  data?.availableSeats ?? "0",
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
                Text('Price/seat', style: theme.bodyMedium),
                Text(
                  '₹${data?.seatPrice ?? "0"}',
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

  Widget _driverCard(TextTheme theme, PublishedDetailProvier prov) {
    final data = prov.response?.trip;
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Posted By:",
              style: theme.bodySmall?.copyWith(color: Colors.black45),
            ),
            ListTile(
              contentPadding: 5.vertical,
              leading: defaultImage.userProvider(data?.personImage, 24.r),
              title: Row(
                children: [
                  Text(
                    data?.personName ?? "Driver",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  4.width,
                  Icon(
                    Icons.verified,
                    size: 18.sp,
                    color: data?.isVerified == 1 ? Colors.green : Colors.grey,
                  ),
                ],
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Row(
                  children: [
                    RatingBarIndicator(
                      rating: double.parse(
                        data?.personRatings?.toString() ?? "0",
                      ),
                      itemBuilder: (_, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 16.sp,
                      unratedColor: Colors.grey.shade300,
                    ),
                    4.width,
                    Text(
                      data?.personRatings?.toString() ?? "0",
                      style: theme.bodySmall,
                    ),
                  ],
                ),
              ),
              trailing: GestureDetector(
                onTap: () {
                  final phone = data?.personPhoneNumber;
                  if (phone != null && phone.isNotEmpty) {
                    launch("tel:+91$phone");
                  }
                },
                child: Icon(Icons.phone),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleDetails(TextTheme theme, PublishedDetailProvier prov) {
    final data = prov.response?.trip;
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
            _infoRow(theme, "Car Model", data?.vehicleModel ?? "Not specified"),
            _infoRow(theme, "Color", data?.vehicleColor ?? "Not specified"),
            _infoRow(theme, "Number", data?.vehicleNumber ?? "Not specified"),
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
    return Consumer<PassengerPublishedListProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Card(
            child: Padding(
              padding: 10.all,
              child: Center(child: Text(provider.errorMessage ?? "")),
            ),
          );
        }

        final passengers = provider.response?.passengers ?? [];
        if (passengers.isEmpty) {
          return Card(
            child: Padding(
              padding: 10.all,
              child: Center(
                child: Text("No passengers yet", style: theme.bodyMedium),
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: 10.all,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Passengers (${passengers.length})",
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                12.height,
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 300.h, // Limit the height
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: passengers.length,
                    itemBuilder: (context, index) {
                      final data = passengers[index];
                      return _passengerTile(
                        theme,
                        data.passengerName ?? "",
                        data.profileImage ?? "",
                        data.rating ?? 0,
                        data.seatsRequested ?? 0,
                        data.paymentStatus,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _passengerTile(
    TextTheme theme,
    String name,
    String image,
    dynamic rating,
    int seats,
    String? status,
  ) {
    return ListTile(
      leading: defaultImage.userProvider(image, 20.r),
      title: Text(name, style: theme.titleSmall),
      subtitle: RatingBarIndicator(
        rating: parseRating(rating),
        itemBuilder: (_, _) => const Icon(Icons.star, color: Colors.amber),
        itemCount: 5,
        itemSize: 14.sp,
      ),
      trailing: Column(
        mainAxisSize: .min,
        children: [
          Text("$seats Seat", style: theme.titleSmall),
          if (status != null && status.isNotEmpty)
            Text(
              status,
              style: theme.bodySmall?.copyWith(
                color: status.toLowerCase() == "paid"
                    ? Colors.green
                    : Colors.amber,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required TextTheme theme,
    VoidCallback? onTap,
  }) {
    return Card(
      child: Padding(
        padding: 12.all,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: appColor.secondColor),
              12.width,
              Text(
                title,
                style: theme.bodyMedium?.copyWith(color: appColor.secondColor),
              ),
              const Spacer(),
              Icon(Icons.keyboard_arrow_right_outlined),
            ],
          ),
        ),
      ),
    );
  }

  String formatTripDate(String isoDateString) {
    if (isoDateString.isEmpty) return "Date not available";
    try {
      DateTime? dateTime = DateTime.tryParse(isoDateString);
      if (dateTime == null) return isoDateString;
      return DateFormat('EEEE, dd MMM yy').format(dateTime);
    } catch (e) {
      return isoDateString;
    }
  }

  String formatTimeToAMPM(String timeString) {
    if (timeString.isEmpty) return "";
    try {
      if (timeString.length < 5) return timeString;
      String timeWithoutSeconds = timeString.substring(0, 5);
      final parts = timeWithoutSeconds.split(':');
      if (parts.length == 2) {
        int hour = int.tryParse(parts[0]) ?? 0;
        int minute = int.tryParse(parts[1]) ?? 0;
        if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
          return timeWithoutSeconds;
        }
        String period = hour >= 12 ? 'PM' : 'AM';
        int hour12 = hour % 12;
        if (hour12 == 0) hour12 = 12;
        String minuteStr = minute.toString().padLeft(2, '0');
        return '$hour12:$minuteStr $period';
      }
      return timeWithoutSeconds;
    } catch (e) {
      return timeString;
    }
  }

  String getTimeDifference(String originTime, String destinationTime) {
    try {
      if (originTime.isEmpty || destinationTime.isEmpty) {
        return "Duration not available";
      }
      Duration toDuration(String time) {
        try {
          String timePart = time.length >= 8 ? time.substring(0, 5) : time;
          final parts = timePart.split(':');
          if (parts.length < 2) return Duration.zero;
          final hours = int.tryParse(parts[0]) ?? 0;
          final minutes = int.tryParse(parts[1]) ?? 0;
          return Duration(hours: hours, minutes: minutes);
        } catch (e) {
          return Duration.zero;
        }
      }

      Duration origin = toDuration(originTime);
      Duration destination = toDuration(destinationTime);
      if (destination < origin) {
        destination = destination + const Duration(days: 1);
      }
      Duration diff = destination - origin;
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      return "${twoDigits(diff.inHours)}h ${twoDigits(diff.inMinutes.remainder(60))}m";
    } catch (e) {
      return "Error calculating duration";
    }
  }

  double parseRating(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) return value.toDouble();

    if (value is String && value.trim().isNotEmpty) {
      return double.tryParse(value.trim()) ?? 0.0;
    }

    return 0.0;
  }
}
