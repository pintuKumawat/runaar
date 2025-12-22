import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';

class PublishedRideDetailsScreen extends StatelessWidget {
  final String publishedId;

  const PublishedRideDetailsScreen({super.key, required this.publishedId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: appColor.backgroundColor,
      appBar: AppBar(title: Text("Ride Details")),
      bottomNavigationBar: _bottomStatusButton(theme),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          children: [
            _tripCard(theme),
            // 6.height,
            _driverSelfCard(theme),
            // 6.height,
            _vehicleDetails(theme),
            // 6.height,
            _seatInfo(theme),
            // 6.height,
            _passengerList(theme),
            // 14.height,
            // _bottomStatusButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _tripCard(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Wed, 25 Sep 2025", style: theme.titleSmall),
            14.height,

            _locationRow(
              theme: theme,
              icon: Icons.radio_button_checked,
              city: "Ahmedabad",
              address: "Central Bus Stand Area, Gujarat",
              time: "06:00 AM",
            ),

            10.height,
            Center(
              child: Text(
                "5h 00m",
                style: theme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
            10.height,

            _locationRow(
              theme: theme,
              icon: Icons.location_on,
              city: "Udaipur",
              address: "City Railway Station, Rajasthan",
              time: "11:00 AM",
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
        Icon(icon, color: appColor.mainColor, size: 18.sp),
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
              4.height,
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

  Widget _driverSelfCard(TextTheme theme) {
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
}
