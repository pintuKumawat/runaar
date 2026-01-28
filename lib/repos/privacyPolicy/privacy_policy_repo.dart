import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/privacyPolicy/privacy_policy_model.dart';

class PrivacyPolicyRepo {
 Future<PrivacyPolicyModel> privacyPolicy() async {
    return apiMethods.get(
      endpoint: "privacy_policy",
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return PrivacyPolicyModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }

} PrivacyPolicyRepo privacyPolicyRepo=PrivacyPolicyRepo();