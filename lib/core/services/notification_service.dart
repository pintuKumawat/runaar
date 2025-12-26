import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'runaar_channel',
        'Runaar Notifications',
        description: 'Notification channel for Runaar App',
        importance: Importance.max,
        playSound: true,
        showBadge: true,
      );

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    debugPrint("🔔 Initializing Notification Service...");

    // Ask permission
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    const androidInit = AndroidInitializationSettings("@mipmap/ic_launcher");
    const initSettings = InitializationSettings(android: androidInit);

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationClick(response.payload);
      },
    );

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    final initial = await _fcm.getInitialMessage();
    if (initial != null) _onMessageOpenedApp(initial);

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint("🔄 FCM Token Refreshed: $newToken");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(savedData.fcmToken, newToken);

      // final userId = prefs.getInt(savedData.userId);

      // if (userId != null) {
      //   debugPrint("📡 Sending updated token to backend...");
      //   sendFcmRepo.updateToken(userId.toString(), newToken);
      // }
    });

    debugPrint("✅ Notification Service Ready");
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint("📩 Foreground Notification: ${message.notification?.title}");

    final title = message.notification?.title ?? "New Notification";
    final body = message.notification?.body ?? "";
    final payload = jsonEncode(message.data);

    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint("➡️ Notification Clicked (Opened App)");
    handleDeepLink(message.data);
  }

  void _handleNotificationClick(String? payload) {
    debugPrint("🎯 Local Click Payload: $payload");
    if (payload == null || payload.isEmpty) return;

    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      handleDeepLink(data);
    } catch (e) {
      debugPrint("❌ Error decoding payload: $e");
    }
  }

  void handleDeepLink(Map<String, dynamic> data) {
    debugPrint("🔗 DeepLink Received: $data");

    final type = data["screen"] ?? data["type"];

    switch (type) {
      //   case "product":
      //     final id = int.tryParse(data["product_id"]?.toString() ?? "");
      //     if (id != null) {
      //       appNavigator.push(AdminDetailProduct(productId: id));
      //     }
      //     break;

      //   case "Admin_Order_Detail":
      //     final orderId = int.tryParse(data["orderId"]?.toString() ?? "");
      //     if (orderId != null) {
      //       appNavigator.push(AdminOrderDetails(orderId: orderId));
      //     }
      //     break;

      //   case "User_Order_Detail":
      //     final orderId = int.tryParse(data["orderId"]?.toString() ?? "");
      //     if (orderId != null) {
      //       appNavigator.push(UserOrderDetailScreen(orderId: orderId));
      //     }
      //     break;

      //   default:
      //     debugPrint("⚠ Unknown deeplink type: $type");
    }
  }
}

final NotificationService notificationService = NotificationService();
