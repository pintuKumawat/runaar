class PublishedDetailModel {
  String? status;
  String? message;
  Trip? trip;

  PublishedDetailModel({this.status, this.message, this.trip});

  PublishedDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    trip = json['trip'] != null ? new Trip.fromJson(json['trip']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.trip != null) {
      data['trip'] = this.trip!.toJson();
    }
    return data;
  }
}

class Trip {
  int? tripId;
  String? tripDate;
  String? originTime;
  String? originCity;
  String? originAddress;
  String? destinationTime;
  String? destinationAddress;
  String? destinationCity;
  String? distanceFromSearch;
  String? deptDate;
  String? seatPrice;
  int? availableSeats;
  String? tripStatus;
  String? personName;
  String? personImage;
  int? personRatings;
  String? personPhoneNumber;
  String? personEmail;
  int? isVerified;
  String? vehicleNumber;
  String? vehicleModel;
  String? vehicleColor;

  Trip(
      {this.tripId,
      this.tripDate,
      this.originTime,
      this.originCity,
      this.originAddress,
      this.destinationTime,
      this.destinationAddress,
      this.destinationCity,
      this.distanceFromSearch,
      this.deptDate,
      this.seatPrice,
      this.availableSeats,
      this.tripStatus,
      this.personName,
      this.personImage,
      this.personRatings,
      this.personPhoneNumber,
      this.personEmail,
      this.isVerified,
      this.vehicleNumber,
      this.vehicleModel,
      this.vehicleColor});

  Trip.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    tripDate = json['trip_date'];
    originTime = json['origin_time'];
    originCity = json['origin_city'];
    originAddress = json['origin_address'];
    destinationTime = json['destination_time'];
    destinationAddress = json['destination_address'];
    destinationCity = json['destination_city'];
    distanceFromSearch = json['distance_from_search'];
    deptDate = json['dept_date'];
    seatPrice = json['seat_price'];
    availableSeats = json['available_seats'];
    tripStatus = json['trip_status'];
    personName = json['person_name'];
    personImage = json['person_image'];
    personRatings = json['person_ratings'];
    personPhoneNumber = json['person_phone_number'];
    personEmail = json['person_email'];
    isVerified = json['is_verified'];
    vehicleNumber = json['vehicle_number'];
    vehicleModel = json['vehicle_model'];
    vehicleColor = json['vehicle_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['trip_date'] = this.tripDate;
    data['origin_time'] = this.originTime;
    data['origin_city'] = this.originCity;
    data['origin_address'] = this.originAddress;
    data['destination_time'] = this.destinationTime;
    data['destination_address'] = this.destinationAddress;
    data['destination_city'] = this.destinationCity;
    data['distance_from_search'] = this.distanceFromSearch;
    data['dept_date'] = this.deptDate;
    data['seat_price'] = this.seatPrice;
    data['available_seats'] = this.availableSeats;
    data['trip_status'] = this.tripStatus;
    data['person_name'] = this.personName;
    data['person_image'] = this.personImage;
    data['person_ratings'] = this.personRatings;
    data['person_phone_number'] = this.personPhoneNumber;
    data['person_email'] = this.personEmail;
    data['is_verified'] = this.isVerified;
    data['vehicle_number'] = this.vehicleNumber;
    data['vehicle_model'] = this.vehicleModel;
    data['vehicle_color'] = this.vehicleColor;
    return data;
  }
}
