/*
import 'dart:async';
import 'dart:io';
import 'package:app/src/models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' hide Cookie;
import '../../config.dart';
import '../../functions.dart';
import '../../resources/api_provider.dart';
import 'order_summary.dart';

class InAppWebViewPayment extends StatefulWidget {
  final String url;
  final String selectedPaymentMethod;

  const InAppWebViewPayment({Key? key, required this.url, required this.selectedPaymentMethod}) : super(key: key);

  @override
  _InAppWebViewPaymentState createState() => _InAppWebViewPaymentState();
}

class _InAppWebViewPaymentState extends State<InAppWebViewPayment> {
  final apiProvider = ApiProvider();
  final config = Config();
  bool _isLoadingPage = true;
  String? orderId;
  String? orderKey;
  late InAppWebViewController controller;
  late String redirectUrl;
  final cookieManager = WebviewCookieManager();
  bool injectCookies = false;
  String url = "";
  final urlController = TextEditingController();

  late InAppWebViewController _wvController;
  final Completer<InAppWebViewController> _controller =
  Completer<InAppWebViewController>();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
      ));

  @override
  void initState() {
    super.initState();

    orderId = getOrderIdFromUrl(widget.url);
    if (widget.url.lastIndexOf("/?key=") != -1) {
      var pos1 = widget.url.lastIndexOf("/?key=wc_order");
      var pos2 = widget.url.length;
      orderKey = widget.url.substring(pos1 + 6, pos2);
    }
    if (widget.selectedPaymentMethod == 'woo_mpgs' && widget.url.lastIndexOf("sessionId=") != -1 &&
        widget.url.lastIndexOf("&order=") != -1) {
      var pos1 = widget.url.lastIndexOf("sessionId=");
      var pos2 = widget.url.lastIndexOf("&order=");
      String sessionId = widget.url.substring(pos1 + 10, pos2);
      redirectUrl = 'https://credimax.gateway.mastercard.com/checkout/pay/' + sessionId;
    } else if(widget.selectedPaymentMethod == 'paypal' || widget.selectedPaymentMethod == 'wc-upi' || widget.selectedPaymentMethod == 'wpl_paylabs_paytm') {
      redirectUrl = widget.url;
    } else if(widget.selectedPaymentMethod == 'paytmpay' && orderKey != null && orderId != null) {
      redirectUrl = this.config.url + '/index.php' + '/checkout/order-pay/' + orderId! + '/?key=' + orderKey!;
    } else if(widget.selectedPaymentMethod == 'eh_stripe_checkout' && orderKey != null && orderId != null) {
      redirectUrl = this.config.url + '/checkout/order-pay/' + orderId! + '/?key=' + orderKey!;
    } else if(orderKey != null) {
      redirectUrl = widget.url;
      //redirectUrl = this.config.url + '/checkout/order-pay/' + orderId + '/?key=' + orderKey;
    } else {
      redirectUrl = widget.url;
    }
    _seCookies();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStateModel().blocks.localeText.payment)),
      body: Container(
        child: Stack(
          children: <Widget>[
            injectCookies ? InAppWebView(
              initialOptions: options,
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
                onUrlChange(url.toString());
              },
              initialUrlRequest: URLRequest(url: Uri.parse(redirectUrl)),
              //initialUrl: redirectUrl,
              //javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _wvController = controller;
              },
              onLoadStop: (controller, url) async {
                onPageFinished(url.toString());
                //_wvController.evaluateJavascript("document.getElementsByClassName('close')[0].style.display='none';");
                //_wvController.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none';");
                //_wvController.evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none';");
                setState(() {
                  _isLoadingPage = false;
                });
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;
                print("scheme: "+uri.scheme);
                if(uri.scheme.startsWith("upi:") || uri.scheme.startsWith("kbzpay:")) {
                  launchUrl(Uri.parse(url));
                  return NavigationActionPolicy.CANCEL;
                } else if(uri.scheme.startsWith("intent:")) {
                  launchUrl(Uri.parse(url));
                  return NavigationActionPolicy.CANCEL;
                } else if(![ "http", "https", "file", "chrome",
                  "data", "javascript", "about"].contains(uri.scheme)) {
                  launchUrl(Uri.parse(url));
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
            ) : Container(),
            _isLoadingPage
                ? Container(
                    color: Colors.white,
                    alignment: FractionalOffset.center,
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future onUrlChange(String newUrl) async {
    if (newUrl.contains('/order-received/') &&
        newUrl.contains('key=wc_order_') &&
        orderId != null && widget.selectedPaymentMethod != 'wc-upi') {
      orderSummaryById();
    } else if(newUrl.contains('/?wc-api=upiwc-payment') || newUrl.contains('/?wc-api=razorpay') || newUrl.contains('wc-api=WC_Gateway_paytmpay') || newUrl.contains('wc-api=WC_Gateway_cashfree&act=ret')) {
      await Future.delayed(Duration(seconds: 5));
      orderSummaryById();
    } else if (newUrl.contains('/order-received/') && widget.selectedPaymentMethod == 'wc-upi') {
      orderSummary(newUrl);
    } if (newUrl.contains('/order-received/') &&
        newUrl.contains('key=wc_order_') &&
        orderId == null && widget.selectedPaymentMethod != 'wc-upi') {
      orderSummary(newUrl);
    }

    else if(newUrl.contains('payment-response?order_id=')) {
      orderSummaryById();
    }

    if (newUrl.contains('cancel_order=') ||
        newUrl.contains('failed') ||
        newUrl.contains('type=error') ||
        newUrl.contains('cancelled=1') ||
        newUrl.contains('cancelled') ||
        newUrl.contains('cancel_order=true') ||
        newUrl.contains('/wc-api/wpl_paylabs_wc_paytm/') ||
        newUrl.contains('/shop/') ||
        newUrl.contains('/details.html')) {
        Navigator.of(context).pop();
    }

    if (newUrl.contains('?errors=true')) {
     // Navigator.of(context).pop();
    }

    // Start of PayUIndia Payment
    if (newUrl.contains('payumoney.com/transact')) {
      // Show WebView
    }

    // End of PayUIndia Payment

    // Start of PAYTM Payment
    if (newUrl.contains('securegw-stage.paytm.in/theia')) {
      //Show WebView
    }

    if (newUrl.contains('type=success') && orderId != null) {
      orderSummaryById();
    }

  }

  Future onPageFinished(String newUrl) async {
    if (newUrl.contains('/order-received/') &&
        newUrl.contains('key=wc_order_') &&
        orderId != null && widget.selectedPaymentMethod != 'wc-upi') {
      orderSummaryById();
    } else if(newUrl.contains('/?wc-api=upiwc-payment') || newUrl.contains('/?wc-api=razorpay') || newUrl.contains('wc-api=WC_Gateway_paytmpay') || newUrl.contains('wc-api=WC_Gateway_cashfree&act=ret')) {
      await Future.delayed(Duration(seconds: 5));
      orderSummaryById();
    } else if (newUrl.contains('/order-received/') && widget.selectedPaymentMethod == 'wc-upi') {
      orderSummary(newUrl);
    } if (newUrl.contains('/order-received/') &&
        newUrl.contains('key=wc_order_') &&
        orderId == null && widget.selectedPaymentMethod != 'wc-upi') {
      orderSummary(newUrl);
    }

    else if(newUrl.contains('payment-response?order_id=')) {
      orderSummaryById();
    }

    if (newUrl.contains('cancel_order=') ||
        newUrl.contains('failed') ||
        newUrl.contains('type=error') ||
        newUrl.contains('cancelled=1') ||
        newUrl.contains('cancelled') ||
        newUrl.contains('cancel_order=true') ||
        newUrl.contains('/wc-api/wpl_paylabs_wc_paytm/') ||
        newUrl.contains('/shop/') ||
        newUrl.contains('/details.html')) {
      Navigator.of(context).pop();
    }

    if (newUrl.contains('?errors=true')) {
      // Navigator.of(context).pop();
    }

    // Start of PayUIndia Payment
    if (newUrl.contains('payumoney.com/transact')) {
      // Show WebView
    }

    // End of PayUIndia Payment

    // Start of PAYTM Payment
    if (newUrl.contains('securegw-stage.paytm.in/theia')) {
      //Show WebView
    }

    if (newUrl.contains('type=success') && orderId != null) {
      orderSummaryById();
    }

  }

  void orderSummary(String url) {
    orderId = getOrderIdFromUrl(url);
    if(orderId != null)
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderSummary(
                id: orderId!,
            )));
  }

  void orderSummaryById() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderSummary(
              id: orderId!,
            )));
  }

  _seCookies() async {
    Uri uri = Uri.parse(config.url);
    String domain = uri.host;
    ApiProvider apiProvider = ApiProvider();
    List<Cookie> cookies = apiProvider.generateCookies();
    apiProvider.cookieList.forEach((element) async {
      await cookieManager.setCookies([
        Cookie(element.name, element.value)
          ..domain = domain
        //..expires = DateTime.now().add(Duration(days: 10))
        //..httpOnly = true
      ]);
    });
    setState(() {
      injectCookies = true;
    });
  }
}
*/
