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
  int? ridesUsed;
  String? startDate;
  String? endDate;
  int? totalRidesAllotted;
  String? paymentStatus;
  int? isActive;
  String? subscriptionType;
  String? totalRides;
  int? amount;
  int? duration;

  Message(
      {this.id,
      this.ridesUsed,
      this.startDate,
      this.endDate,
      this.totalRidesAllotted,
      this.paymentStatus,
      this.isActive,
      this.subscriptionType,
      this.totalRides,
      this.amount,
      this.duration});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ridesUsed = json['rides_used'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalRidesAllotted = json['total_rides_allotted'];
    paymentStatus = json['payment_status'];
    isActive = json['is_active'];
    subscriptionType = json['subscription_type'];
    totalRides = json['total_rides'];
    amount = json['amount'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rides_used'] = this.ridesUsed;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_rides_allotted'] = this.totalRidesAllotted;
    data['payment_status'] = this.paymentStatus;
    data['is_active'] = this.isActive;
    data['subscription_type'] = this.subscriptionType;
    data['total_rides'] = this.totalRides;
    data['amount'] = this.amount;
    data['duration'] = this.duration;
    return data;
  }
}
