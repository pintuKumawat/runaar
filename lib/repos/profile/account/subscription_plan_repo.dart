
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/profile/account/subscription_plan_model.dart';

class SubscriptionPlanRepo {
  Future<SubscriptionPlanModel> getSubscriptions() async {
    return apiMethods.get(
      endpoint: "subscription/all_subscriptions",
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return SubscriptionPlanModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

SubscriptionPlanRepo subscriptionRepo = SubscriptionPlanRepo();
