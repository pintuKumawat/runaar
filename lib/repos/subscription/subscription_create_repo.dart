import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/subscription/subscription_create_model.dart';

class SubscriptionCreateRepo {

   Future<SubscriptionCreateModel>subscriptionCreate({

   required int userId,
  required int subscriptionId,
  required int amount

  })async{

     Map<String, dynamic> body = {
     "user_id": userId,
  "subscription_id": subscriptionId,
  "amount": amount
     };

      return apiMethods.post(
      endpoint: "subscription_payment/create-order",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return SubscriptionCreateModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );

  }


}

SubscriptionCreateRepo subscriptionCreateRepo = SubscriptionCreateRepo();
