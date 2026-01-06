import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/core/utils/helpers/default_image/default_image.dart';
import 'package:runaar/provider/my_rides/passenger_published_list_provider.dart';
import 'package:runaar/provider/my_rides/published_detail_model.dart';
import 'package:runaar/provider/my_rides/trip_status_update_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    await context.read<PassengerPublishedListProvider>().passengerList(
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
    PublishedDetailProvier prov = context.watch<PublishedDetailProvier>();

    return Scaffold(
      appBar: AppBar(title: Text("Ride Details")),
      bottomNavigationBar: _statusButton(theme, prov),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : prov.errorMessage != null
          ? Center(child: Text(prov.errorMessage ?? ""))
          : prov.response?.trip == null
          ? const Center(child: Text("No trip details available"))
          : SingleChildScrollView(
              padding: 10.all,
              child: Column(
                children: [
                  _tripCard(theme, prov),
                  _driverSelfCard(theme, prov),
                  _vehicleDetails(theme, prov),
                  _seatInfo(theme, prov),
                  _passengerList(theme),
                ],
              ),
            ),
    );
  }

  Widget _tripCard(TextTheme theme, PublishedDetailProvier prov) {
    final data = prov.response?.trip;

    String formattedDate = "Date not available";
    if (data?.tripDate != null && data!.tripDate!.isNotEmpty) {
      try {
        formattedDate = formatTripDate(data.tripDate!);
      } catch (e) {
        debugPrint("Error in _tripCard: $e");
        formattedDate = data.tripDate!; // Show raw string if can't format
      }
    }

    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate, style: theme.titleSmall),
            14.height,

            _locationRow(
              theme: theme,
              icon: Icons.radio_button_checked,
              city: data?.originCity ?? "Origin",
              address: data?.originAddress ?? "Address not available",
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
              city: data?.destinationCity ?? "Destination",
              address: data?.destinationAddress ?? "Address not available",
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
        Text(
          time,
          style: theme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _driverSelfCard(TextTheme theme, PublishedDetailProvier prov) {
    final data = prov.response?.trip;
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
              leading: defaultImage.userProvider(data?.personImage, 22.r),
              title: Row(
                children: [
                  Text(
                    data?.personName ?? "",
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
                        data?.personRatings.toString() ?? "",
                      ),
                      itemBuilder: (_, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 16.sp,
                      unratedColor: Colors.grey.shade300,
                    ),
                    4.width,
                    Text(data?.personRatings.toString() ?? ""),
                  ],
                ),
              ),
              trailing: GestureDetector(
                onTap: () {
                  var num = "+91${data?.personPhoneNumber}";
                  launch("tel:$num");
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
      leading: defaultImage.userProvider(image, 22.r),
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

  Widget _seatInfo(TextTheme theme, PublishedDetailProvier prov) {
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
                  data?.availableSeats.toString() ?? "",
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            4.height,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("Price/Seat", style: theme.bodyMedium),
                Text(
                  "₹${data?.seatPrice ?? ""}",
                  style: theme.titleMedium?.copyWith(
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

  String formatTripDate(String isoDateString) {
    if (isoDateString.isEmpty) return "";
    try {
      DateTime? dateTime = DateTime.tryParse(isoDateString);

      if (dateTime == null) {
        String cleaned = isoDateString.trim();

        if (cleaned.contains(',')) {
          return cleaned;
        }

        // Try different date formats
        List<String> dateFormats = [
          'yyyy-MM-ddTHH:mm:ss.SSSZ',
          'yyyy-MM-dd HH:mm:ss',
          'yyyy-MM-dd',
          'dd/MM/yyyy',
          'MM/dd/yyyy',
        ];

        for (String format in dateFormats) {
          try {
            DateFormat inputFormat = DateFormat(format);
            dateTime = inputFormat.parse(cleaned);
            break;
          } catch (e) {
            continue;
          }
        }

        // If still null, try manual parsing
        if (dateTime == null) {
          RegExp datePattern = RegExp(r'(\d{4})-(\d{2})-(\d{2})');
          Match? match = datePattern.firstMatch(cleaned);
          if (match != null) {
            int year =
                int.tryParse(match.group(1) ?? '') ?? DateTime.now().year;
            int month = int.tryParse(match.group(2) ?? '') ?? 1;
            int day = int.tryParse(match.group(3) ?? '') ?? 1;
            dateTime = DateTime(year, month, day);
          }
        }
      }

      if (dateTime != null) {
        return DateFormat('EEEE, dd MMM yy').format(dateTime);
      } else {
        // Return original string if can't parse
        return isoDateString;
      }
    } catch (e) {
      debugPrint("Error in formatTripDate: $e - Input: '$isoDateString'");
      return isoDateString;
    }
  }

  String formatTimeToAMPM(String timeString) {
    if (timeString.isEmpty) return "";

    try {
      // Check if timeString has at least 5 characters (HH:mm)
      if (timeString.length < 5) {
        return timeString;
      }

      String timeWithoutSeconds = timeString.substring(0, 5);

      // Parse the time parts
      final parts = timeWithoutSeconds.split(':');
      if (parts.length == 2) {
        int hour = int.tryParse(parts[0]) ?? 0;
        int minute = int.tryParse(parts[1]) ?? 0;

        // Validate hour and minute
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
      // Add null/empty checks
      if (originTime.isEmpty || destinationTime.isEmpty) {
        return "Duration not available";
      }

      Duration toDuration(String time) {
        try {
          String timePart = time;
          if (time.length >= 8) {
            timePart = time.substring(0, 5); // Get HH:mm from HH:mm:ss
          }
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

      // Handle cases where destination might be before origin (overnight)
      if (destination < origin) {
        destination = destination + Duration(days: 1);
      }

      Duration diff = destination - origin;

      String twoDigits(int n) => n.toString().padLeft(2, '0');
      return "${twoDigits(diff.inHours)}h ${twoDigits(diff.inMinutes.remainder(60))}m";
    } catch (e) {
      return "Error calculating duration";
    }
  }

  Widget _statusButton(TextTheme theme, PublishedDetailProvier prov) {
    final trip = prov.response?.trip;
    if (trip == null) return const SizedBox.shrink();

    DateTime? departureTime;
    try {
      if (trip.tripDate != null &&
          trip.tripDate!.isNotEmpty &&
          trip.originTime != null &&
          trip.originTime!.isNotEmpty) {
        // Combine date and time

        departureTime = parseTripDateTime(
          trip.tripDate ?? "",
          trip.originTime ?? "",
        );
      }
    } catch (e) {
      debugPrint("Error parsing departure time: $e");
    }

    DateTime now = DateTime.now();
    String buttonText = "";
    bool isEnabled = false;
    Color buttonColor = Colors.grey;
    Color textColor = Colors.white;

    String tripStatus = trip.tripStatus?.toLowerCase() ?? "";

    // Check if it's less than 1 hour before departure
    bool isLessThanOneHourBefore = false;
    if (departureTime != null) {
      Duration timeToDeparture = departureTime.difference(now);
      // Check if departure is within 1 hour AND hasn't passed yet
      isLessThanOneHourBefore =
          timeToDeparture <= Duration(hours: 1) &&
          timeToDeparture > Duration.zero;
    }

    switch (tripStatus) {
      case "open":
        if (isLessThanOneHourBefore) {
          // Within 1 hour of departure - CANNOT cancel
          buttonText = "Cannot Cancel Now";
          isEnabled = false;
          buttonColor = Colors.grey;
          textColor = Colors.black54;
        } else if (departureTime != null && now.isBefore(departureTime)) {
          // Before departure, more than 1 hour away - CAN cancel
          buttonText = "Cancel Trip";
          isEnabled = true;
          buttonColor = Colors.red;
        } else if (departureTime != null && now.isAfter(departureTime)) {
          // After departure time - can start trip
          buttonText = "Start Trip";
          isEnabled = true;
          buttonColor = Colors.green;
        } else {
          // Default fallback - allow cancel
          buttonText = "Cancel Trip";
          isEnabled = true;
          buttonColor = Colors.red;
        }
        break;

      case "started":
        buttonText = "Complete Trip";
        isEnabled = true;
        buttonColor = Colors.blue;
        break;

      case "completed":
        buttonText = "Trip Completed";
        isEnabled = false;
        buttonColor = Colors.grey;
        textColor = Colors.black54;
        break;

      case "cancelled":
        buttonText = "Trip Cancelled";
        isEnabled = false;
        buttonColor = Colors.grey;
        textColor = Colors.black54;
        break;

      default:
        buttonText = "View Trip";
        isEnabled = false;
        buttonColor = Colors.grey;
        textColor = Colors.black54;
    }

    return BottomAppBar(
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: isEnabled
              ? () => _handleButtonAction(tripStatus, context, prov)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
          ),
          child: Text(buttonText),
        ),
      ),
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

  void _handleButtonAction(
    String tripStatus,
    BuildContext context,
    PublishedDetailProvier prov,
  ) {
    final trip = prov.response?.trip;
    if (trip == null) return;
    DateTime? departureTime;
    try {
      if (trip.tripDate != null &&
          trip.tripDate!.isNotEmpty &&
          trip.originTime != null &&
          trip.originTime!.isNotEmpty) {
        departureTime = parseTripDateTime(
          trip.tripDate ?? "",
          trip.originTime ?? "",
        );
      }
    } catch (e) {
      debugPrint("Error parsing departure time: $e");
    }

    DateTime now = DateTime.now();
    bool isLessThanOneHourBefore = false;
    if (departureTime != null) {
      Duration timeToDeparture = departureTime.difference(now);
      isLessThanOneHourBefore =
          timeToDeparture <= Duration(hours: 1) &&
          timeToDeparture > Duration.zero;
    }

    switch (tripStatus.toLowerCase()) {
      case "open":
        if (isLessThanOneHourBefore) {
          appSnackbar.showSingleSnackbar(
            context,
            "Cannot cancel trip within 1 hour of departure",
          );
          return;
        } else if (departureTime != null && now.isAfter(departureTime)) {
          _showStartTripConfirmation(context);
        } else {
          _showCancelTripConfirmation(context);
        }
        break;

      case "started":
        _showCompleteTripConfirmation(context);
        break;

      default:
        break;
    }
  }

  void _showStartTripConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Start Trip"),
        content: Text("Are you ready to start this trip?"),
        actions: [
          TextButton(onPressed: () => appNavigator.pop(), child: Text("No")),
          TextButton(
            onPressed: () {
              _updateTripStatus("Started");
              
            },
            child: Text(
              "Yes, Start Trip",
              style: TextStyle(
                color: Colors.green,
                fontSize: 15.sp,
                fontWeight: .w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelTripConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Cancel Trip"),
        content: Text("Are you sure you want to cancel this trip?"),
        actions: [
          TextButton(onPressed: () => appNavigator.pop(), child: Text("No")),
          TextButton(
            onPressed: () {
              _updateTripStatus("Cancelled");
              
            },
            child: Text(
              "Yes, Cancel",
              style: TextStyle(
                color: Colors.red,
                fontSize: 15.sp,
                fontWeight: .w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompleteTripConfirmation(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Complete Trip"),
        content: Text("Mark this trip as completed?"),
        actions: [
          TextButton(
            onPressed: () => appNavigator.pop(),
            child: Text("Not Yet"),
          ),
          TextButton(
            onPressed: () {
              _updateTripStatus("Completed");
            },
            child: Text(
              "Complete Trip",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15.sp,
                fontWeight: .w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateTripStatus(String status) async {
    final statusUpdate = context.read<TripStatusUpdateProvider>();
    await statusUpdate.tripStatus(tripId: widget.publishedId, status: status);
    if (statusUpdate.errorMessage != null) {
      appNavigator.pop();
      appSnackbar.showSingleSnackbar(context, statusUpdate.errorMessage ?? "");
      return;
    }
    appSnackbar.showSingleSnackbar(
      context,
      statusUpdate.response?.message ?? "",
    );
    await _fetchData();
    appNavigator.pop();
    appNavigator.pop(true);
    return;
  }

  DateTime? parseTripDateTime(String date, String time) {
    try {
      if (date.isEmpty || time.isEmpty) return null;

      String datePart = date.trim().split('T').first;

      List<String> parts = time.trim().split(':');
      if (parts.length < 2) return null;

      String hour = parts[0].padLeft(2, '0');
      String minute = parts[1].padLeft(2, '0');
      String second = parts.length > 2 ? parts[2].padLeft(2, '0') : '00';

      String cleaned = "$datePart $hour:$minute:$second";

      return DateTime.parse(cleaned);
    } catch (e) {
      debugPrint("parseTripDateTime error → $e");
      return null;
    }
  }
}
