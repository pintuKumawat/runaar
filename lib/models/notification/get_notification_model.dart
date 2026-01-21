class GetNotificationModel {
  String? status;
  List<Notifications>? notifications;

  GetNotificationModel({this.status, this.notifications});

  GetNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (notifications != null) {
      data['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  int? id;
  int? userId;
  String? type;
  String? title;
  String? message;
  String? data;
  int? isRead;
  String? createdAt;

  Notifications(
      {this.id,
      this.userId,
      this.type,
      this.title,
      this.message,
      this.data,
      this.isRead,
      this.createdAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    title = json['title'];
    message = json['message'];
    data = json['data'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['message'] = this.message;
    data['data'] = this.data;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    return data;
  }
}
