class BookingDetailModel {
  String? status;
  String? message;
  Detail? detail;

  BookingDetailModel({this.status, this.message, this.detail});

  BookingDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    detail = json['detail'] != null
        ? new Detail.fromJson(json['detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.detail != null) {
      data['detail'] = this.detail!.toJson();
    }
    return data;
  }
}

class Detail {
  int? bookingId;
  int? seatsBooked;
  String? totalAmount;
  String? paymentMethod;
  String? paymentStatus;
  String? bookingStatus;
  String? bookingDate;
  int? tripId;
  String? tripStatus;
  String? tripDate;
  String? deptTime;
  String? arrivalTime;
  String? pricePerSeat;
  String? originAddress;
  String? originCity;
  String? originLat;
  String? originLong;
  String? destinationAddress;
  String? destinationCity;
  String? destinationLat;
  String? destinationLong;
  int? driverId;
  String? driverName;
  String? driverPhone;
  int? driverRating;
  String? driverImage;
  int? driverIsVerified;
  String? vehicleModel;
  String? vehicleColor;
  String? carNumber;

  Detail({
    this.bookingId,
    this.seatsBooked,
    this.totalAmount,
    this.paymentMethod,
    this.paymentStatus,
    this.bookingStatus,
    this.bookingDate,
    this.tripId,
    this.tripStatus,
    this.tripDate,
    this.deptTime,
    this.arrivalTime,
    this.pricePerSeat,
    this.originAddress,
    this.originCity,
    this.originLat,
    this.originLong,
    this.destinationAddress,
    this.destinationCity,
    this.destinationLat,
    this.destinationLong,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverRating,
    this.driverImage,
    this.driverIsVerified,
    this.vehicleModel,
    this.vehicleColor,
    this.carNumber,
  });

  Detail.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    seatsBooked = json['seats_booked'];
    totalAmount = json['total_amount'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    bookingStatus = json['booking_status'];
    bookingDate = json['booking_date'];
    tripId = json['trip_id'];
    tripStatus = json['trip_status'];
    tripDate = json['trip_date'];
    deptTime = json['dept_time'];
    arrivalTime = json['arrival_time'];
    pricePerSeat = json['price_per_seat'];
    originAddress = json['origin_address'];
    originCity = json['origin_city'];
    originLat = json['origin_lat'];
    originLong = json['origin_long'];
    destinationAddress = json['destination_address'];
    destinationCity = json['destination_city'];
    destinationLat = json['destination_lat'];
    destinationLong = json['destination_long'];
    driverId = json['driver_id'];
    driverName = json['driver_name'];
    driverPhone = json['driver_phone'];
    driverRating = json['driver_rating'];
    driverImage = json['driver_image'];
    driverIsVerified = json['driver_is_verified'];
    vehicleModel = json['vehicle_model'];
    vehicleColor = json['vehicle_color'];
    carNumber = json['car_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['seats_booked'] = this.seatsBooked;
    data['total_amount'] = this.totalAmount;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['booking_status'] = this.bookingStatus;
    data['booking_date'] = this.bookingDate;
    data['trip_id'] = this.tripId;
    data['trip_status'] = this.tripStatus;
    data['trip_date'] = this.tripDate;
    data['dept_time'] = this.deptTime;
    data['arrival_time'] = this.arrivalTime;
    data['price_per_seat'] = this.pricePerSeat;
    data['origin_address'] = this.originAddress;
    data['origin_city'] = this.originCity;
    data['origin_lat'] = this.originLat;
    data['origin_long'] = this.originLong;
    data['destination_address'] = this.destinationAddress;
    data['destination_city'] = this.destinationCity;
    data['destination_lat'] = this.destinationLat;
    data['destination_long'] = this.destinationLong;
    data['driver_id'] = this.driverId;
    data['driver_name'] = this.driverName;
    data['driver_phone'] = this.driverPhone;
    data['driver_rating'] = this.driverRating;
    data['driver_image'] = this.driverImage;
    data['driver_is_verified'] = this.driverIsVerified;
    data['vehicle_model'] = this.vehicleModel;
    data['vehicle_color'] = this.vehicleColor;
    data['car_number'] = this.carNumber;
    return data;
  }
}
