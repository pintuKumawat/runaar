class PublishedListModel {
  String? status;
  String? message;
  List<PublishedRide>? publishedRide;

  PublishedListModel({this.status, this.message, this.publishedRide});

  PublishedListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['published_ride'] != null) {
      publishedRide = <PublishedRide>[];
      json['published_ride'].forEach((v) {
        publishedRide!.add(new PublishedRide.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.publishedRide != null) {
      data['published_ride'] =
          this.publishedRide!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PublishedRide {
  int? tripId;
  String? originCity;
  String? seatPrice;
  String? arrivalTime;
  String? deptTime;
  String? createdAt;
  String? tripStatus;
  String? destinationCity;
  String? distanceFromSearch;
  String? deptDate;

  PublishedRide(
      {this.tripId,
      this.originCity,
      this.seatPrice,
      this.arrivalTime,
      this.deptTime,
      this.createdAt,
      this.tripStatus,
      this.destinationCity,
      this.distanceFromSearch,
      this.deptDate});

  PublishedRide.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    originCity = json['origin_city'];
    seatPrice = json['seat_price'];
    arrivalTime = json['arrival_time'];
    deptTime = json['dept_time'];
    createdAt = json['created_at'];
    tripStatus = json['trip_status'];
    destinationCity = json['destination_city'];
    distanceFromSearch = json['distance_from_search'];
    deptDate = json['dept_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['origin_city'] = this.originCity;
    data['seat_price'] = this.seatPrice;
    data['arrival_time'] = this.arrivalTime;
    data['dept_time'] = this.deptTime;
    data['created_at'] = this.createdAt;
    data['trip_status'] = this.tripStatus;
    data['destination_city'] = this.destinationCity;
    data['distance_from_search'] = this.distanceFromSearch;
    data['dept_date'] = this.deptDate;
    return data;
  }
}
