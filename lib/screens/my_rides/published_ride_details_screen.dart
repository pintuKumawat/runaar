import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/booking_status/booking_status_ext.dart';
import 'package:runaar/provider/my_rides/published_detail_model.dart';

class PublishedRideDetailsScreen extends StatefulWidget {
  final int publishedId;

  const PublishedRideDetailsScreen({super.key, required this.publishedId});

  @override
  State<PublishedRideDetailsScreen> createState() =>
      _PublishedRideDetailsScreenState();
}

class _PublishedRideDetailsScreenState
    extends State<PublishedRideDetailsScreen> {
  Future<void> _fetchData() async {
    await context.read<PublishedDetailProvier>().publishedDetail(
      tripId: widget.publishedId,
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
    PublishedDetailProvier prov = context.read<PublishedDetailProvier>();

    return Scaffold(
      appBar: AppBar(title: Text("Ride Details")),
      bottomNavigationBar: _bottomStatusButton(theme),
      body: prov.isLoading
          ? const CircularProgressIndicator()
          : prov.errorMessage != null
          ? Center(child: Text(prov.errorMessage ?? ""))
          : SingleChildScrollView(
              padding: 10.all,
              child: Column(
                children: [
                  _tripCard(theme, prov),
                  _driverSelfCard(theme, prov),
                  _vehicleDetails(theme),
                  _seatInfo(theme),
                  _passengerList(theme),
                ],
              ),
            ),
    );
  }

  Widget _tripCard(TextTheme theme, PublishedDetailProvier prov) {
    final data = prov.response?.trip;
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formatTripDate(data?.tripDate ?? ""), style: theme.titleSmall),
            14.height,

            _locationRow(
              theme: theme,
              icon: Icons.radio_button_checked,
              city: data?.originCity ?? "",
              address: data?.originAddress ?? "",
              time: formatTimeToAMPM(data?.originTime ?? ""),
            ),

            10.height,
            Center(
              child: Text(
                getTimeDifference(
                  data?.originTime ?? "",
                  data?.destinationTime ?? "",
                ),
                style: theme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
            10.height,

            _locationRow(
              theme: theme,
              icon: Icons.location_on,
              city: data?.destinationCity ?? "",
              address: data?.destinationAddress ?? "",
              time: formatTimeToAMPM(data?.destinationTime ?? ""),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationRow({
    required TextTheme theme,
    required IconData icon,
    required String city,
    required String address,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: appColor.mainColor, size: 20.sp),
        10.width,

        /// CITY + ADDRESS
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              3.height,
              Text(
                address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.bodySmall,
              ),
            ],
          ),
        ),

        8.width,

        /// TIME
        Text(
          time,
          style: theme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _driverSelfCard(TextTheme theme, PublishedDetailProvier prov) {
    return Card(
      child: ListTile(
        contentPadding: 10.all,

        leading: CircleAvatar(
          radius: 26.r,
          backgroundColor: Colors.grey.shade300,
          child: Icon(Icons.person, size: 30.sp),
        ),
        title: Text(
          "Driver Name",
          style: theme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            6.height,
            RatingBarIndicator(
              rating: 4.8,
              itemBuilder: (_, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 16.sp,
              unratedColor: Colors.grey.shade300,
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "₹ 540",
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            // 6.height,
            // _statusChip(theme, "Open"),
          ],
        ),
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

  Widget _seatInfo(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Seats left", style: theme.bodyMedium),
            Text(
              "2",
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomStatusButton(TextTheme theme) {
    return BottomAppBar(
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(onPressed: null, child: Text("Ride Completed")),
      ),
    );
  }

  String formatTripDate(String isoDateString) {
    try {
      final dateTime = DateTime.parse(isoDateString);
      return DateFormat('EEEE, dd MMM yy').format(dateTime);
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return isoDateString;
    }
  }

  String formatTimeToAMPM(String timeString) {
    if (timeString.isEmpty) return "";

    try {
      String timeWithoutSeconds = timeString.substring(0, 5);

      // Convert to AM/PM
      final parts = timeWithoutSeconds.split(':');
      if (parts.length == 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);

        String period = hour >= 12 ? 'PM' : 'AM';
        int hour12 = hour % 12;
        if (hour12 == 0) hour12 = 12;
        String minuteStr = minute.toString().padLeft(2, '0');

        return '$hour12:$minuteStr $period';
      }

      return timeWithoutSeconds;
    } catch (e) {
      debugPrint("Error formatting time: $e");
      return timeString;
    }
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
    return "${twoDigits(diff.inHours)}h:${twoDigits(diff.inMinutes.remainder(60))}m";
  }

  Widget _statusButton(
    TextTheme theme,
    BookingStatus status,
    DateTime departureTime,
    DateTime currentTime,
    BuildContext context,
  ) {
    String buttonText = "Ride Completed";
    bool isEnabled = false;

    // Calculate if departure time is within 1 hour
    bool isWithinOneHourOfDeparture =
        currentTime.isAfter(departureTime.subtract(Duration(hours: 1))) &&
        !currentTime.isAfter(departureTime);

    bool hasDepartureTimeArrived = currentTime.isAfter(departureTime);

    switch (status) {
      case BookingStatus.cancelled:
        buttonText = "Ride Cancelled";
        isEnabled = false;
        break;
      case BookingStatus.started:
        buttonText = "Ride Started";
        isEnabled = false;
        break;
      case BookingStatus.completed:
        buttonText = "Ride Completed";
        isEnabled = false;
        break;
      case BookingStatus.pending:
        if (hasDepartureTimeArrived || isWithinOneHourOfDeparture) {
          buttonText = "Cannot Cancel Now";
          isEnabled = false;
        } else {
          buttonText = "Cancel Ride";
          isEnabled = true;
        }
        break;
      case BookingStatus.confirmed:
        if (hasDepartureTimeArrived || isWithinOneHourOfDeparture) {
          buttonText = "Cannot Cancel Now";
          isEnabled = false;
        } else {
          buttonText = "Cancel Ride";
          isEnabled = true;
        }
        break;
      default:
        buttonText = "Ride Completed";
        isEnabled = false;
    }

    return BottomAppBar(
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: isEnabled
              ? () {
                  // Handle cancel ride action
                  // _showCancelConfirmationDialog(context);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? Colors.red : Colors.grey.shade50,
            foregroundColor: Colors.white,
          ),
          child: Text(buttonText),
        ),
      ),
    );
  }
}
