import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/provider/my_rides/passenger_published_list_provider.dart';
import 'package:runaar/provider/my_rides/published_detail_model.dart';
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
              leading: CircleAvatar(
                radius: 22.r,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:
                    data?.personImage != null && data!.personImage!.isNotEmpty
                    ? CachedNetworkImageProvider(
                        "${apiMethods.baseUrl}/${data.personImage}",
                      )
                    : null,
                child:
                    data?.personImage != null && data!.personImage!.isNotEmpty
                    ? null
                    : Icon(Icons.person, size: 24.sp),
              ),
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
    PassengerPublishedListProvider provider = context
        .read<PassengerPublishedListProvider>();
    return provider.isLoading
        ? const CircularProgressIndicator()
        : Card(
            child: Padding(
              padding: 10.all,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Passengers (${provider.response?.passengers?.length ?? 0})",
                    style: theme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.height,
                  provider.errorMessage != null
                      ? Center(child: Text(provider.errorMessage ?? ""))
                      : ListView.builder(
                          itemCount: provider.response?.passengers?.length,
                          itemBuilder: (context, index) {
                            final data = provider.response?.passengers?[index];
                            return _passengerTile(
                              theme,
                              data?.passengerName ?? "",
                              data?.profileImage ?? "",
                              data?.rating ?? 0.0,
                              data?.seatsRequested ?? 0,
                              data?.paymentStatus,
                            );
                          },
                        ),
                ],
              ),
            ),
          );
  }

  Widget _passengerTile(
    TextTheme theme,
    String name,
    String image,
    double rating,
    int seats,
    String? status,
  ) {
    // return Padding(
    //   padding: EdgeInsets.symmetric(vertical: 8.h),
    //   child: Row(
    //     children: [
    //       Container(
    //         width: 40.w,
    //         height: 40.h,
    //         decoration: BoxDecoration(
    //           color: Colors.grey.shade300,
    //           shape: BoxShape.circle,
    //         ),
    //         child: Icon(Icons.person, size: 22.sp),
    //       ),
    //       12.width,
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: .start,
    //           children: [
    //             Text(name, style: theme.titleSmall),
    //             4.height,
    //   RatingBarIndicator(
    //     rating: rating,
    //     itemBuilder: (_, _) =>
    //         const Icon(Icons.star, color: Colors.amber),
    //     itemCount: 5,
    //     itemSize: 14.sp,
    //   ),
    // ],
    //         ),
    //       ),
    //       Text("$seats Seat", style: theme.titleSmall),
    //     ],
    //   ),
    // );
    return ListTile(
      leading: CircleAvatar(
        radius: 22.r,
        backgroundColor: Colors.green.shade300,
        backgroundImage: image.isNotEmpty
            ? CachedNetworkImageProvider("${apiMethods.baseUrl}/$image")
            : null,
        child: image.isEmpty ? Icon(Icons.person, size: 20.sp) : null,
      ),
      title: Text(name, style: theme.titleSmall),
      subtitle: RatingBarIndicator(
        rating: rating,
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
    debugPrint(data?.availableSeats);
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
                  data?.availableSeats ?? "",
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
            if (dateTime != null) break;
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
        String datePart = trip.tripDate!.split('T').first;
        String timePart = trip.originTime!.length >= 5
            ? trip.originTime!.substring(0, 5)
            : "00:00";
        departureTime = DateTime.parse("${datePart}T$timePart:00");
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
        String datePart = trip.tripDate!.split('T').first;
        String timePart = trip.originTime!.length >= 5
            ? trip.originTime!.substring(0, 5)
            : "00:00";
        departureTime = DateTime.parse("${datePart}T$timePart:00");
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Cannot cancel trip within 1 hour of departure"),
              backgroundColor: Colors.orange,
            ),
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
        title: Text("Start Trip"),
        content: Text("Are you ready to start this trip?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              // Call API to update trip status to "started"
              _updateTripStatus("started");
              Navigator.pop(context);
            },
            child: Text(
              "Yes, Start Trip",
              style: TextStyle(color: Colors.green),
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
        title: Text("Cancel Trip"),
        content: Text("Are you sure you want to cancel this trip?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              // Call API to update trip status to "cancelled"
              _updateTripStatus("cancelled");
              Navigator.pop(context);
            },
            child: Text("Yes, Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCompleteTripConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Complete Trip"),
        content: Text("Mark this trip as completed?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Not Yet"),
          ),
          TextButton(
            onPressed: () {
              // Call API to update trip status to "completed"
              _updateTripStatus("completed");
              Navigator.pop(context);
            },
            child: Text("Complete Trip", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _updateTripStatus(String status) {

    // Example API call:
    // apiMethods.post(
    //   endpoint: "trip/update_status",
    //   body: {
    //     "trip_id": widget.publishedId,
    //     "status": status,
    //   },
    //   onSuccess: (response) {
    //     // Show success message
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("Trip status updated successfully")),
    //     );
    //     // Refresh data
    //     _fetchData();
    //   },
    //   onError: (error) {
    //     // Show error message
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("Failed to update trip status: $error")),
    //     );
    //   },
    // );
  }

}