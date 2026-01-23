class ActiveSubscriptionModel {
  String? status;
  Message? message;

  ActiveSubscriptionModel({this.status, this.message});

  ActiveSubscriptionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  int? ridesUsed;
  String? startDate;
  String? endDate;
  String? subscriptionType;
  String? totalRides;
  int? amount;
  int? duration;

  Message(
      {this.ridesUsed,
      this.startDate,
      this.endDate,
      this.subscriptionType,
      this.totalRides,
      this.amount,
      this.duration});

  Message.fromJson(Map<String, dynamic> json) {
    ridesUsed = json['rides_used'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    subscriptionType = json['subscription_type'];
    totalRides = json['total_rides'];
    amount = json['amount'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rides_used'] = ridesUsed;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['subscription_type'] = subscriptionType;
    data['total_rides'] = totalRides;
    data['amount'] = amount;
    data['duration'] = duration;
    return data;
  }
}
