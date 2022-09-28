import 'package:app/src/models/app_state_model.dart';

import '../../models/checkout/order_result_model.dart';
import '../../models/checkout/order_review_model.dart';
import '../../models/payment/payment_verification_response.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import '../../resources/api_provider.dart';
import 'package:flutter/material.dart';
import '../../functions.dart';

class PayStackPaymentBloc {

  final apiProvider = ApiProvider();
  final plugin = PaystackPlugin();

  Future<PaymentVerificationResponse> processPayStack(BuildContext context, String email, OrderReviewModel orderReview, OrderResult orderResult) async {
    var orderId = getOrderIdFromUrl(orderResult.redirect!);
    var publicKey = orderReview.paymentMethods.singleWhere((method) => method.id == 'paystack').payStackPublicKey;
    await plugininitialize(publicKey);
    Charge charge = Charge()
      ..amount = num.parse(orderReview.totalsUnformatted.total).round() * 100
      ..reference = orderId
      ..currency = AppStateModel().blocks.currency
      ..email = email;
    CheckoutResponse checkoutResponse = await plugin.checkout(context, method: CheckoutMethod.card, charge: charge);
    if(checkoutResponse.status == true) {
      final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=dotapp_verify_payment', {'reference': orderId});
      PaymentVerificationResponse? paymentStatus;
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        paymentStatus = paymentVerificationResponseFromJson(response.body);
        return PaymentVerificationResponse(status: true, message: paymentStatus.message);
      } else {
        return PaymentVerificationResponse(status: false, message: checkoutResponse.message);
      }
    } else {
      return PaymentVerificationResponse(status: false, message: checkoutResponse.message);
    }
  }

  plugininitialize(String publicKey) async {
    await plugin.initialize(publicKey: publicKey);
    return true;
  }

}
