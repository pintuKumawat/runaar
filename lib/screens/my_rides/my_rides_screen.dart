import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Text_Formatter/text_formatter.dart';
import 'package:runaar/provider/my_rides/published_list_provider.dart';
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
  int userId = 0;
  int _currentTabIndex = 0;

  Future<void> getuserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt(savedData.userId) ?? 0;
    if (mounted) setState(() {});
  }

  Future<void> _fetchPublishedRides() async {
    if (userId != 0) {
      await context.read<PublishedListProvider>().publishedList(userId: userId);
    }
  }

  bool _matchItem(String from, String to) {
    return from.toLowerCase().contains(query.toLowerCase()) ||
        to.toLowerCase().contains(query.toLowerCase());
  }

  @override
  void initState() {
    super.initState();
    getuserId().then((_) => _fetchPublishedRides());
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
              padding: 10.all,
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
                if (_currentTabIndex == 1) _fetchPublishedRides();
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
          children: [Container(), _publishedTab(theme), Container()],
        ),
      ),
    );
  }

  Widget _publishedTab(TextTheme theme) {
    final prov = context.watch<PublishedListProvider>();
    final data = prov.response?.publishedRide ?? [];

    return RefreshIndicator(
      onRefresh: _fetchPublishedRides,
      child: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
          ? Center(
              child: Text("No published rides found", style: theme.bodyMedium),
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
                  startTime: d.deptTime ?? "",
                  endTime: d.arrivalTime ?? "",
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

  Widget _rideCard({
    required TextTheme theme,
    required String price,
    required String startTime,
    required String endTime,
    required String from,
    required String to,
    required String name,
    String? rating,
    String? status,
    String? seats,
    int? bookingId,
    int? publishedId,
    int? requestId,
    String? publishedDate,
    required String type,

    VoidCallback? onAccept,
    VoidCallback? onReject,
  }) {
    
    return InkWell(
      onTap: () {
        if (publishedId != null && type.toLowerCase() == "published") {
          appNavigator.push(
            PublishedRideDetailsScreen(publishedId: publishedId),
          );
          return;
        }
        if (publishedId != null && type.toLowerCase() == "booked") {
          appNavigator.push(BookingDetailsScreen(bookingId: bookingId ?? 0));
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
              _buildRequestFooter(theme, name, rating, onAccept, onReject)
            else if (type == "published")
              _buildPublishedFooter(
                theme,
                formatDateTime(publishedDate ?? DateTime.now().toString()),
              )
            else
              _buildNormalFooter(theme, name, rating ?? ""),
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
        Container(height: 22.h, width: 2.w, color: Colors.grey),
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

  Widget _buildNormalFooter(TextTheme theme, String name, String rating) {
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
            leading: CircleAvatar(
              radius: 22.r,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person),
            ),
            title: Text(name, style: theme.bodyMedium),
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
    VoidCallback? onAccept,
    VoidCallback? onReject,
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
            leading: CircleAvatar(
              radius: 22.r,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person),
            ),
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
                      style: theme.titleLarge?.copyWith(
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
    ).toLocal();
    final formatted = DateFormat('dd MMM yyyy · HH:mm aa').format(dateTime);
    return formatted;
  }
}
