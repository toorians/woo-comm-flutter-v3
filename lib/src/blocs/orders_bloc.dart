import 'dart:convert';

import '../models/orders_model.dart';
import '../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc {
  final apiProvider = ApiProvider();
  List<Order> orders = [];
  bool hasMoreOrders = true;
  int ordersPage = 1;

  var _hasMoreOrdersFetcher = BehaviorSubject<bool>();

  ValueStream<bool> get hasMoreOrderItems => _hasMoreOrdersFetcher.stream;

  final _ordersFetcher = BehaviorSubject<List<Order>>();
  ValueStream<List<Order>> get allOrders => _ordersFetcher.stream;

  getOrders() async {
    ordersPage = 1;
    final response = await apiProvider.postWihoutUserLocation('/wp-admin/admin-ajax.php?action=build-app-online-orders', Map());
    orders = orderFromJson(response.body);
    _ordersFetcher.sink.add(orders);
    //if(orders.length < 9)
    //_hasMoreOrdersFetcher.sink.add(true);
  }

  void loadMoreOrders() async {
    ordersPage = ordersPage + 1;
    final response = await apiProvider.postWihoutUserLocation(
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

  dispose() {
    _ordersFetcher.close();
    _hasMoreOrdersFetcher.close();
  }

  Future<bool> cancelOrder(Order order) async {
    final response = await apiProvider.postWihoutUserLocation(
        '/wp-admin/admin-ajax.php?action=build-app-online-cancel_order',
        {'id': order.id.toString()});
    if (response.statusCode == 200) {
      Order newOrder = Order.fromJson(json.decode(response.body));
      int index = orders.indexOf(order);
      orders[index] = newOrder;
      _ordersFetcher.sink.add(orders);
    }
    return true;
  }
}
