import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/subscription/active_subscription_model.dart';

class ActiveSubscriptionRepo {

  Future<ActiveSubscriptionModel>activeSubscription({required int userId})async{

    Map<String, dynamic> body = {
      "user_id": userId,
      
    };

    return apiMethods.post(
      endpoint: "subscription_payment/create-order",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return ActiveSubscriptionModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );

  }


  


}ActiveSubscriptionRepo activeSubscriptionRepo= ActiveSubscriptionRepo();
