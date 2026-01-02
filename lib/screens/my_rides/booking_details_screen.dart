import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/booking_status/booking_status_ext.dart';
import 'package:runaar/core/utils/helpers/default_image/default_image.dart';
import 'package:runaar/models/my_rides/booking_detail_model.dart';
import 'package:runaar/provider/my_rides/booking_detail_provider.dart';
import 'package:runaar/provider/my_rides/passenger_published_list_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailsScreen extends StatefulWidget {
  final int bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  Future<void> _fetchData() async {
    await context.read<BookingDetailProvider>().bookingDetail(
      tripId: widget.bookingId,
    );
  }

  Future<void> _fetchPassenger() async {
    final data = context.read<BookingDetailProvider>().response?.detail;
    await context.read<PassengerPublishedListProvider>().passengerList(
      tripId: data?.tripId ?? 0,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchData().then((value) => _fetchPassenger()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    DateTime departureTime = DateTime(2026, 9, 22, 15, 30);
    DateTime now = DateTime.now();

    BookingStatus getCurrentStatus(String? status) {
      switch (status?.toLowerCase()) {
        case "cancelled":
          return BookingStatus.cancelled;
        case "confirmed":
          return BookingStatus.confirmed;
        case "completed":
          return BookingStatus.completed;
        case "started":
          return BookingStatus.started;
        case "rejected":
          return BookingStatus.rejected;
        default:
          return BookingStatus.pending;
      }
    }

    return Consumer<BookingDetailProvider>(
      builder: (context, provider, child) {
        final data = provider.response?.detail;
        return Scaffold(
          appBar: AppBar(title: Text("Booking Details")),
          bottomNavigationBar: _statusButton(
            theme,
            getCurrentStatus(data?.tripStatus),
            departureTime,
            now,
            context,
          ),
          body: provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : provider.errorMessage != null
              ? Center(child: Text(provider.errorMessage ?? ""))
              : SingleChildScrollView(
                  padding: 10.all,
                  child: Column(
                    children: [
                      statusContainer(
                        theme,
                        getCurrentStatus(data?.bookingStatus),
                      ),
                      _tripHeader(theme, data),
                      _driverCard(theme, data),
                      _vehicleDetails(theme, data),
                      _priceSummary(theme, data),
                      _paymentDetails(theme, data),
                      _passengerList(theme),
                    ],
                  ),
                ),
        );
      },
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

  Widget _tripHeader(TextTheme theme, Detail? data) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data?.tripDate ?? "", style: theme.titleSmall),
            14.height,

            /// FROM
            _locationRow(
              icon: Icons.radio_button_checked,
              city: data?.originCity ?? "",
              address: data?.originAddress ?? "",
              time: formatToAmPmSimple(data?.deptTime),
              theme: theme,
            ),

            12.height,

            /// DURATION
            Center(
              child: Text(
                formatDuration(
                  calculateTimeDifference(
                    data?.deptTime ?? "",
                    data?.arrivalTime ?? "",
                  ),
                ),
                style: theme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),

            12.height,

            /// TO
            _locationRow(
              icon: Icons.location_on,
              city: data?.destinationCity ?? "",
              address: data?.destinationAddress ?? "",
              time: formatToAmPmSimple(data?.arrivalTime),
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

  Widget _driverCard(TextTheme theme, Detail? data) {
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
              leading: defaultImage.userProvider(data?.driverImage, 24.r),
              title: Row(
                children: [
                  Text(
                    data?.driverName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  5.width,
                  Icon(
                    Icons.verified,
                    color: data?.driverIsVerified == 1
                        ? Colors.green
                        : Colors.grey,
                    size: 18.sp,
                  ),
                ],
              ),
              subtitle: Padding(
                padding: .only(top: 4.h),
                child: RatingBarIndicator(
                  rating: parseRating(data?.driverRating),
                  itemBuilder: (_, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 16.sp,
                  unratedColor: Colors.grey.shade300,
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  var num = "+91${data?.driverPhone}";
                  launch("tel:$num");
                },
                child: Text(
                  "Call",
                  style: theme.bodyMedium?.copyWith(
                    fontWeight: .w600,
                    color: appColor.secondColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceSummary(TextTheme theme, Detail? data) {
    double totalPrice =
        double.parse(data?.pricePerSeat ?? "0") *
        double.parse(data?.seatsBooked.toString() ?? "0");
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
                  data?.pricePerSeat ?? "",
                  style: theme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Seats Booked", style: theme.bodyMedium),
                Text(
                  data?.seatsBooked.toString() ?? "",
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
                  "₹ $totalPrice",
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

  Widget _paymentDetails(TextTheme theme, Detail? data) {
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
                  data?.paymentMethod ?? "",
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
                  data?.paymentStatus ?? "",
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

  Widget _vehicleDetails(TextTheme theme, Detail? data) {
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
            _infoRow(theme, "Car Model", data?.vehicleModel ?? ""),
            _infoRow(theme, "Color", data?.vehicleColor ?? ""),
            _infoRow(theme, "Number", data?.carNumber ?? ""),
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

  Widget _statusButton(
    TextTheme theme,
    BookingStatus status,
    DateTime departureTime,
    DateTime currentTime,
    BuildContext context,
  ) {
    String buttonText = "Ride Completed";
    bool isEnabled = false;

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
                  _showCancelConfirmationDialog(context);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? Colors.red : Colors.grey,
            foregroundColor: Colors.white,
          ),
          child: Text(buttonText),
        ),
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cancel Ride"),
        content: Text("Are you sure you want to cancel this ride?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              // Handle cancellation logic
              appNavigator.pop();
              // You might want to update the booking status here
            },
            child: Text("Yes", style: TextStyle(color: Colors.red)),
          ),
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
                  constraints: BoxConstraints(maxHeight: 300.h),
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
                        data.rating,
                        data.seatsRequested ?? 0,
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
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: defaultImage.userProvider(image, 22.r),
      title: Text(name, style: theme.titleSmall),
      subtitle: RatingBarIndicator(
        rating: parseRating(rating),
        itemBuilder: (_, _) => const Icon(Icons.star, color: Colors.amber),
        itemCount: 5,
        itemSize: 16.sp,
      ),
      trailing: Text("$seats Seat", style: theme.titleSmall),
    );
  }

  double parseRating(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) return value.toDouble();

    if (value is String && value.trim().isNotEmpty) {
      return double.tryParse(value.trim()) ?? 0.0;
    }

    return 0.0;
  }

  String formatToAmPmSimple(String? time) {
    if (time == null || time.trim().isEmpty) return "--";

    try {
      final parts = time.trim().split(":");
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      final suffix = hour >= 12 ? "PM" : "AM";
      hour = hour % 12;
      if (hour == 0) hour = 12;

      return "$hour:${minute.toString().padLeft(2, '0')} $suffix";
    } catch (_) {
      return "--";
    }
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return "${hours}h ${minutes}m";
  }

  Duration calculateTimeDifference(String? startTime, String? endTime) {
    List<int>? toParts(String? time) {
      if (time == null || time.trim().isEmpty) return null;

      final parts = time.trim().split(":");
      if (parts.length < 2) return null;

      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final s = parts.length > 2 ? int.tryParse(parts[2]) : 0;

      if (h == null || m == null || s == null) return null;
      return [h, m, s];
    }

    final start = toParts(startTime);
    final end = toParts(endTime);

    if (start == null || end == null) {
      return Duration.zero;
    }

    final diff = Duration(
      hours: end[0] - start[0],
      minutes: end[1] - start[1],
      seconds: end[2] - start[2],
    );

    return diff.isNegative ? Duration.zero : diff;
  }
}
