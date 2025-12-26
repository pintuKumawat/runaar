import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/booking_status/booking_status_ext.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    BookingStatus currentStatus = BookingStatus.completed;

    return Scaffold(
      appBar: AppBar(title: Text("Booking Details")),
      bottomNavigationBar: _statusButton(theme),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          children: [
            statusContainer(theme, currentStatus),
            // 6.height,
            _tripHeader(theme),
            // 6.height,
            _driverCard(theme),
            // 6.height,
            _vehicleDetails(theme),
            // 6.height,
            _seatInfo(theme),
            _priceSummary(theme),
            _paymentDetails(theme),
            _passengerList(theme),
          ],
        ),
      ),
    );
  }

  Widget statusContainer(TextTheme theme, BookingStatus status) {
    return Align(
      alignment: .topRight,
      child: Container(
        padding: 12.hv(6),
        width: double.infinity,
        decoration: BoxDecoration(color: status.backgroundColor),
        child: Text(
          status.label,
          textAlign: .end,
          style: theme.bodyMedium?.copyWith(
            color: status.textColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _tripHeader(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mon, 22 Sep 2025", style: theme.titleSmall),
            14.height,

            /// FROM
            _locationRow(
              icon: Icons.radio_button_checked,
              city: "New Delhi",
              address: "New Delhi Railway Station Main Gate Area Central Delhi",
              time: "08:30 AM",
              theme: theme,
            ),

            12.height,

            /// DURATION
            Center(
              child: Text(
                "5h 00m",
                style: theme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),

            12.height,

            /// TO
            _locationRow(
              icon: Icons.location_on,
              city: "Jaipur",
              address: "Jaipur Pink City Bus Stand Road Rajasthan Area",
              time: "01:30 PM",
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationRow({
    required IconData icon,
    required String city,
    required String address,
    required String time,
    required TextTheme theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.sp),
        10.width,

        /// CITY + ADDRESS BLOCK
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city,
                style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              4.height,
              Text(
                address,
                style: theme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                // Navigate to driver profile / details
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceSummary(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text('Price summary', style: theme.titleMedium),
            8.height,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("Price/Seats"),
                Text(
                  "190",
                  style: theme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            8.height,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("Seats Booking"),
                Text(
                  "2",
                  style: theme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            8.height,
            const Divider(),
            8.height,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  "Total Price",
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "₹380",
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: appColor.mainColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentDetails(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text('Payment Details', style: theme.titleMedium),
            8.height,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("Payment Method"),
                Text(
                  "Cash/Online",
                  style: theme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            8.height,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("Payment Status"),
                Text(
                  "Pending",
                  style: theme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
            _infoRow(theme, "Car Model", "Swift Dzire"),
            _infoRow(theme, "Color", "White"),
            _infoRow(theme, "Number", "DL 3C AB 1234"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(TextTheme theme, String label, String value) {
    return Padding(
      padding: .only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.bodyMedium),
          Text(
            value,
            style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _seatInfo(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Seats Booked", style: theme.bodyMedium),
            Text(
              "2",
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusButton(TextTheme theme) {
    return BottomAppBar(
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(onPressed: null, child: Text("Ride Completed")),
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
}
