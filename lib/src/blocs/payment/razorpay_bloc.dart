import 'package:app/src/blocs/checkout_form_bloc.dart';
import 'package:app/src/models/checkout/order_review_model.dart';
import 'package:app/src/resources/api_provider.dart';
import 'package:app/src/ui/checkout/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPaymentBloc {

  late Razorpay _razorpay;
  final apiProvider = ApiProvider();

  RazorPayPaymentBloc() {
    _razorpay = Razorpay();
  }

  void openCheckout(String orderId, OrderReviewModel orderReviewModel, CheckoutFormBloc checkoutFormBloc) async {



    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 2000,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      //debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    //redirect URL
    //https://apps.buildapp.online/woocommerce/checkout/order-pay/3609/?key=wc_order_JcgqzUyfQR84e
    //https://apps.buildapp.online/woocommerce/?wc-api=razorpay
    var data = new Map<String, dynamic>();
    data['razorpay_payment_id'] = response.paymentId;
    data['razorpay_signature'] = response.signature;
    data['razorpay_wc_form_submit'] = '1';
    apiProvider.postWithCookies('/?wc-api=razorpay', data);


    //Redirect to Order Success Page
    //Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("response" + response.code.toString());
    //Fluttertoast.showToast(msg: "ERROR: " + response.code.toString() + " - " + response.message, timeInSecForIos: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    //print("response" + response.toString());
    //Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }

}
