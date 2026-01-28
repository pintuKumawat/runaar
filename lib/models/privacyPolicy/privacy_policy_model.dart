class PrivacyPolicyModel {
  String? status;
  List<PrivacyPolicy>? privacyPolicy;

  PrivacyPolicyModel({this.status, this.privacyPolicy});

  PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['privacy_policy'] != null) {
      privacyPolicy = <PrivacyPolicy>[];
      json['privacy_policy'].forEach((v) {
        privacyPolicy!.add(new PrivacyPolicy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.privacyPolicy != null) {
      data['privacy_policy'] =
          this.privacyPolicy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrivacyPolicy {
  String? title;
  String? description;

  PrivacyPolicy({this.title, this.description});

  PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
