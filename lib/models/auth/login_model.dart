class LoginModel {
  String? status;
  String? message;
  int? userId;

  LoginModel({this.status, this.message, this.userId});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['userId'] = this.userId;
    return data;
  }
}
