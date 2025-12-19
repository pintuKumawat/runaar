import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';

class MyRidesScreen extends StatelessWidget {
  const MyRidesScreen({super.key});

  // ---------------- MOCK DATA ----------------

  static final List<Map<String, dynamic>> bookedRides = [
    {
      "from": "Delhi",
      "to": "Jaipur",
      "date": "22 Sep 2025",
      "time": "08:30 AM - 01:30 PM",
      "seats": 2,
      "price": 750,
      "status": "Confirmed",
      "driver": "Amit Sharma",
      "rating": 4.6,
    },
  ];

  static final List<Map<String, dynamic>> publishedRides = [
    {
      "from": "Ahmedabad",
      "to": "Udaipur",
      "date": "25 Sep 2025",
      "time": "06:00 AM - 11:00 AM",
      "seats": 3,
      "price": 540,
      "status": "Open",
    },
  ];

  static final List<Map<String, dynamic>> requests = [
    {
      "from": "Surat",
      "to": "Vadodara",
      "date": "28 Sep 2025",
      "time": "09:00 AM",
      "seats": 1,
      "price": 300,
      "user": "Rahul Patel",
      "rating": 4.2,
    },
  ];

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Rides"),
          bottom: TabBar(
            indicatorColor: appColor.mainColor,
            labelStyle: theme.titleMedium?.copyWith(color: Colors.white),
            unselectedLabelStyle: theme.bodyMedium?.copyWith(color: Colors.white),
            tabs: const [
              Tab(text: "Booked"),
              Tab(text: "Published"),
              Tab(text: "Requests"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _bookedTab(theme),
            _publishedTab(theme),
            _requestTab(theme),
          ],
        ),
      ),
    );
  }

  // ---------------- BOOKED ----------------

  Widget _bookedTab(TextTheme theme) {
    return ListView.builder(
      padding: 16.all,
      itemCount: bookedRides.length,
      itemBuilder: (context, index) {
        final ride = bookedRides[index];
        return _rideCard(theme, ride, showDriver: true);
      },
    );
  }

  // ---------------- PUBLISHED ----------------

  Widget _publishedTab(TextTheme theme) {
    return ListView.builder(
      padding: 16.all,
      itemCount: publishedRides.length,
      itemBuilder: (context, index) {
        final ride = publishedRides[index];
        return _rideCard(theme, ride);
      },
    );
  }

  // ---------------- REQUESTS ----------------

  Widget _requestTab(TextTheme theme) {
    return ListView.builder(
      padding: 16.all,
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final r = requests[index];

        return Card(
          margin: EdgeInsets.only(bottom: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Padding(
            padding: 14.all,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${r["from"]} → ${r["to"]}", style: theme.titleMedium),
                6.height,
                Text("${r["date"]} • ${r["time"]}", style: theme.bodyMedium),
                10.height,

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 22.r,
                    backgroundColor: appColor.themeColor,
                    child: Icon(
                      Icons.person,
                      size: 22.sp,
                      color: appColor.mainColor,
                    ),
                  ),
                  title: Text(r["user"], style: theme.bodyLarge),
                  subtitle: RatingBarIndicator(
                    rating: r["rating"],
                    itemBuilder: (_, __) =>
                        const Icon(Icons.star, color: Colors.amber),
                    itemSize: 16.sp,
                  ),
                  trailing: Text("₹${r["price"]}", style: theme.headlineSmall),
                ),

                10.height,

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text("Reject"),
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
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- COMMON RIDE CARD ----------------

  Widget _rideCard(
    TextTheme theme,
    Map<String, dynamic> ride, {
    bool showDriver = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 14.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Padding(
        padding: 14.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${ride["from"]} → ${ride["to"]}", style: theme.titleMedium),
            6.height,
            Text("${ride["date"]} • ${ride["time"]}", style: theme.bodyMedium),
            10.height,

            Row(
              children: [
                Icon(Icons.person, size: 18.sp),
                6.width,
                Text("${ride["seats"]} seats", style: theme.bodyMedium),
                const Spacer(),
                FaIcon(FontAwesomeIcons.indianRupeeSign, size: 14.sp),
                4.width,
                Text("${ride["price"]}", style: theme.headlineSmall),
              ],
            ),

            10.height,

            _statusChip(ride["status"]),

            if (showDriver) ...[
              12.height,
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: appColor.themeColor,
                  child: Icon(
                    Icons.person,
                    size: 20.sp,
                    color: appColor.mainColor,
                  ),
                ),
                title: Text(ride["driver"], style: theme.bodyLarge),
                subtitle: RatingBarIndicator(
                  rating: ride["rating"],
                  itemBuilder: (_, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  itemSize: 16.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------- STATUS CHIP ----------------

  Widget _statusChip(String status) {
    final color = status == "Confirmed" || status == "Open"
        ? Colors.green
        : Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
