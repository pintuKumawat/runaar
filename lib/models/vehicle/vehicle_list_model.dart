class VehicleListModel {
  String? status;
  String? message;
  List<Data>? data;

  VehicleListModel({this.status, this.message, this.data});

  VehicleListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? vehicleId;
  int? userId;
  String? vehicleBrand;
  String? vehicleNumber;
  String? vehicleImage;
  String? model;
  int? isVerified;
  int? isActive;

  Data({
    this.vehicleId,
    this.userId,
    this.vehicleBrand,
    this.vehicleNumber,
    this.vehicleImage,
    this.model,
    this.isVerified,
    this.isActive,
  });

  Data.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    userId = json['user_id'];
    vehicleBrand = json['vehicle_brand'];
    vehicleNumber = json['vehicle_number'];
    vehicleImage = json['vehicle_image'];
    model = json['model'];
    isVerified = json['is_verified'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['user_id'] = this.userId;
    data['vehicle_brand'] = this.vehicleBrand;
    data['vehicle_number'] = this.vehicleNumber;
    data['vehicle_image'] = this.vehicleImage;
    data['model'] = this.model;
    data['is_verified'] = this.isVerified;
    data['is_active'] = this.isActive;
    return data;
  }
}
