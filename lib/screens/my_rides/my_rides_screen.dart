import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/core/utils/helpers/Text_Formatter/text_formatter.dart';
import 'package:runaar/core/utils/helpers/default_image/default_image.dart';
import 'package:runaar/provider/my_rides/booking_list_provider.dart';
import 'package:runaar/provider/my_rides/published_list_provider.dart';
import 'package:runaar/provider/my_rides/request_list_provider.dart';
import 'package:runaar/provider/my_rides/request_response_provider.dart';
import 'package:runaar/screens/my_rides/booking_details_screen.dart';
import 'package:runaar/screens/my_rides/published_ride_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRidesScreen extends StatefulWidget {
  final int initialIndex;

  const MyRidesScreen({super.key, required this.initialIndex});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String query = "";
  int _currentTabIndex = 0;
  int userId = 0;

  Future<void> getuserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt(savedData.userId);
    setState(() {
      userId = id ?? 0;
    });
  }

  Future<void> _fetchBookingList() async {
    if (userId != 0) {
      await context.read<BookingListProvider>().bookingList(userId: userId);
    }
  }

  Future<void> _fetchPublishedRides() async {
    if (userId != 0) {
      await context.read<PublishedListProvider>().publishedList(userId: userId);
    }
  }

  Future<void> _fetchRequestList() async {
    if (userId != 0) {
      await context.read<RequestListProvider>().requestList(userId: userId);
    }
  }

  Future<void> _fetchData() async {
    await _fetchBookingList();
    await _fetchPublishedRides();
    _fetchRequestList();
  }

  bool _matchItem(String from, String to) {
    return from.toLowerCase().contains(query.toLowerCase()) ||
        to.toLowerCase().contains(query.toLowerCase());
  }

  @override
  void initState() {
    super.initState();
    getuserId().then((value) => _fetchData());
    _currentTabIndex = widget.initialIndex.clamp(0, 2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 3,
      initialIndex: _currentTabIndex,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.h),
          child: AppBar(
            title: Padding(
              padding: 10.horizontal,
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => query = v),
                inputFormatters: [FirstLetterCapitalFormatter()],
                decoration: InputDecoration(
                  hintText: "Search by city or route",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              onTap: (index) {
                _currentTabIndex = index;
                if (_currentTabIndex == 0) _fetchBookingList();
                if (_currentTabIndex == 1) _fetchPublishedRides();
                if (_currentTabIndex == 2) _fetchRequestList();
                setState(() {});
              },
              tabs: const [
                Tab(text: "Booked"),
                Tab(text: "Published"),
                Tab(text: "Requests"),
              ],
            ),
          ),
        ),
        body: TabBarView(

          children: [
            Consumer<BookingListProvider>(
              builder: (context, bookingProv, child) {
                return _bookingTab(theme, bookingProv);
              },
            ),
            Consumer<PublishedListProvider>(
              builder: (context, publishedProv, child) {
                return _publishedTab(theme, publishedProv);
              },
            ),
            Consumer<RequestListProvider>(
              builder: (context, requestProv, child) {
                return _requestTab(theme, requestProv);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bookingTab(TextTheme theme, BookingListProvider bookingProv) {
    final data = bookingProv.response?.bookingList ?? [];
    return RefreshIndicator(
      onRefresh: _fetchBookingList,
      child: bookingProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingProv.errorMessage != null
          ? Center(
              child: Text(
                bookingProv.errorMessage ?? "",
                style: theme.bodyMedium,
              ),
            )
          : ListView.builder(
              padding: 10.all,
              itemCount: data.length,
              itemBuilder: (_, i) {
                final d = data[i];
                if (!_matchItem(d.originCity ?? "", d.destinationCity ?? "")) {
                  return const SizedBox.shrink();
                }

                return _rideCard(
                  theme: theme,
                  price: d.pricePerSeat?.toString() ?? "0",
                  startTime: removeSeconds(d.originTime ?? ""),
                  endTime: removeSeconds(d.destinationTime ?? ""),
                  from: d.originCity ?? "",
                  to: d.destinationCity ?? "",
                  name: d.driverName ?? "",
                  image: d.profileImage,
                  status: d.bookingStatus,
                  bookingId: d.bookingId,
                  rating: d.driverRating.toString(),
                  type: "booked",
                  isVerified: d.driverVerified,
                );
              },
            ),
    );
  }

  Widget _publishedTab(TextTheme theme, PublishedListProvider publishedProv) {
    final data = publishedProv.response?.publishedTrip ?? [];

    return RefreshIndicator(
      onRefresh: _fetchPublishedRides,
      child: publishedProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : publishedProv.errorMessage != null
          ? Center(
              child: Text(
                publishedProv.errorMessage ?? "",
                style: theme.bodyMedium,
              ),
            )
          : ListView.builder(
              padding: 10.all,
              itemCount: data.length,
              itemBuilder: (_, i) {
                final d = data[i];
                if (!_matchItem(d.originCity ?? "", d.destinationCity ?? "")) {
                  return const SizedBox.shrink();
                }

                return _rideCard(
                  theme: theme,
                  price: d.seatPrice?.toString() ?? "0",
                  startTime: removeSeconds(d.deptTime?.trim() ?? ""),
                  endTime: removeSeconds(d.arrivalTime?.trim() ?? ""),
                  from: d.originCity ?? "",
                  to: d.destinationCity ?? "",
                  name: d.createdAt ?? "",
                  status: d.tripStatus,
                  publishedId: d.tripId,
                  publishedDate: d.createdAt,
                  type: "published",
                );
              },
            ),
    );
  }

  Widget _requestTab(TextTheme theme, RequestListProvider requestProv) {
    final data = requestProv.response?.requestList ?? [];
    return RefreshIndicator(
      onRefresh: _fetchRequestList,
      child: requestProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : requestProv.errorMessage != null
          ? Center(
              child: Text(
                requestProv.errorMessage ?? "",
                style: theme.bodyMedium,
              ),
            )
          : ListView.builder(
              padding: 10.all,
              itemCount: data.length,
              itemBuilder: (_, i) {
                final d = data[i];
                if (!_matchItem(d.originCity ?? "", d.destinationCity ?? "")) {
                  return const SizedBox.shrink();
                }

                return _rideCard(
                  theme: theme,
                  price: d.pricePerSeat?.toString() ?? "0",
                  startTime: removeSeconds(d.deptTime?.trim() ?? ""),
                  endTime: removeSeconds(d.arrivalTime?.trim() ?? ""),
                  from: d.originCity ?? "",
                  to: d.destinationCity ?? "",
                  name: d.name ?? "",
                  requestId: d.id,
                  seats: d.seatsRequested.toString(),
                  rating: d.rating.toString(),
                  image: d.profileImage,
                  onAccept: () async {
                    final requestResponse = context
                        .read<RequestResponseProvider>();
                    await requestResponse.requestResponse(
                      bookingId: d.id ?? 0,
                      status: "Confirmed",
                    );
                    if (requestResponse.errorMessage != null) {
                      appSnackbar.showSingleSnackbar(
                        context,
                        requestResponse.errorMessage ?? "",
                      );
                      return;
                    }
                    appSnackbar.showSingleSnackbar(
                      context,
                      requestResponse.response?.message ?? "",
                    );
                    await _fetchRequestList();
                  },
                  onReject: () async {
                    final requestResponse = context
                        .read<RequestResponseProvider>();
                    await requestResponse.requestResponse(
                      bookingId: d.id ?? 0,
                      status: "Rejected",
                    );
                    if (requestResponse.errorMessage != null) {
                      appSnackbar.showSingleSnackbar(
                        context,
                        requestResponse.errorMessage ?? "",
                      );
                      return;
                    }
                    appSnackbar.showSingleSnackbar(
                      context,
                      requestResponse.response?.message ?? "",
                    );
                    await _fetchRequestList();
                  },
                  isVerified: d.isActive,
                  paymentStatus: d.paymentMethod,
                  type: "request",
                );
              },
            ),
    );
  }

  Widget _rideCard({
    required TextTheme theme,
    required String price,
    required String startTime,
    required String endTime,
    required String from,
    required String to,
    required String name,
    String? image,
    String? rating,
    String? status,
    String? seats,
    int? bookingId,
    int? publishedId,
    int? requestId,
    String? paymentStatus,
    String? publishedDate,
    required String type,
    int? isVerified,

    VoidCallback? onAccept,
    VoidCallback? onReject,
  }) {
    return InkWell(
      onTap: () async {
        if (publishedId != null && type.toLowerCase() == "published") {
          final bool? result = await appNavigator.push(
            PublishedRideDetailsScreen(publishedId: publishedId),
          );
          if (result ?? true) {
            _fetchPublishedRides();
          }
          return;
        }
        if (bookingId != null && type.toLowerCase() == "booked") {
          final bool? result = await appNavigator.push(
            BookingDetailsScreen(bookingId: bookingId),
          );
          if (result ?? true) {
            _fetchBookingList();
          }
          return;
        }
      },
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: 10.all,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeline(startTime, endTime, theme),
                  14.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLocationText(from, theme),
                        22.height,
                        _buildLocationText(to, theme),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹$price/seat",
                        style: theme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      25.height,
                      if (status != null) _buildStatusView(status, theme),
                      if (type == "request" && seats != null) ...[
                        10.height,
                        Row(
                          children: [
                            Text("Seats: ", style: theme.bodySmall),
                            Text(
                              seats,
                              style: theme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            if (type == "request")
              _buildRequestFooter(
                theme,
                name,
                rating,
                requestId,
                image,
                onAccept,
                onReject,
                paymentStatus,
              )
            else if (type == "published")
              _buildPublishedFooter(
                theme,
                formatDateTime(publishedDate ?? DateTime.now().toString()),
              )
            else
              _buildNormalFooter(
                theme,
                isVerified ?? 0,
                name,
                rating ?? "",
                image ?? "",
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(String start, String end, TextTheme theme) {
    return Column(
      children: [
        Text(start, style: theme.bodySmall),
        6.height,
        Container(height: 22.h, width: 2.w, color: appColor.mainColor),
        6.height,
        Text(end, style: theme.bodySmall),
      ],
    );
  }

  Widget _buildLocationText(String text, TextTheme theme) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.titleMedium,
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "confirmed":
      case "open":
      case "accepted":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "completed":
      case "started":
        return Colors.blue;
      case "rejected":
      case "cancelled":
      case "closed":
      case "declined":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusView(String status, TextTheme theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            shape: BoxShape.circle,
          ),
        ),
        6.width,
        Text(
          status,
          style: theme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildNormalFooter(
    TextTheme theme,
    int isVerified,
    String name,
    String rating,
    String image,
  ) {
    return Padding(
      padding: 10.all,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Posted By:",
            style: theme.bodySmall?.copyWith(color: Colors.black45),
          ),
          ListTile(
            contentPadding: 2.vertical,
            leading: defaultImage.userProvider(image, 22.r),
            title: Row(
              children: [
                Text(name, style: theme.bodyMedium),
                4.width,
                Icon(
                  Icons.verified,
                  size: 16.sp,
                  color: isVerified == 1 ? Colors.green : Colors.grey,
                ),
              ],
            ),
            subtitle: rating.isEmpty
                ? null
                : Row(
                    children: [
                      RatingBarIndicator(
                        rating: double.tryParse(rating) ?? 0.0,
                        itemBuilder: (_, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 14.sp,
                      ),
                      6.width,
                      Text(rating, style: theme.bodySmall),
                    ],
                  ),
            trailing: const Icon(Icons.directions_car, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishedFooter(TextTheme theme, String date) {
    return Padding(
      padding: 10.all,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Posted on:",
            style: theme.bodySmall?.copyWith(color: Colors.black45),
          ),
          ListTile(
            contentPadding: 2.vertical,
            leading: CircleAvatar(
              radius: 22.r,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person),
            ),
            title: Text(date, style: theme.bodyMedium),
            trailing: const Icon(Icons.schedule, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestFooter(
    TextTheme theme,
    String name,
    String? rating,
    int? requestId,
    String? image,
    VoidCallback? onAccept,
    VoidCallback? onReject,
    String? paymentStatus,
  ) {
    return Padding(
      padding: 10.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Posted by:",
            style: theme.bodySmall?.copyWith(color: Colors.black45),
          ),
          ListTile(
            contentPadding: 2.vertical,
            leading: defaultImage.userProvider(image, 22.r),
            title: Text(name, style: theme.bodyLarge),
            subtitle: rating == null
                ? null
                : Row(
                    children: [
                      RatingBarIndicator(
                        rating: double.tryParse(rating) ?? 0.0,
                        itemBuilder: (_, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 16.sp,
                      ),
                      6.width,
                      Text(rating, style: theme.bodySmall),
                    ],
                  ),
            trailing: Column(
              mainAxisSize: .min,
              children: [
                Text("Pay via", style: theme.labelLarge),
                Container(
                  padding: 4.horizontal,
                  decoration: BoxDecoration(
                    color: paymentStatus?.toLowerCase() == "cash"
                        ? Colors.amber.shade100
                        : Colors.green.shade300,
                    borderRadius: .circular(5.r),
                  ),
                  child: Text(
                    paymentStatus ?? "",
                    style: theme.bodyMedium?.copyWith(
                      color: paymentStatus?.toLowerCase() == "cash"
                          ? Colors.amber.shade900
                          : Colors.green.shade900,
                      fontWeight: .w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: 10.all,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    child: Text(
                      "Reject",
                      style: theme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                12.width,
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    child: const Text("Accept"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDateTime(String isoString) {
    final dateTime = DateTime.parse(
      isoString,
    ).toLocal(); // convert to device timezone
    final formatted = DateFormat('dd MMM yyyy · HH:mm aa').format(dateTime);
    return formatted;
  }

  String removeSeconds(String time) {
    final parts = time.split(':');
    return "${parts[0]}:${parts[1]}";
  }
}
