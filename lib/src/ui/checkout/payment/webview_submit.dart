import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../src/blocs/checkout_form_bloc.dart';
import '../../../../src/resources/api_provider.dart';

import '../../../config.dart';

class WebViewSubmit extends StatefulWidget {
  final CheckoutFormBloc checkoutBloc;

  const WebViewSubmit({Key? key, required this.checkoutBloc}) : super(key: key);
  @override
  _WebViewSubmitState createState() => _WebViewSubmitState();
}

class _WebViewSubmitState extends State<WebViewSubmit> {

  final config = Config();
  bool _isLoadingPage = true;

  //FlutterWebviewPlugin? flutterWebViewPlugin = FlutterWebviewPlugin();
  late StreamSubscription<String> _onUrlChanged;
  late StreamSubscription<double> _onProgressChanged;
  double progress = 0.0;
  final cookieManager = WebviewCookieManager();
  bool injectCookies = false;

  late  WebViewController _wvController;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
     /*flutterWebViewPlugin.close();
    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {

      }
    });
    _onProgressChanged = flutterWebViewPlugin.onProgressChanged.listen((double value) {
        if (mounted) {
          setState(() {
            progress = value;
          });
        }
      });*/
    _seCookies();

    super.initState();
    _seCookies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: injectCookies ? WebView(
        initialUrl: Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),
        onPageStarted: (String url) {

        },
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController wvc) {
          _wvController = wvc;
        },
        onPageFinished: (value) async {
          //_wvController.evaluateJavascript("document.getElementsByClassName('close')[0].style.display='none';");
          //_wvController.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none';");
          //_wvController.evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none';");
          setState(() {
            _isLoadingPage = false;
          });
        },
      ) : Container(),
    );
  }

  String _loadHTML() {

    widget.checkoutBloc.formData['shipping_first_name'] = widget.checkoutBloc.formData['billing_first_name']!;
    widget.checkoutBloc.formData['shipping_last_name'] = widget.checkoutBloc.formData['billing_last_name']!;
    widget.checkoutBloc.formData['shipping_address_1'] = widget.checkoutBloc.formData['billing_address_1']!;
    widget.checkoutBloc.formData['shipping_address_2'] = widget.checkoutBloc.formData['billing_address_2']!;
    widget.checkoutBloc.formData['shipping_city'] = widget.checkoutBloc.formData['billing_city']!;
    widget.checkoutBloc.formData['shipping_postcode'] = widget.checkoutBloc.formData['billing_postcode']!;
    widget.checkoutBloc.formData['shipping_country'] = widget.checkoutBloc.formData['billing_country']!;
    widget.checkoutBloc.formData['shipping_state'] = widget.checkoutBloc.formData['billing_state']!;

    /*if(appStateModel.oneSignalPlayerId != null)
      formData['onesignal_user_id'] = appStateModel.oneSignalPlayerId;
    if(appStateModel.fcmToken.isNotEmpty)
      formData['fcm_token'] = appStateModel.fcmToken;
*/
    if(widget.checkoutBloc.orderReviewData != null) {
      for (var i = 0; i < widget.checkoutBloc.orderReviewData!.shipping.length; i++) {
        if (widget.checkoutBloc.orderReviewData!.shipping[i].chosenMethod != '') {
          widget.checkoutBloc.formData['shipping_method[' + i.toString() + ']'] =
              widget.checkoutBloc.orderReviewData!.shipping[i].chosenMethod;
        }
      }
    }


    /** for WCFM Only **/
    /*if(appStateModel.customerLocation['latitude'] != null && appStateModel.customerLocation['longitude'] != null && appStateModel.customerLocation['address'] != null) {
      formData['wcfmmp_user_location_lat'] = appStateModel.customerLocation['latitude'];
      formData['wcfmmp_user_location_lng'] = appStateModel.customerLocation['longitude'];
      formData['wcfmmp_user_location'] = appStateModel.customerLocation['address'];
    }

    if(appStateModel.selectedDate != null && appStateModel.selectedTime != null) {
      formData['jckwds-delivery-date'] = appStateModel.selectedDateFormatted;
      formData['jckwds-delivery-date-ymd'] = appStateModel.selectedDate;
      formData['jckwds-delivery-time'] = appStateModel.selectedTime;
    }*/

    var url = config.url + '/?wc-ajax=checkout';

    var html;
    html = '<html><body onload="document.f.submit();"><form id="f" name="f" method="post" action="$url">';

    var htmlEnd = '</form></body></html>';

    widget.checkoutBloc.formData.forEach((key, value) {
      html = html + '<input type="hidden" name="$key" value="$value" />';
    });

    return html + htmlEnd;
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
