import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/screens/my_rides/booking_details_screen.dart';
import 'package:runaar/screens/my_rides/published_ride_details_screen.dart';

class MyRidesScreen extends StatefulWidget {
  final int initialIndex;
  const MyRidesScreen({super.key, required this.initialIndex});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String query = "";

  // ---------------- MOCK DATA ----------------

  final List<Map<String, String>> booked = [
    {
      "bookingId": "101",
      "from": "New Delhi",
      "to": "Jaipur",
      "start": "08:30 AM",
      "end": "01:30 PM",
      "price": "750",
      "name": "Amit Sharma",
      "rating": "4.6",
      "status": "Confirmed",
    },
    {
      "bookingId": "101",
      "from": "New Delhi",
      "to": "Jaipur",
      "start": "08:30 AM",
      "end": "01:30 PM",
      "price": "750",
      "name": "Amit Sharma",
      "rating": "4.6",
      "status": "Confirmed",
    },
    {
      "bookingId": "101",
      "from": "New Delhi",
      "to": "Jaipur",
      "start": "08:30 AM",
      "end": "01:30 PM",
      "price": "750",
      "name": "Amit Sharma",
      "rating": "4.6",
      "status": "Confirmed",
    },
  ];

  final List<Map<String, String>> published = [
    {
      "publishedId": "501",
      "from": "Ahmedabad",
      "to": "Udaipur",
      "start": "06:00 AM",
      "end": "11:00 AM",
      "price": "540",
      "name": "25 Sep 2025 · 06:00 AM",
      "status": "Open",
    },
    {
      "publishedId": "501",
      "from": "Ahmedabad",
      "to": "Udaipur",
      "start": "06:00 AM",
      "end": "11:00 AM",
      "price": "540",
      "name": "25 Sep 2025 · 06:00 AM",
      "status": "Open",
    },
    {
      "publishedId": "501",
      "from": "Ahmedabad",
      "to": "Udaipur",
      "start": "06:00 AM",
      "end": "11:00 AM",
      "price": "540",
      "name": "25 Sep 2025 · 06:00 AM",
      "status": "Open",
    },
  ];

  final List<Map<String, String>> requests = [
    {
      "from": "Surat",
      "to": "Vadodara",
      "price": "300",
      "name": "Rahul Patel",
      "rating": "4.2",
      "start": "09:00 AM",
      "end": "11:00 AM",
    },
    {
      "from": "Surat",
      "to": "Vadodara",
      "price": "300",
      "name": "Rahul Patel",
      "rating": "4.2",
      "start": "09:00 AM",
      "end": "11:00 AM",
    },
    {
      "from": "Surat",
      "to": "Vadodara",
      "price": "300",
      "name": "Rahul Patel",
      "rating": "4.2",
      "start": "09:00 AM",
      "end": "11:00 AM",
    },
  ];

  bool match(String v) => v.toLowerCase().contains(query.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 3,
      initialIndex: widget.initialIndex.clamp(0, 2),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.h),
          child: AppBar(
            title: Padding(
              padding: 10.all,
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => query = v),
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
            bottom: const TabBar(
              tabs: [
                Tab(text: "Booked"),
                Tab(text: "Published"),
                Tab(text: "Requests"),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _listView(theme, booked, type: "booked"),
            _listView(theme, published, type: "published"),
            _listView(theme, requests, type: "request"),
          ],
        ),
      ),
    );
  }

  Widget _listView(
    TextTheme theme,
    List<Map<String, String>> data, {
    required String type,
  }) {
    return ListView.builder(
      padding: 10.all,
      itemCount: data.length,
      itemBuilder: (_, i) {
        final d = data[i];

        if (!match(d["from"]!) && !match(d["to"]!)) {
          return const SizedBox.shrink();
        }

        return _rideCard(
          theme: theme,
          price: d["price"]!,
          startTime: d["start"] ?? "",
          endTime: d["end"] ?? "",
          from: d["from"]!,
          to: d["to"]!,
          name: d["name"]!,
          rating: d["rating"],
          status: d["status"],
          bookingId: d["bookingId"],
          publishedId: d["publishedId"],
          type: type,
        );
      },
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
    String? bookingId,
    String? publishedId,
    required String type,
  }) {
    return InkWell(
      onTap: () {
        if (type == "booked" && bookingId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingDetailsScreen(bookingId: bookingId),
            ),
          );
        }

        if (type == "published" && publishedId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PublishedRideDetailsScreen(publishedId: publishedId),
            ),
          );
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
                  _timeLine(startTime, endTime, theme),
                  14.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _locationText(from, theme),
                        22.height,
                        _locationText(to, theme),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: .end,
                    spacing: 25.h,
                    children: [
                      Text(
                        "₹ $price",
                        style: theme.titleMedium?.copyWith(
                          color: appColor.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (status != null) ...[_statusView(theme, status)],
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            type == "request"
                ? _requestFooter(theme, name, rating!)
                : _normalFooter(theme, name, rating, type),
          ],
        ),
      ),
    );
  }

  Widget _timeLine(String start, String end, TextTheme theme) {
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

  Widget _locationText(String text, TextTheme theme) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.titleMedium,
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "confirmed":
      case "open":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "completed":
        return Colors.blue;
      case "rejected":
      case "cancelled":
      case "closed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _statusView(TextTheme theme, String status) {
    final color = _statusColor(status);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        6.width,
        Text(
          status,
          style: theme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _normalFooter(
    TextTheme theme,
    String name,
    String? rating,
    String type,
  ) {
    return ListTile(
      contentPadding: 10.all,

      leading: CircleAvatar(
        radius: 22.r,
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.person),
      ),
      title: Text(name, style: theme.bodyMedium),
      subtitle: rating == null
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
      trailing: Icon(
        type == "published" ? Icons.schedule : Icons.directions_car,
        color: Colors.grey,
      ),
    );
  }

  Widget _requestFooter(TextTheme theme, String name, String rating) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 22.r,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person),
          ),
          title: Text(name, style: theme.bodyLarge),
          subtitle: Row(
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
                  onPressed: () {},
                  child: Text(
                    "Reject",
                    style: theme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: context.isMobile
                          ? 20.sp
                          : context.isTablet
                          ? 13.sp
                          : 9.sp,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              12.width,
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Accept"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
