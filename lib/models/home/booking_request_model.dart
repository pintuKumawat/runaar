class BookingRequestModel {
  int? tripId;
  int? userId;
  int? seatsRequested;
  int? totalPrice;
  String? paymentMethod;
  String? paymentStatus;
  String? specialMessage;

  BookingRequestModel(
      {this.tripId,
      this.userId,
      this.seatsRequested,
      this.totalPrice,
      this.paymentMethod,
      this.paymentStatus,
      this.specialMessage});

  BookingRequestModel.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    userId = json['user_id'];
    seatsRequested = json['seats_requested'];
    totalPrice = json['total_price'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    specialMessage = json['special_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['user_id'] = this.userId;
    data['seats_requested'] = this.seatsRequested;
    data['total_price'] = this.totalPrice;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['special_message'] = this.specialMessage;
    return data;
  }
}
