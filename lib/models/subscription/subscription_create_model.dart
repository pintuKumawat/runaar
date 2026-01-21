class SubscriptionCreateModel {
  String? status;
  String? orderId;

  SubscriptionCreateModel({this.status, this.orderId});

  SubscriptionCreateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['orderId'] = this.orderId;
    return data;
  }
}
