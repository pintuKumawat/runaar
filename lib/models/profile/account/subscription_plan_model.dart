class SubscriptionPlanModel {
  String? status;
  List<Data>? data;

  SubscriptionPlanModel({this.status, this.data});

  SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? subscriptionId;
  String? subscriptionType;
  String? subscriptionDescription;
  int? duration;
  String? amount;
  String? totalRides;

  Data(
      {this.subscriptionId,
      this.subscriptionType,
      this.subscriptionDescription,
      this.duration,
      this.amount,
      this.totalRides});

  Data.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscription_id'];
    subscriptionType = json['subscription_type'];
    subscriptionDescription = json['subscription_description'];
    duration = json['duration'];
    amount = json['amount'];
    totalRides = json['total_rides'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscription_id'] = this.subscriptionId;
    data['subscription_type'] = this.subscriptionType;
    data['subscription_description'] = this.subscriptionDescription;
    data['duration'] = this.duration;
    data['amount'] = this.amount;
    data['total_rides'] = this.totalRides;
    return data;
  }
}
