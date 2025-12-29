// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:runaar/core/constants/app_color.dart';
// import 'package:runaar/core/responsive/responsive_extension.dart';
// import 'package:runaar/screens/my_rides/booking_details_screen.dart';
// import 'package:runaar/screens/my_rides/published_ride_details_screen.dart';

// class MyRidesScreen extends StatefulWidget {
//   final int initialIndex;
//   final int? userId;
//   const MyRidesScreen({super.key, required this.initialIndex, this.userId});

//   @override
//   State<MyRidesScreen> createState() => _MyRidesScreenState();
// }

// class _MyRidesScreenState extends State<MyRidesScreen> {
//   final TextEditingController _searchCtrl = TextEditingController();
//   String query = "";

//   // ---------------- MOCK DATA ----------------

//   final List<Map<String, String>> booked = [
//     {
//       "bookingId": "101",
//       "from": "New Delhi",
//       "to": "Jaipur",
//       "start": "08:30 AM",
//       "end": "01:30 PM",
//       "price": "750",
//       "name": "Amit Sharma",
//       "rating": "4.6",
//       "status": "Confirmed",
//     },
//     {
//       "bookingId": "101",
//       "from": "New Delhi",
//       "to": "Jaipur",
//       "start": "08:30 AM",
//       "end": "01:30 PM",
//       "price": "750",
//       "name": "Amit Sharma",
//       "rating": "4.6",
//       "status": "Cancelled",
//     },
//     {
//       "bookingId": "101",
//       "from": "New Delhi",
//       "to": "Jaipur",
//       "start": "08:30 AM",
//       "end": "01:30 PM",
//       "price": "750",
//       "name": "Amit Sharma",
//       "rating": "4.6",
//       "status": "Started",
//     },
//   ];

//   final List<Map<String, String>> published = [
//     {
//       "publishedId": "501",
//       "from": "Ahmedabad",
//       "to": "Udaipur",
//       "start": "06:00 AM",
//       "end": "11:00 AM",
//       "price": "540",
//       "name": "25 Sep 2025 · 06:00 AM",
//       "status": "Open",
//     },
//     {
//       "publishedId": "501",
//       "from": "Ahmedabad",
//       "to": "Udaipur",
//       "start": "06:00 AM",
//       "end": "11:00 AM",
//       "price": "540",
//       "name": "25 Sep 2025 · 06:00 AM",
//       "status": "Open",
//     },
//     {
//       "publishedId": "501",
//       "from": "Ahmedabad",
//       "to": "Udaipur",
//       "start": "06:00 AM",
//       "end": "11:00 AM",
//       "price": "540",
//       "name": "25 Sep 2025 · 06:00 AM",
//       "status": "Open",
//     },
//   ];

//   final List<Map<String, String>> requests = [
//     {
//       "from": "Surat",
//       "to": "Vadodara",
//       "price": "300",
//       "name": "Rahul Patel",
//       "rating": "4.2",
//       "start": "09:00 AM",
//       "end": "11:00 AM",
//       "seats": "2",
//     },
//     {
//       "from": "Surat",
//       "to": "Vadodara",
//       "price": "300",
//       "name": "Rahul Patel",
//       "rating": "4.2",
//       "start": "09:00 AM",
//       "end": "11:00 AM",
//       "seats": "2",
//     },
//     {
//       "from": "Surat",
//       "to": "Vadodara",
//       "price": "300",
//       "name": "Rahul Patel",
//       "rating": "4.2",
//       "start": "09:00 AM",
//       "end": "11:00 AM",
//       "seats": "2",
//     },
//   ];

//   bool match(String v) => v.toLowerCase().contains(query.toLowerCase());

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).textTheme;

//     return DefaultTabController(
//       length: 3,
//       initialIndex: widget.initialIndex.clamp(0, 2),
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(110.h),
//           child: AppBar(
//             title: Padding(
//               padding: 10.all,
//               child: TextField(
//                 controller: _searchCtrl,
//                 onChanged: (v) => setState(() => query = v),
//                 decoration: InputDecoration(
//                   hintText: "Search by city or route",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14.r),
//                   ),
//                 ),
//               ),
//             ),
//             bottom: const TabBar(
//               tabs: [
//                 Tab(text: "Booked"),
//                 Tab(text: "Published"),
//                 Tab(text: "Requests"),
//               ],
//             ),
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _listView(theme, booked, type: "booked"),
//             _listView(theme, published, type: "published"),
//             _listView(theme, requests, type: "request"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _listView(
//     TextTheme theme,
//     List<Map<String, String>> data, {
//     required String type,
//   }) {
//     return ListView.builder(
//       padding: 10.all,
//       itemCount: data.length,
//       itemBuilder: (_, i) {
//         final d = data[i];

//         if (!match(d["from"]!) && !match(d["to"]!)) {
//           return const SizedBox.shrink();
//         }

//         return _rideCard(
//           theme: theme,
//           price: d["price"]!,
//           startTime: d["start"] ?? "",
//           endTime: d["end"] ?? "",
//           from: d["from"]!,
//           to: d["to"]!,
//           name: d["name"]!,
//           rating: d["rating"],
//           status: d["status"],
//           bookingId: d["bookingId"],
//           publishedId: d["publishedId"],
//           seats: d["seats"],
//           type: type,
//         );
//       },
//     );
//   }

//   Widget _rideCard({
//     required TextTheme theme,
//     required String price,
//     required String startTime,
//     required String endTime,
//     required String from,
//     required String to,
//     required String name,
//     String? rating,
//     String? status,
//     String? seats,
//     String? bookingId,
//     String? publishedId,
//     required String type,
//   }) {
//     return InkWell(
//       onTap: () {
//         if (type == "booked" && bookingId != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) =>
//                   BookingDetailsScreen(bookingId: int.parse(bookingId)),
//             ),
//           );
//         }

//         if (type == "published" && publishedId != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => PublishedRideDetailsScreen(
//                 publishedId: int.parse(publishedId),
//               ),
//             ),
//           );
//         }
//       },
//       child: Card(
//         child: Column(
//           children: [
//             Padding(
//               padding: 10.all,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _timeLine(startTime, endTime, theme),
//                   14.width,
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _locationText(from, theme),
//                         22.height,
//                         _locationText(to, theme),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: .end,
//                     spacing: 25.h,
//                     children: [
//                       Text(
//                         "₹ $price",
//                         style: theme.titleMedium?.copyWith(
//                           color: appColor.mainColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       if (status != null) ...[_statusView(theme, status)],
//                       if (type == "request" && seats != null) ...[
//                         Row(
//                           children: [
//                             Text("Seats: ", style: theme.bodySmall),
//                             Text(
//                               seats,
//                               style: theme.bodySmall?.copyWith(
//                                 fontWeight: .w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const Divider(),

//             type == "request"
//                 ? _requestFooter(theme, name, rating!)
//                 : _normalFooter(theme, name, rating, type),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _timeLine(String start, String end, TextTheme theme) {
//     return Column(
//       children: [
//         Text(start, style: theme.bodySmall),
//         6.height,
//         Container(height: 22.h, width: 2.w, color: Colors.grey),
//         6.height,
//         Text(end, style: theme.bodySmall),
//       ],
//     );
//   }

//   Widget _locationText(String text, TextTheme theme) {
//     return Text(
//       text,
//       maxLines: 1,
//       overflow: TextOverflow.ellipsis,
//       style: theme.titleMedium,
//     );
//   }

//   Color _statusColor(String status) {
//     switch (status.toLowerCase()) {
//       case "confirmed":
//       case "open":
//       case "started":
//         return Colors.green;
//       case "pending":
//         return Colors.orange;
//       case "completed":
//         return Colors.blue;
//       case "rejected":
//       case "cancelled":
//       case "closed":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   Widget _statusView(TextTheme theme, String status) {
//     final color = _statusColor(status);
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 8.w,
//           height: 8.w,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         6.width,
//         Text(
//           status,
//           style: theme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
//         ),
//       ],
//     );
//   }

//   Widget _normalFooter(
//     TextTheme theme,
//     String name,
//     String? rating,
//     String type,
//   ) {
//     return Padding(
//       padding: 10.hv(5),
//       child: Column(
//         crossAxisAlignment: .start,
//         children: [
//           Text(
//             "Posted By:",
//             style: theme.bodySmall?.copyWith(color: Colors.black45),
//           ),
//           ListTile(
//             contentPadding: 5.vertical,

//             leading: CircleAvatar(
//               radius: 22.r,
//               backgroundColor: Colors.grey.shade300,
//               child: const Icon(Icons.person),
//             ),
//             title: Text(name, style: theme.bodyMedium),
//             subtitle: rating == null
//                 ? null
//                 : Row(
//                     children: [
//                       RatingBarIndicator(
//                         rating: double.tryParse(rating) ?? 0.0,
//                         itemBuilder: (_, _) =>
//                             const Icon(Icons.star, color: Colors.amber),
//                         itemCount: 5,
//                         itemSize: 14.sp,
//                       ),
//                       6.width,
//                       Text(rating, style: theme.bodySmall),
//                     ],
//                   ),
//             trailing: Icon(
//               type == "published" ? Icons.schedule : Icons.directions_car,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _requestFooter(TextTheme theme, String name, String rating) {
//     return Column(
//       children: [
//         ListTile(
//           leading: CircleAvatar(
//             radius: 22.r,
//             backgroundColor: Colors.grey.shade300,
//             child: const Icon(Icons.person),
//           ),
//           title: Text(name, style: theme.bodyLarge),
//           subtitle: Row(
//             children: [
//               RatingBarIndicator(
//                 rating: double.tryParse(rating) ?? 0.0,
//                 itemBuilder: (_, _) =>
//                     const Icon(Icons.star, color: Colors.amber),
//                 itemCount: 5,
//                 itemSize: 16.sp,
//               ),
//               6.width,
//               Text(rating, style: theme.bodySmall),
//             ],
//           ),
//         ),

//         Padding(
//           padding: 10.all,
//           child: Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: () {},
//                   child: Text(
//                     "Reject",
//                     style: theme.titleLarge!.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: context.isMobile
//                           ? 20.sp
//                           : context.isTablet
//                           ? 13.sp
//                           : 9.sp,
//                       color: Colors.red,
//                     ),
//                   ),
//                 ),
//               ),
//               12.width,
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   child: const Text("Accept"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// give me json only for booked page now

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Text_Formatter/text_formatter.dart';
import 'package:runaar/provider/my_rides/booking_list_provider.dart';
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
  int _currentTabIndex = 0;
  int userId = 0;

  Future<void> _fetchPublishedRides() async {
    if (userId != 0) {
      await context.read<PublishedListProvider>().publishedList(userId: userId);
    }
  }

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

  Future<void> _fetchData() async {
    await _fetchBookingList();
    await _fetchPublishedRides();
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
                if (_currentTabIndex == 0) _fetchBookingList();
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
          children: [_bookingTab(theme), _publishedTab(theme), Container()],
        ),
      ),
    );
  }

  Widget _bookingTab(TextTheme theme) {
    final prov = context.watch<BookingListProvider>();
    final data = prov.response?.bookingList ?? [];

    return RefreshIndicator(
      onRefresh: _fetchBookingList,
      child: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
          ? Center(child: Text("No bookings found", style: theme.bodyMedium))
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
                  // isVerified: d.
                );
              },
            ),
    );
  }

  Widget _publishedTab(TextTheme theme) {
    final prov = context.watch<PublishedListProvider>();
    final data = prov.response?.publishedTrip ?? [];

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
                  startTime: removeSeconds(d.deptTime?.trim() ?? ""),
                  endTime: removeSeconds(d.arrivalTime?.trim() ?? ""),
                  // startTime: (d.deptTime?.trim() ?? ""),
                  // endTime: (d.arrivalTime?.trim() ?? ""),
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
    String? image,
    String? rating,
    String? status,
    String? seats,
    int? bookingId,
    int? publishedId,
    int? requestId,
    String? publishedDate,
    required String type,
    int? isVerified,

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
              _buildRequestFooter(
                theme,
                name,
                rating,
                requestId,
                onAccept,
                onReject,
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
            leading: CircleAvatar(
              radius: 22.r,
              backgroundColor: Colors.grey.shade300,
              child: image == ""
                  ? const Icon(Icons.person)
                  : CachedNetworkImage(
                      imageUrl: "${apiMethods.baseUrl}/$image",
                      fit: .contain,
                    ),
            ),
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
    ).toLocal(); // convert to device timezone
    final formatted = DateFormat('dd MMM yyyy · HH:mm aa').format(dateTime);
    return formatted;
  }

  String removeSeconds(String time) {
    final parts = time.split(':');
    return "${parts[0]}:${parts[1]}";
  }
}
