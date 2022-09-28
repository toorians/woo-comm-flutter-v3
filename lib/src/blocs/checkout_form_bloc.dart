import 'dart:convert';
import 'package:app/src/models/checkout/paymongo_card.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import '../models/checkout_data_model.dart';
import '../config.dart';
import '../models/app_state_model.dart';
import '../models/checkout/order_result_model.dart';
import '../models/checkout/order_review_model.dart';
import '../models/checkout/stripeSource.dart';
import '../models/checkout/stripe_token.dart';
import '../models/customer_model.dart';
import '../models/errors/error.dart';
import '../models/errors/register_error.dart';
import '../models/orders_model.dart';
import '../models/product_model.dart';
import '../resources/api_provider.dart';

class CheckoutFormBloc {
  var formData = new Map<String, dynamic>();
  OrderReviewModel? orderReviewData;

  Config config = Config();
  final apiProvider = ApiProvider();
  final appStateModel = AppStateModel();

  final _checkoutFormFetcher = BehaviorSubject<CheckoutFormData>();
  final _orderReviewFetcher = BehaviorSubject<OrderReviewModel>();
  final _orderResultFetcher = BehaviorSubject<OrderResult>();
  final _searchFetcher = BehaviorSubject<List<Product>>();
  final _isLoadingFetcher = BehaviorSubject<String>();
  final _placingOrderFetcher = BehaviorSubject<bool>();

  String selectedCountry = 'US';
  CheckoutFormData? checkoutFormData;

  ValueStream<CheckoutFormData> get checkoutForm => _checkoutFormFetcher.stream;
  ValueStream<OrderReviewModel> get orderReview => _orderReviewFetcher.stream;
  ValueStream<OrderResult> get orderResult => _orderResultFetcher.stream;
  ValueStream<List<Product>> get searchResults => _searchFetcher.stream;
  ValueStream<String> get isLoading => _isLoadingFetcher.stream;
  ValueStream<bool> get placingOrder => _placingOrderFetcher.stream;

  void getCheckoutForm() async {

    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-checkout_form', Map()); //formData.toJson();
    if (response.statusCode == 200) {

      checkoutFormData = checkoutDataFromJson(response.body);

      if(checkoutFormData != null && checkoutFormData!.fieldgroups.billing.any((element) => element.type == 'country')) {
        String? country = checkoutFormData!.fieldgroups.billing.firstWhere((element) => element.type == 'country').value;
        if(country != null) {
          selectedCountry = country;
        }
        if(checkoutFormData!.fieldgroups.billing.any((element) => element.type == 'city')) {
          if(checkoutFormData != null && checkoutFormData!.fieldgroups.billing.any((element) => element.type == 'state')) {
            String? state = checkoutFormData!.fieldgroups.billing.firstWhere((element) => element.type == 'state').value;
            if(state != null) {
              getCity(state, selectedCountry);
            }
          }
        }
      }

/*      formData['security'] = checkoutForm.nonce.updateOrderReviewNonce;
      formData['woocommerce-process-checkout-nonce'] = checkoutForm.wpnonce;
      formData['wc-ajax'] = 'update_order_review';
      formData['billing_country'] = checkoutForm.billingCountry;
      formData['shipping_country'] = checkoutForm.billingCountry;

      formData['billing_first_name'] = checkoutForm.billingFirstName;
      formData['billing_last_name'] = checkoutForm.billingLastName;
      formData['billing_address_1'] = checkoutForm.billingAddress1;
      formData['billing_address_2'] = checkoutForm.billingAddress2;
      formData['billing_city'] = checkoutForm.billingCity;
      formData['billing_postcode'] = checkoutForm.billingPostcode;
      formData['billing_phone'] = checkoutForm.billingPhone;
      formData['billing_email'] = checkoutForm.billingEmail;
      formData['billing_country'] = checkoutForm.billingCountry;
      formData['billing_state'] = checkoutForm.billingState;

      formData['shipping_first_name'] = checkoutForm.shippingFirstName;
      formData['shipping_last_name'] = checkoutForm.shippingLastName;
      formData['shipping_address_1'] = checkoutForm.shippingAddress1;
      formData['shipping_address_2'] = checkoutForm.shippingAddress2;
      formData['shipping_city'] = checkoutForm.shippingCity;
      formData['shipping_postcode'] = checkoutForm.shippingPostcode;
      formData['shipping_country'] = checkoutForm.billingCountry;
      formData['shipping_state'] = checkoutForm.shippingState;*/

      _checkoutFormFetcher.sink.add(checkoutFormData!);
    } else {
      throw Exception('Failed to load checkout form');
    }
  }

  Future<OrderResult> placeOrder() async {
    /*formData['shipping_first_name'] = formData['billing_first_name'];
    formData['shipping_last_name'] = formData['billing_last_name'];
    formData['shipping_address_1'] = formData['billing_address_1'];
    formData['shipping_address_2'] = formData['billing_address_2'];
    formData['shipping_city'] = formData['billing_city'];
    formData['shipping_postcode'] = formData['billing_postcode'];
    formData['shipping_country'] = formData['billing_country'];
    formData['shipping_state'] = formData['billing_state'];*/

    if(appStateModel.fcmToken.isNotEmpty)
      formData['fcm_token'] = appStateModel.fcmToken;

    _placingOrderFetcher.sink.add(true);
    if(orderReviewData != null) {
      for (var i = 0; i < orderReviewData!.shipping.length; i++) {
        if (orderReviewData!.shipping[i].chosenMethod != '') {
          formData['shipping_method[' + i.toString() + ']'] =
              orderReviewData!.shipping[i].chosenMethod;
        }
      }
    }

    /** for WCFM Only **/
    if(appStateModel.customerLocation['latitude'] != null && appStateModel.customerLocation['longitude'] != null && appStateModel.customerLocation['address'] != null) {
      formData['wcfmmp_user_location_lat'] = appStateModel.customerLocation['latitude'];
      formData['wcfmmp_user_location_lng'] = appStateModel.customerLocation['longitude'];
      formData['wcfmmp_user_location'] = appStateModel.customerLocation['address'];
    }


    if(appStateModel.selectedDate != null && appStateModel.selectedTime != null) {
      formData['jckwds-delivery-date'] = appStateModel.selectedDateFormatted!;
      formData['jckwds-delivery-date-ymd'] = appStateModel.selectedDate!;
      formData['jckwds-delivery-time'] = appStateModel.selectedTime!;
    }

    /*formData['_wcf_flow_id'] = '3751';
    formData['_wcf_checkout_id'] = '3751';
    formData['mailpoet_woocommerce_checkout_optin'] = '1';
    formData['mailpoet_woocommerce_checkout_optin_present'] = '1';*/
    //*** USE this If you have error in checkout. Usually when permalink not working ***//
    //final response = await apiProvider.post('/index.php/checkout?wc-ajax=checkout', formData);
    final response = await apiProvider.post('/?wc-ajax=checkout', formData);
    _placingOrderFetcher.sink.add(false);
    if (response.statusCode == 200) {
      OrderResult orderInfo = OrderResult.fromJson(json.decode(response.body));
      _orderResultFetcher.sink.add(orderInfo);
      return orderInfo;
    } else {
      throw Exception('Failed to display order Result');
    }
  }

  dispose() {
    _checkoutFormFetcher.close();
    _orderReviewFetcher.close();
    _orderResultFetcher.close();
    _searchFetcher.close();
    _isLoadingFetcher.close();
    _placingOrderFetcher.close();
    _errorFetcher.close();
    _registerErrorFetcher.close();
    _isLoginLoadingFetcher.close();
    _customersFetcher.close();
    _ordersFetcher.close();
    _hasMoreOrdersFetcher.close();
    _orderFetcher.close();
  }

  Future updateOrderReview() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-update_order_review',
        Map());

    if (response.statusCode == 200) {
      orderReviewData = OrderReviewModel.fromJson(json.decode(response.body));
      if (orderReviewData!.paymentMethods.length != 0)
        formData['payment_method'] = orderReviewData!.paymentMethods
            .firstWhere((method) => method.chosen == true)
            .id;
      _orderReviewFetcher.sink.add(orderReviewData!);
      return true;
    } else {
      return false;
      //throw Exception('Failed to load order review');
    }
  }

  void updateOrderReview2() async {

    //Uncommented for shipping charge issue
    formData['shipping_first_name'] = formData['billing_first_name'];
    formData['shipping_last_name'] = formData['billing_first_name'];
    formData['shipping_address_1'] = formData['billing_address_1'];
    formData['shipping_address_2'] = formData['billing_address_2'];
    formData['shipping_city'] = formData['billing_first_name'];
    formData['shipping_postcode'] = formData['billing_postcode'];
    formData['shipping_country'] = formData['billing_country'];
    formData['shipping_state'] = formData['billing_state'];
    formData['s_country'] = formData['shipping_country'];
    formData['s_state'] = formData['shipping_state'];
    formData['s_postcode'] = formData['billing_postcode'];
    formData['postcode'] = formData['billing_postcode'];
    formData['s_city'] = formData['shipping_city'];
    formData['s_address'] = formData['shipping_address_1'];
    formData['s_address_2'] = formData['shipping_address_2'];
    formData['country'] = formData['billing_country'];
    formData['state'] = formData['billing_state'];
    formData['city'] = formData['billing_city'];
    formData['address'] = formData['billing_address_1'];
    formData['address_2'] = formData['billing_address_2'];
    formData['sameForShipping'] = 'true';
    formData['wc-ajax'] = 'update_order_review';
    formData['has_full_address'] = 'true';
    formData.removeWhere((key, value) => value == null);
    formData['post_data'] = getQueryString(formData);

    if(appStateModel.fcmToken.isNotEmpty)
      formData['fcm_token'] = appStateModel.fcmToken;

    _placingOrderFetcher.sink.add(true);

    if(orderReviewData == null) {
      final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-update_order_review', formData);
      if (response.statusCode == 200) {
        orderReviewData = OrderReviewModel.fromJson(json.decode(response.body));
        _orderReviewFetcher.sink.add(orderReviewData!);
      }
    }

    if(orderReviewData != null && orderReviewData!.shipping.length > 0)
    for (var i = 0; i < orderReviewData!.shipping.length; i++) {
      if (orderReviewData!.shipping[i].chosenMethod != '') {
        String id = orderReviewData!.shipping[i].package.vendorId != '0' ? orderReviewData!.shipping[i].package.vendorId : i.toString();
        formData['shipping_method[' + id + ']'] = orderReviewData!.shipping[i].chosenMethod;
      }
    }

    /** for WCFM Only **/
    if(appStateModel.customerLocation['latitude'] != null && appStateModel.customerLocation['longitude'] != null && appStateModel.customerLocation['address'] != null) {
      formData['wcfmmp_user_location_lat'] = appStateModel.customerLocation['latitude'];
      formData['wcfmmp_user_location_lng'] = appStateModel.customerLocation['longitude'];
      formData['wcfmmp_user_location'] = appStateModel.customerLocation['address'];
    } else if(checkoutForm.value.fieldgroups.billing.any((element) => element.label == 'Delivery Location' && element.required == true)) {
      if(formData['wcfmmp_user_location_lat'] == null) {
        formData['wcfmmp_user_location_lat'] = '';
        formData['wcfmmp_user_location_lng'] = '';
      }
      if(formData['wcfmmp_user_location'] == null) {
        formData['wcfmmp_user_location'] = formData['billing_address_1']!;
      }
    }


    if(appStateModel.selectedDate != null && appStateModel.selectedTime != null) {
      formData['jckwds-delivery-date'] = appStateModel.selectedDateFormatted!;
      formData['jckwds-delivery-date-ymd'] = appStateModel.selectedDate!;
      formData['jckwds-delivery-time'] = appStateModel.selectedTime!;
    }

   // print(formData);

print(formData);

    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-update_order_review', formData);

    if (response.statusCode == 200) {
      orderReviewData = OrderReviewModel.fromJson(json.decode(response.body));
      _orderReviewFetcher.sink.add(orderReviewData!);
    } else {
      throw Exception('Failed to load order review');
    }
  }

  void chooseShipping(String value) {
    orderReviewData!.shipping[0].chosenMethod = value;
    _orderReviewFetcher.sink.add(orderReviewData!);
  }

  void choosePayment(String value) {
    for (var i = 0; i < orderReviewData!.paymentMethods.length; i++) {
      orderReviewData!.paymentMethods[i].chosen = false;
    }
    for (var i = 0; i < orderReviewData!.paymentMethods.length; i++) {
      if (orderReviewData!.paymentMethods[i].id == value) {
        orderReviewData!.paymentMethods[i].chosen = true;
      }
    }
  }

  /*void addAddToCarErrorMessage(String message) {
    AddToCartErrorModel addToCartError = new AddToCartErrorModel();
    addToCartError.data = new AddToCartErrorData();
    addToCartError.data.notice = message;
    //_addToCartErrorFetcher.sink.add(addToCartError);
  }*/

  List<Order> orders = [];
  bool hasMoreOrders = true;
  int ordersPage = 0;
  var addressFormData = new Map<String, String>();

  final _errorFetcher = BehaviorSubject<WpErrors>();
  final _registerErrorFetcher = BehaviorSubject<RegisterError>();
  final _isLoginLoadingFetcher = BehaviorSubject<String>();
  var _hasMoreOrdersFetcher = BehaviorSubject<bool>();

  ValueStream<WpErrors> get error => _errorFetcher.stream;
  ValueStream<String> get isLoginLoading => _isLoginLoadingFetcher.stream;
  ValueStream<RegisterError> get registerError => _registerErrorFetcher.stream;
  ValueStream<bool> get hasMoreOrderItems => _hasMoreOrdersFetcher.stream;

  final _ordersFetcher = BehaviorSubject<List<Order>>();
  ValueStream<List<Order>> get allOrders => _ordersFetcher.stream;

  final _customersFetcher = BehaviorSubject<Customer>();
  ValueStream<Customer> get customerDetail => _customersFetcher.stream;

  getOrders() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-orders', Map());
    orders = orderFromJson(response.body);
    _ordersFetcher.sink.add(orders);
    _hasMoreOrdersFetcher.sink.add(true);
  }

  void loadMoreOrders() async {
    ordersPage = ordersPage + 1;
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-orders',
        {'page': ordersPage.toString()});
    List<Order> moreOrders = orderFromJson(response.body);
    orders.addAll(moreOrders);
    _ordersFetcher.sink.add(orders);
    if (moreOrders.length == 0) {
      hasMoreOrders = false;
      _hasMoreOrdersFetcher.sink.add(false);
    }
  }

  Future processCredimaxPayment(String redirect) async {
    _placingOrderFetcher.sink.add(true);
    int pos1 = redirect.lastIndexOf("&order=");
    int pos2 = redirect.lastIndexOf("&key=wc_order");
    final orderId = redirect.substring(pos1 + 7, pos2);

    final orderResponse = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-order',
        {'id': orderId});
    Order newOrder = Order.fromJson(json.decode(orderResponse.body));

    int pos3 = redirect.lastIndexOf("sessionId=");
    int pos4 = redirect.lastIndexOf("&order=");
    String sessionId = redirect.substring(pos3 + 10, pos4);

    String body = '';
    body = 'merchant=E14560950&order.id=' +
        orderId +
        '&order.amount=' +
        newOrder.total +
        '&order.currency=' +
        newOrder.currency +
        '&order.description=Pay+for+order+%23' +
        orderId +
        '+via+Credit+Card&order.customerOrderDate=2019-11-17&order.customerReference=' +
        newOrder.customerId.toString() +
        '&order.reference=' +
        orderId +
        '&session.id=' +
        sessionId +
        '&billing.address.city=' +
        newOrder.billing.city +
        '&billing.address.country=BHR&billing.address.postcodeZip=' +
        newOrder.billing.postcode +
        '&billing.address.stateProvince=' +
        newOrder.billing.state +
        '&billing.address.street=' +
        newOrder.billing.address1 +
        '&billing.address.street2=' +
        newOrder.billing.address2 +
        '&customer.email=' +
        newOrder.billing.email +
        '&customer.firstName=' +
        newOrder.billing.firstName +
        '&customer.lastName=' +
        newOrder.billing.lastName +
        '&customer.phone=' +
        newOrder.billing.phone +
        '&interaction.merchant.name=Awal+Pets&interaction.merchant.address.line1=Manama&interaction.merchant.address.line2=Bahrain&interaction.displayControl.billingAddress=HIDE&interaction.displayControl.customerEmail=HIDE&interaction.displayControl.orderSummary=HIDE&interaction.displayControl.shipping=HIDE&interaction.cancelUrl=' +
        config.url +
        '%2Fcheckout%2F';

    final response = await apiProvider.processExternalPaymentToken('https://credimax.gateway.mastercard.com/api/page/version/49/pay', body);
    _placingOrderFetcher.sink.add(false);
    return true;
  }

  Future<StripeTokenModel?> getStripeToken(
      Map<String, dynamic> stripeTokenParams) async {
    final response = await apiProvider.postAjax(
        'https://api.stripe.com/v1/tokens', stripeTokenParams);
    if (response.statusCode == 200) {
      StripeTokenModel stripeToken =
          StripeTokenModel.fromJson(json.decode(response.body));
      return stripeToken;
    } else {
      return null;
    }
  }

  Future<StripeSourceModel?> getStripeSource(
      Map<String, dynamic> stripeSourceParams) async {
    final response = await apiProvider.postAjax(
        'https://api.stripe.com/v1/sources', stripeSourceParams);
    if (response.statusCode == 200) {
      StripeSourceModel stripeSource =
          StripeSourceModel.fromJson(json.decode(response.body));
      return stripeSource;
    } else {
      return null;
    }
  }

  final _orderFetcher = BehaviorSubject<Order>();
  late String currentOrder;
  ValueStream<Order> get order => _orderFetcher.stream;

  getOrder() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-order',
        {'id': currentOrder});
    Order newOrder = Order.fromJson(json.decode(response.body));
    _orderFetcher.sink.add(newOrder);
  }

  dynamic getNewOrder(String id) async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-order', {'id': id});
    if(response.statusCode == 200) {
      Order newOrder = Order.fromJson(json.decode(response.body));
      return newOrder;
    }
  }

  String getQueryString(Map params,
      {String prefix: '&', bool inRecursion: false}) {
    String query = '';

    params.forEach((key, value) {
      if (inRecursion) {
        key = '[$key]';
      }

      if (value is String || value is int || value is double || value is bool) {
        query += '$prefix$key=$value';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });

    return query;
  }

  Future<bool> updateAddress() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-update-address', formData);
    return true;
  }

  Future<void> getCity(String state, String country) async {
    if(checkoutFormData!.fieldgroups.billing.any((element) => element.type == 'city')) {
      Response response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-get_cities',
          {'country': country, 'state': state});
      if(response.statusCode == 200) {
        if(checkoutFormData != null) {
          List<DotappOption> options = List<DotappOption>.from(json.decode(response.body).map((x) => DotappOption.fromJson(x)));
          print(options.length);
          if(checkoutFormData!.fieldgroups.billing.any((element) => element.type == 'city')) {
            checkoutFormData!.fieldgroups.billing.singleWhere((element) => element.type == 'city').dotappOptions = options;
            _checkoutFormFetcher.sink.add(checkoutFormData!);
          }
        }
      }
    }
  }

  getRzOrderId(orderId) async {
    final response = await apiProvider.get('/wp-admin/admin-ajax.php?action=build-app-online_razorpay_order_id&order_id=' + orderId);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future<void> ajaxCall(String s) async {
    final response = await apiProvider.get(s);
    return;
  }

  getPayMongoToken(PayMongoCardModel payMongoCardModel, String authorizationKey) async {
    Response response = await apiProvider.processPayMongoToken('https://api.paymongo.com/v1/payment_methods', authorizationKey, payMongoCardModel.toJson());
    if(response.statusCode == 200) {
      PayMongoCardModel data = payMongoCardModelFromJson(response.body);
      return data;
    } else {
      return payMongoCardModel;
    }
  }
}
