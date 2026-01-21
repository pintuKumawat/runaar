import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/models/notification/get_notification_model.dart';
import 'package:runaar/provider/notification/notification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int userId = 0;
  Future<void> getuserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt(savedData.userId);
    setState(() {
      userId = id ?? 0;
    });
  }

  Future<void> _fetchData() async {
    await context.read<NotificationProvider>().getNotification(userId: userId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => getuserId().then((value) => _fetchData()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              if (provider.count == 0) return const SizedBox();
              return TextButton(
                onPressed: () {
                  context.read<NotificationProvider>().markAllAsRead(
                    userId: userId,
                  );
                },
                child: const Text(
                  "Mark all",
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: Padding(
          padding: 10.all,
          child: Consumer<NotificationProvider>(
            builder: (context, notification, _) {
              if (notification.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (notification.errorMessage != null) {
                return _emptyView(context);
              }

              final list = notification.response?.notifications ?? [];

              if (list.isEmpty) {
                return _emptyView(context);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Tap to mark as read",
                    textAlign: TextAlign.right,
                    style: theme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return _notificationTile(
                          context,
                          theme,
                          list[index],
                          index,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

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
    Notifications item,
    int index,
  ) {
    Color accentColor;
    IconData icon;

    switch (item.data?.toLowerCase()) {
      case "new request":
        accentColor = Colors.green;
        icon = Icons.notifications;
        break;
      case "confirmed":
        accentColor = Colors.green;
        icon = Icons.chat_bubble_outline;
        break;
      case "completed":
      case "started":
        accentColor = Colors.green;
        icon = Icons.chat_bubble_outline;
        break;
      case "cancelled":
        accentColor = Colors.red;
        icon = Icons.warning_amber_rounded;
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
          child: Icon(icon, color: accentColor),
        ),
        title: Text(
          item.title ?? "",
          style: theme.titleMedium?.copyWith(
            fontWeight: item.isRead == 1 ? .normal : .bold,
          ),
        ),
        subtitle: Text(
          item.message ?? "",
          style: theme.titleSmall?.copyWith(
            fontWeight: item.isRead == 1 ? .normal : .bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          timeago.format(DateTime.parse(item.createdAt!).toLocal()),
          style: theme.bodySmall?.copyWith(
            color: Colors.grey,
            fontWeight: item.isRead == 1 ? .normal : .bold,
          ),
        ),
        onTap: () async {
          await context.read<NotificationProvider>().markAsRead(
            notificationId: item.id!,
            index: index,
          );

          await _fetchData();
        },
      ),
    );
  }
}
