class PassengerPublishedListModel {
  String? status;
  List<Passengers>? passengers;

  PassengerPublishedListModel({this.status, this.passengers});

  PassengerPublishedListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['passengers'] != null) {
      passengers = <Passengers>[];
      json['passengers'].forEach((v) {
        passengers!.add(new Passengers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.passengers != null) {
      data['passengers'] = this.passengers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Passengers {
  int? seatsRequested;
  String? paymentStatus;
  int? userId;
  String? passengerName;
  String? profileImage;
  String? phoneNumber;
  double? rating;

  Passengers(
      {this.seatsRequested,
      this.paymentStatus,
      this.userId,
      this.passengerName,
      this.profileImage,
      this.phoneNumber,
      this.rating});

  Passengers.fromJson(Map<String, dynamic> json) {
    seatsRequested = json['seats_requested'];
    paymentStatus = json['payment_status'];
    userId = json['user_id'];
    passengerName = json['passenger_name'];
    profileImage = json['profile_image'];
    phoneNumber = json['phone_number'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seats_requested'] = this.seatsRequested;
    data['payment_status'] = this.paymentStatus;
    data['user_id'] = this.userId;
    data['passenger_name'] = this.passengerName;
    data['profile_image'] = this.profileImage;
    data['phone_number'] = this.phoneNumber;
    data['rating'] = this.rating;
    return data;
  }
}
