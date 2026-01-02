class UserDetailsModel {
  String? status;
  UserDetail? userDetail;

  UserDetailsModel({this.status, this.userDetail});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userDetail = json['user_detail'] != null
        ? new UserDetail.fromJson(json['user_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.userDetail != null) {
      data['user_detail'] = this.userDetail!.toJson();
    }
    return data;
  }
}

class UserDetail {
  int? userId;
  String? name;
  String? email;
  String? phoneNumber;
  String? profileImage;
  String? dob;
  String? gender;
String? licenceImage;
  String? documentType;
  String? documentImage;
  int? isActive;
  int? isLicenceVerified;
  int? isDocumentVerified;
  int? isNumberVerified;
  int? isEmailVerified;
  String? referBy;
  String? referCode;
  int? rating;

  UserDetail(
      {this.userId,
      this.name,
      this.email,
      this.phoneNumber,
      this.profileImage,
      this.dob,
      this.gender,
      this.licenceImage,
      this.documentType,
      this.documentImage,
      this.isActive,
      this.isLicenceVerified,
      this.isDocumentVerified,
      this.isNumberVerified,
      this.isEmailVerified,
      this.referBy,
      this.referCode,
      this.rating});

  UserDetail.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
    dob = json['dob'];
    gender = json['gender'];
    licenceImage = json['licence_image'];
    documentType = json['document_type'];
    documentImage = json['document_image'];
    isActive = json['is_active'];
    isLicenceVerified = json['is_licence_verified'];
    isDocumentVerified = json['is_document_verified'];
    isNumberVerified = json['is_number_verified'];
    isEmailVerified = json['is_email_verified'];
    referBy = json['refer_by'];
    referCode = json['refer_code'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['profile_image'] = this.profileImage;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['licence_image'] = this.licenceImage;
    data['document_type'] = this.documentType;
    data['document_image'] = this.documentImage;
    data['is_active'] = this.isActive;
    data['is_licence_verified'] = this.isLicenceVerified;
    data['is_document_verified'] = this.isDocumentVerified;
    data['is_number_verified'] = this.isNumberVerified;
    data['is_email_verified'] = this.isEmailVerified;
    data['refer_by'] = this.referBy;
    data['refer_code'] = this.referCode;
    data['rating'] = this.rating;
    return data;
  }
}
