class RequestListModel {
  String? status;
  List<RequestList>? requestList;

  RequestListModel({this.status, this.requestList});

  RequestListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['request_list'] != null) {
      requestList = <RequestList>[];
      json['request_list'].forEach((v) {
        requestList!.add(new RequestList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.requestList != null) {
      data['request_list'] = this.requestList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequestList {
  String? originCity;
  String? arrivalTime;
  String? deptTime;
  String? destinationCity;
  String? pricePerSeat;
  String? name;
  String? phoneNumber;
  int? rating;
  String? profileImage;
  int? isActive;
  String? paymentMethod;
  int? seatsRequested;
  int? id;

  RequestList(
      {this.originCity,
      this.arrivalTime,
      this.deptTime,
      this.destinationCity,
      this.pricePerSeat,
      this.name,
      this.phoneNumber,
      this.rating,
      this.profileImage,
      this.isActive,
      this.paymentMethod,
      this.seatsRequested,
      this.id});

  RequestList.fromJson(Map<String, dynamic> json) {
    originCity = json['origin_city'];
    arrivalTime = json['arrival_time'];
    deptTime = json['dept_time'];
    destinationCity = json['destination_city'];
    pricePerSeat = json['price_per_seat'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    rating = json['rating'];
    profileImage = json['profile_image'];
    isActive = json['is_active'];
    paymentMethod = json['payment_method'];
    seatsRequested = json['seats_requested'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['origin_city'] = this.originCity;
    data['arrival_time'] = this.arrivalTime;
    data['dept_time'] = this.deptTime;
    data['destination_city'] = this.destinationCity;
    data['price_per_seat'] = this.pricePerSeat;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['rating'] = this.rating;
    data['profile_image'] = this.profileImage;
    data['is_active'] = this.isActive;
    data['payment_method'] = this.paymentMethod;
    data['seats_requested'] = this.seatsRequested;
    data['id'] = this.id;
    return data;
  }
}
