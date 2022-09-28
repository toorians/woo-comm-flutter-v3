import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import './../models/orders_model.dart';
import './../resources/api_provider.dart';

class OrderSummaryBloc {
  final _orderFetcher = BehaviorSubject<Order>();
  final apiProvider = ApiProvider();

  ValueStream<Order> get order => _orderFetcher.stream;

  getOrder(String id) async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-order', {'id': id});
    if(response.statusCode == 200) {
      Order newOrder = Order.fromJson(json.decode(response.body));
      _orderFetcher.sink.add(newOrder);
    }
  }

  dynamic getNewOrder(String id) async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-order', {'id': id});
    if(response.statusCode == 200) {
      Order newOrder = Order.fromJson(json.decode(response.body));
      return newOrder;
    }
  }

  dispose() {
    _orderFetcher.close();
  }

  Future<void> clearCart() async {
    final response = await apiProvider.get(
        '/wp-admin/admin-ajax.php?action=build-app-online-emptyCart');

    //this.api.ajaxCall('/checkout/order-received/'+ this.order.id +'/?key=' + this.order.order_key).then(res => {}, err => {});
  }

  Future<StatusModel> submitSupportRequest(Map<String, String> data) async {
    final response = await apiProvider.adminAjax(data);
    StatusModel status = statusModelFromJson(response.body);
    return status;
  }

  submitCancelRequest(Map<String, String> data, BuildContext context) async {
    final response = await apiProvider.post('/wp-admin/admin-post.php', data);
    if(response.statusCode == 200) {
      return true;
    } else {
      StatusModel status = statusModelFromJson(response.body);
      final snackBar = SnackBar(
        content: Text(status.message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  submitRefundRequest(Map<String, String> data) async {
    final response = await apiProvider.adminAjax(data);
    StatusModel status = statusModelFromJson(response.body);
    return status;
  }

  Future<void> thankYou(Order order) async {
    final response = await apiProvider.get('/checkout/order-received/'+ order.id.toString() +'/?key=' + order.orderKey);
  }
}

String getQueryString(Map params,
    {String prefix: '&', bool inRecursion: false}) {
  String query = '?';

  params['flutter_app'] = '1';

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
            getQueryString({k: v}, prefix: '$prefix$key', inRecursion: false);
      });
    }
  });
  return query;
}