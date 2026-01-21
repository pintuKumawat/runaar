import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/notification/get_notification_model.dart';
import 'package:runaar/repos/notification/get_notification_repo.dart';
import 'package:runaar/repos/notification/read_all_notification_repo.dart';
import 'package:runaar/repos/notification/read_notification_repo.dart';

class NotificationProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoding = false;
  GetNotificationModel? _response;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoding;
  GetNotificationModel? get response => _response;

  int _count = 0;
  int get count => _count;

  Future<void> getNotification({required int userId}) async {
    _isLoding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getNotificationRepo.getNotification(userId: userId);
      _response = result;
      _count =
          _response?.notifications
              ?.where((e) => e.isRead == 0 || e.isRead == null)
              .length ??
          0;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      debugPrint("API Exception: $_errorMessage");
    } catch (e) {
      _errorMessage = "Unexpected error :${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    } finally {
      _isLoding = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead({
    required int notificationId,
    required int index,
  }) async {
    try {
      await readNotificationRepo.readNotification(
        notificationId: notificationId,
      );

      final item = _response?.notifications?[index];
      if (item != null && item.isRead == 0) {
        item.isRead = 1;
        _count = (_count - 1).clamp(0, _count);
        notifyListeners();
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
      debugPrint("API Exception: $_errorMessage");
    } catch (e) {
      _errorMessage = "Unexpected error :${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    }
  }

  Future<void> markAllAsRead({required int userId}) async {
    try {
      await readAllNotificationRepo.readNotification(userId: userId);

      final list = _response?.notifications;
      if (list == null) return;

      for (final n in list) {
        n.isRead = 1;
      }

      _count = 0;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      debugPrint("API Exception: $_errorMessage");
    } catch (e) {
      _errorMessage = "Unexpected error :${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    }
  }
}
