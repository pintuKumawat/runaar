class ReadlAllNotificationModel {
  String? status;
  String? message;

  ReadlAllNotificationModel({this.status, this.message});

  ReadlAllNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
