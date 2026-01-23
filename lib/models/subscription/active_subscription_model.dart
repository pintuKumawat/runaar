class ActiveSubscriptionModel {
  String? status;
  Message? message;

  ActiveSubscriptionModel({this.status, this.message});

  ActiveSubscriptionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  int? id;
  int? userId;
  int? subscriptionId;
  String? startDate;
  String? endDate;
  int? ridesUsed;
  int? totalRidesAllotted;
  int? isActive;
  String? paymentStatus;
  String? createdAt;
  String? updatedAt;
  String? subscriptionType;
  String? planTotalRides;
  int? amount;

  Message(
      {this.id,
      this.userId,
      this.subscriptionId,
      this.startDate,
      this.endDate,
      this.ridesUsed,
      this.totalRidesAllotted,
      this.isActive,
      this.paymentStatus,
      this.createdAt,
      this.updatedAt,
      this.subscriptionType,
      this.planTotalRides,
      this.amount});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    subscriptionId = json['subscription_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    ridesUsed = json['rides_used'];
    totalRidesAllotted = json['total_rides_allotted'];
    isActive = json['is_active'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subscriptionType = json['subscription_type'];
    planTotalRides = json['plan_total_rides'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['subscription_id'] = this.subscriptionId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['rides_used'] = this.ridesUsed;
    data['total_rides_allotted'] = this.totalRidesAllotted;
    data['is_active'] = this.isActive;
    data['payment_status'] = this.paymentStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['subscription_type'] = this.subscriptionType;
    data['plan_total_rides'] = this.planTotalRides;
    data['amount'] = this.amount;
    return data;
  }
}
