import 'dart:convert';

import 'package:app/src/models/errors/woo_error.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/checkout/checkout_form_model.dart';
import '../../models/orders_model.dart';
import '../../models/vendor/product_variation_model.dart';
import '../../models/vendor/vendor_product_model.dart';
import '../../resources/api_provider.dart';
import '../../resources/wc_api.dart';

class VendorBloc {
  List<VendorProduct> products = [];
  List<ProductVariation> variationProducts = [];
  var productFilter = new Map<String, dynamic>();
  var orderFilter = new Map<String, dynamic>();
  var variationFilter = new Map<String, dynamic>();

  int productPage = 0;
  String initialSelectedCountry = 'IN';
  var formData = new Map<String, String>();
  int ordersPage = 0;

  static WooCommerceAPI wc_api = new WooCommerceAPI();

  final apiProvider = ApiProvider();
  final _vendorProductsFetcher = BehaviorSubject<List<VendorProduct>>();
  final _vendorVariationProductsFetcher =
      BehaviorSubject<List<ProductVariation>>();
  final _ordersFetcher = BehaviorSubject<List<Order>>();
  final _vendorOrderFormFetcher = BehaviorSubject<CheckoutFormModel>();

  ValueStream<List<Order>> get allOrders => _ordersFetcher.stream;
  ValueStream<List<VendorProduct>> get allVendorProducts =>
      _vendorProductsFetcher.stream;
  ValueStream<List<ProductVariation>> get allVendorVariationProducts =>
      _vendorVariationProductsFetcher.stream;
  ValueStream<CheckoutFormModel> get vendorOrderForm =>
      _vendorOrderFormFetcher.stream;

  fetchAllProducts() async {
    productFilter['page'] = 1;
    final response = await wc_api.getAsync("products" + getQueryString(productFilter));
    if (response.statusCode == 200) {
      products = productFromJson(response.body);
      _vendorProductsFetcher.sink.add(products);
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      _vendorProductsFetcher.sink.addError(wooError.message);
    }
  }

  Future<bool> addProduct(VendorProduct product) async {
    product.vendor =  productFilter['vendor'];
    final response = await wc_api.postAsync("products", product.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      VendorProduct newProduct = VendorProduct.fromJson(json.decode(response.body));
      apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-update-vendor-product', {'id': newProduct.id.toString()});
      if(products != null) {
        products.insert(0, newProduct);
      } else {
        fetchAllProducts();
      }
      return true;
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<VendorProduct> editProduct(VendorProduct product) async {
    final response = await wc_api.putAsync(
        "products/" + product.id.toString(), product.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return VendorProduct.fromJson(json.decode(response.body));
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      throw Exception('Failed to edit product');
    }
  }

  Future<VendorProduct> deleteProduct(VendorProduct product) async {
    products.remove(product);
    _vendorProductsFetcher.sink.add(products);
    final response = await wc_api.deleteAsync("products/" + product.id.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return VendorProduct.fromJson(json.decode(response.body));
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      throw Exception('Failed to delete product');
    }
  }

  Future<bool> loadMoreProducts() async {
    productFilter['page'] =
        productFilter['page'] == null ? 1 : productFilter['page'] + 1;

    final response =
        await wc_api.getAsync('products' + getQueryString(productFilter));
    List<VendorProduct> moreProducts = productFromJson(response.body);
    products.addAll(moreProducts);
    _vendorProductsFetcher.sink.add(products);
    if (moreProducts.length == 0) {
      return false;
    } else return true;
  }

  //orders

  List<Order> orders = [];

  getOrders() async {
    orderFilter['page'] = 1;
    final response = await wc_api.getAsync("orders" + getQueryString(orderFilter));
    if (response.statusCode == 200) {
      orders = orderFromJson(response.body);
      _ordersFetcher.sink.add(orders);
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      _ordersFetcher.sink.addError(wooError.message);
    }

    //_hasMoreOrdersFetcher.sink.add(true);
  }

  Future<bool> loadMoreOrders() async {
    orderFilter['page'] = orderFilter['page'] + 1;
    final response = await wc_api.getAsync("orders" + getQueryString(orderFilter));
    List<Order> moreOrders = orderFromJson(response.body);
    orders.addAll(moreOrders);
    _ordersFetcher.sink.add(orders);
    if(moreOrders.length < 10) {
      return false;
    } return true;
  }

  Future<Order> addOrder(Order order) async {
    final response = await wc_api.postAsync("orders", order.toJson());
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      throw Exception('Failed to add order');
    }
  }

  Future<Order> editOrder(Order order) async {
    final response =
        await wc_api.putAsync("orders/" + order.id.toString(), order.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      throw Exception('Failed to edit order');
    }
  }

  Future<Order?> deleteOrder(Order order) async {
    final response = await wc_api.deleteAsync("orders/" + order.id.toString());
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    }
  }

  void getVendorOrderForm() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-get_checkout_form',
        Map()); //formData.toJson();
    if (response.statusCode == 200) {
      CheckoutFormModel checkoutForm = CheckoutFormModel.fromJson(json.decode(response.body));
      _vendorOrderFormFetcher.sink.add(checkoutForm);
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      throw Exception('Failed to load checkout form');
    }
  }

//wallet

  getWallet() async {
    final response = await wc_api.postAsync(
        '/wp-admin/admin-ajax.php?action=build-app-online-wallet', Map());
  }

  //Variation Products

  resetVariationProducts() {
    variationProducts = [];
    _vendorVariationProductsFetcher.sink.add(variationProducts);
  }

  Future<void> getVariationProducts(int id) async {
    variationFilter['per_page'] = 100;
    final response = await wc_api.getAsync("products/" +
        id.toString() +
        "/variations" +
        getQueryString(variationFilter));
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      variationProducts = productVariationFromJson(response.body);
      _vendorVariationProductsFetcher.sink.add(variationProducts);
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      throw Exception('Failed to load product');
    }
  }

  Future<ProductVariation> addVariationProduct(int id, ProductVariation variationProduct) async {
    final response = await wc_api.postAsync("products/" + id.toString() + "/variations", variationProduct.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      ProductVariation productVariation = ProductVariation.fromJson(json.decode(response.body));
      variationProducts.add(productVariation);
      _vendorVariationProductsFetcher.sink.add(variationProducts);
      return ProductVariation.fromJson(json.decode(response.body));
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      throw Exception('Failed to add product');
    }
  }

  Future<bool> editVariationProduct(int productId, ProductVariation variationProduct) async {
    final response = await wc_api.putAsync("products/" + productId.toString() + "/variations/" + variationProduct.id.toString(), variationProduct.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      return false;
      //throw Exception('Failed to edit product');
    }
  }

  Future<bool> deleteVariationProduct(int id, int variationId) async {
    variationProducts.removeWhere((element) => element.id == variationId);
    _vendorVariationProductsFetcher.sink.add(variationProducts);
    final response = await wc_api.deleteAsync("products/" + id.toString() + "/variations/" + variationId.toString() + '?force=true');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      WooError wooError = wooErrorFromJson(response.body);
      return false;
      //throw Exception('Failed to delete product');
    }
  }

  dispose() {
    _vendorProductsFetcher.close();
    _ordersFetcher.close();
    _vendorVariationProductsFetcher.close();
    _vendorOrderFormFetcher.close();
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
