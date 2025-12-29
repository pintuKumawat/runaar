class BookingListModel {
  String? status;
  List<BookingList>? bookingList;

  BookingListModel({this.status, this.bookingList});

  BookingListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['booking_list'] != null) {
      bookingList = <BookingList>[];
      json['booking_list'].forEach((v) {
        bookingList!.add(new BookingList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.bookingList != null) {
      data['booking_list'] = this.bookingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingList {
  String? originTime;
  String? originCity;
  String? pricePerSeat;
  String? destinationTime;
  String? destinationCity;
  String? bookingStatus;
  int? bookingId;
  String? deptDate;
  String? driverName;
  int? driverRating;
  String? phoneNumber;
  String? profileImage;

  BookingList({
    this.originTime,
    this.originCity,
    this.pricePerSeat,
    this.destinationTime,
    this.destinationCity,
    this.bookingStatus,
    this.bookingId,
    this.deptDate,
    this.driverName,
    this.driverRating,
    this.phoneNumber,
    this.profileImage,
  });

  BookingList.fromJson(Map<String, dynamic> json) {
    originTime = json['origin_time'];
    originCity = json['origin_city'];
    pricePerSeat = json['price_per_seat'];
    destinationTime = json['destination_time'];
    destinationCity = json['destination_city'];
    bookingStatus = json['booking_status'];
    bookingId = json['booking_id'];
    deptDate = json['dept_date'];
    driverName = json['driver_name'];
    driverRating = json['driver_rating'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['origin_time'] = this.originTime;
    data['origin_city'] = this.originCity;
    data['price_per_seat'] = this.pricePerSeat;
    data['destination_time'] = this.destinationTime;
    data['destination_city'] = this.destinationCity;
    data['booking_status'] = this.bookingStatus;
    data['booking_id'] = this.bookingId;
    data['dept_date'] = this.deptDate;
    data['driver_name'] = this.driverName;
    data['driver_rating'] = this.driverRating;
    data['phone_number'] = this.phoneNumber;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
