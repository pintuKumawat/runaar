class VehicleDetailsModel {
  String? status;
  String? message;
  List<VehicleDetail>? vehicleDetail;

  VehicleDetailsModel({this.status, this.message, this.vehicleDetail});

  VehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['vehicleDetail'] != null) {
      vehicleDetail = <VehicleDetail>[];
      json['vehicleDetail'].forEach((v) {
        vehicleDetail!.add(new VehicleDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.vehicleDetail != null) {
      data['vehicleDetail'] =
          this.vehicleDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleDetail {
  int? id;
  int? userId;
  String? brand;
  String? model;
  String? vehicleNumber;
  String? vehicleType;
  String? fuelType;
  int? seats;
  String? color;
  String? vehicleImageUrl;
  String? rcImageUrl;
  String? createdAt;
  RtoJsonResponse? rtoJsonResponse;
  int? isActive;
  int? isVerified;

  VehicleDetail(
      {this.id,
      this.userId,
      this.brand,
      this.model,
      this.vehicleNumber,
      this.vehicleType,
      this.fuelType,
      this.seats,
      this.color,
      this.vehicleImageUrl,
      this.rcImageUrl,
      this.createdAt,
      this.rtoJsonResponse,
      this.isActive,
      this.isVerified});

  VehicleDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    brand = json['brand'];
    model = json['model'];
    vehicleNumber = json['vehicle_number'];
    vehicleType = json['vehicle_type'];
    fuelType = json['fuel_type'];
    seats = json['seats'];
    color = json['color'];
    vehicleImageUrl = json['vehicle_image_url'];
    rcImageUrl = json['rc_image_url'];
    createdAt = json['created_at'];
    rtoJsonResponse = json['rto_json_response'] != null
        ? new RtoJsonResponse.fromJson(json['rto_json_response'])
        : null;
    isActive = json['is_active'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['vehicle_number'] = this.vehicleNumber;
    data['vehicle_type'] = this.vehicleType;
    data['fuel_type'] = this.fuelType;
    data['seats'] = this.seats;
    data['color'] = this.color;
    data['vehicle_image_url'] = this.vehicleImageUrl;
    data['rc_image_url'] = this.rcImageUrl;
    data['created_at'] = this.createdAt;
    if (this.rtoJsonResponse != null) {
      data['rto_json_response'] = this.rtoJsonResponse!.toJson();
    }
    data['is_active'] = this.isActive;
    data['is_verified'] = this.isVerified;
    return data;
  }
}

class RtoJsonResponse {
  bool? valid;
  String? message;

  RtoJsonResponse({this.valid, this.message});

  RtoJsonResponse.fromJson(Map<String, dynamic> json) {
    valid = json['valid'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valid'] = this.valid;
    data['message'] = this.message;
    return data;
  }
}
