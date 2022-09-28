// ignore_for_file: dead_code

import 'dart:convert';

import 'package:app/src/models/errors/woo_error.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/vendor/product_variation_model.dart';
import '../../resources/api_provider.dart';
import '../../resources/wc_api.dart';

class VariationProductBloc {

  List<ProductVariation> variationProducts = [];
  var variationFilter = new Map<String, dynamic>();
  static WooCommerceAPI wc_api = new WooCommerceAPI();
  final apiProvider = ApiProvider();
  final _vendorVariationProductsFetcher = BehaviorSubject<List<ProductVariation>>();
  ValueStream<List<ProductVariation>> get allVendorVariationProducts => _vendorVariationProductsFetcher.stream;

  Future<void> getVariationProducts(int id) async {
    variationFilter['per_page'] = 100;
    final response = await wc_api.getAsync("products/" + id.toString() + "/variations" + getQueryString(variationFilter));
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
      throw Exception('Failed to edit product');
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
      throw Exception('Failed to delete product');
    }
  }

  dispose() {
    _vendorVariationProductsFetcher.close();
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
