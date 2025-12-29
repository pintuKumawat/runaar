class RideSearchModel {
  String? status;
  String? message;
  List<AvailableRide>? availableRide;

  RideSearchModel({this.status, this.message, this.availableRide});

  RideSearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['available_ride'] != null) {
      availableRide = <AvailableRide>[];
      json['available_ride'].forEach((v) {
        availableRide!.add(new AvailableRide.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.availableRide != null) {
      data['available_ride'] = this.availableRide!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class AvailableRide {
  int? tripId;
  String? originTime;
  String? originCity;
  String? seatPrice;
  String? destinationTime;
  String? destinationCity;
  String? distanceFromSearch;
  String? deptDate;
  String? personName;
  String? personImage;
  int? personRatings;
  String? personPhoneNumber;
  int? isVerified;

  AvailableRide({
    this.tripId,
    this.originTime,
    this.originCity,
    this.seatPrice,
    this.destinationTime,
    this.destinationCity,
    this.distanceFromSearch,
    this.deptDate,
    this.personName,
    this.personImage,
    this.personRatings,
    this.personPhoneNumber,
    this.isVerified,
  });

  AvailableRide.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    originTime = json['origin_time'];
    originCity = json['origin_city'];
    seatPrice = json['seat_price'];
    destinationTime = json['destination_time'];
    destinationCity = json['destination_city'];
    distanceFromSearch = json['distance_from_search'];
    deptDate = json['dept_date'];
    personName = json['person_name'];
    personImage = json['person_image'];
    personRatings = json['person_ratings'];
    personPhoneNumber = json['person_phone_number'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['origin_time'] = this.originTime;
    data['origin_city'] = this.originCity;
    data['seat_price'] = this.seatPrice;
    data['destination_time'] = this.destinationTime;
    data['destination_city'] = this.destinationCity;
    data['distance_from_search'] = this.distanceFromSearch;
    data['dept_date'] = this.deptDate;
    data['person_name'] = this.personName;
    data['person_image'] = this.personImage;
    data['person_ratings'] = this.personRatings;
    data['person_phone_number'] = this.personPhoneNumber;
    data['is_verified'] = this.isVerified;
    return data;
  }
}
