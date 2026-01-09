class LoginModel {
  String? status;
  String? message;
  int? userId;
  String? userEmail;
  String? userPhoneNo;

  LoginModel({
    this.status,
    this.message,
    this.userId,
    this.userEmail,
    this.userPhoneNo,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['userId'];
    userEmail = json['userEmail'];
    userPhoneNo = json['userPhoneNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['userId'] = this.userId;
    data['userEmail'] = this.userEmail;
    data['userPhoneNo'] = this.userPhoneNo;
    return data;
  }
}
