import 'package:flutter/material.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  /// 🔹 STATIC MOCK DATA
  static final List<Map<String, dynamic>> notifications = [
    {
      "title": "Ride Confirmed",
      "message": "Your ride from Delhi to Jaipur is confirmed.",
      "isRead": false,
      "type": "alert",
      "time": "2 min ago",
    },
    {
      "title": "New Message",
      "message": "Driver has sent you a message.",
      "isRead": true,
      "type": "message",
      "time": "10 min ago",
    },
    {
      "title": "Promotion",
      "message": "Get 20% off on your next ride.",
      "isRead": false,
      "type": "promotion",
      "time": "1 day ago",
    },
    {
      "title": "Ride Confirmed",
      "message": "Your ride from Delhi to Jaipur is confirmed.",
      "isRead": false,
      "type": "alert",
      "time": "2 min ago",
    },
    {
      "title": "New Message",
      "message": "Driver has sent you a message.",
      "isRead": true,
      "type": "message",
      "time": "10 min ago",
    },
    {
      "title": "Promotion",
      "message": "Get 20% off on your next ride.",
      "isRead": false,
      "type": "promotion",
      "time": "1 day ago",
    },
    {
      "title": "Ride Confirmed",
      "message": "Your ride from Delhi to Jaipur is confirmed.",
      "isRead": false,
      "type": "alert",
      "time": "2 min ago",
    },
    {
      "title": "New Message",
      "message": "Driver has sent you a message.",
      "isRead": true,
      "type": "message",
      "time": "10 min ago",
    },
    {
      "title": "Promotion",
      "message": "Get 20% off on your next ride.",
      "isRead": false,
      "type": "promotion",
      "time": "1 day ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications", style: theme.titleLarge),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? _emptyView(context)
          : Padding(
              padding: 8.all,
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    "Tap to mark as read",
                    textAlign: TextAlign.right,
                    style: theme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {},
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return _notificationTile(
                            context,
                            theme,
                            notifications[index],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// ---------------- EMPTY VIEW ----------------

  Widget _emptyView(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 60.sp,
            color: Colors.grey.shade400,
          ),
          20.height,
          Text("No notifications yet", style: theme.headlineSmall),
        ],
      ),
    );
  }

  Widget _notificationTile(
    BuildContext context,
    TextTheme theme,
    Map<String, dynamic> item,
  ) {
    final String type = item["type"];

    Color accentColor;
    IconData icon;

    switch (type) {
      case "message":
        accentColor = Colors.green;
        icon = Icons.chat_bubble_outline;
        break;
      case "alert":
        accentColor = Colors.red;
        icon = Icons.warning_amber_rounded;
        break;
      case "promotion":
        accentColor = Colors.purple;
        icon = Icons.local_offer_outlined;
        break;
      default:
        accentColor = Colors.blueGrey;
        icon = Icons.notifications;
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 22.r,
          backgroundColor: accentColor.withOpacity(0.12),
          child: Icon(icon, color: accentColor, size: 20.sp),
        ),

        /// TITLE
        title: Text(
          item["title"],
          style: theme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        /// SUBTITLE
        subtitle: Text(
          item["message"],
          style: theme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          item["time"],
          style: theme.bodySmall?.copyWith(color: Colors.grey),
        ),

        onTap: () {
          // mark as read / navigate later
        },
      ),
    );
  }
}
