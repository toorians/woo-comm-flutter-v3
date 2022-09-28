import '../../src/models/product_model.dart';
import 'dart:convert';
import './../models/releated_products.dart';
import './../models/review_model.dart';
import './../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailBloc {

  final apiProvider = ApiProvider();
  final _relatedProductFetcher = BehaviorSubject<RelatedProductsModel>();
  final _reviewsFetcher = BehaviorSubject<List<ReviewModel>>();
  final _productFetcher = BehaviorSubject<Product>();

  ValueStream<RelatedProductsModel> get relatedProducts => _relatedProductFetcher.stream;
  ValueStream<List<ReviewModel>> get allReviews => _reviewsFetcher.stream;
  ValueStream<Product> get product => _productFetcher.stream;

  void getProductsDetails(int id) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-product_details', {'product_id': id.toString()});
    if (response.statusCode == 200) {
      RelatedProductsModel productsList = releatedProductsFromJson(response.body);
      _relatedProductFetcher.sink.add(productsList);
    } else {
      throw Exception('Failed to load related products');
    }
  }

  void getReviews(int id) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-product_reviews', {'product_id': id.toString()});
    if (response.statusCode == 200) {
      List<ReviewModel> reviews = reviewModelFromJson(response.body);
      _reviewsFetcher.sink.add(reviews);
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  dispose() {
    _relatedProductFetcher.close();
    _reviewsFetcher.close();
    _productFetcher.close();
  }

  getProduct(Product p) async {
    if(p.name.isNotEmpty) {
      _productFetcher.sink.add(p);
    } else {
      final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-product', {'product_id': p.id.toString()});
      if (response.statusCode == 200) {
        Product product = Product.fromJson(json.decode(response.body));
        _productFetcher.sink.add(product);
      } else {
        throw Exception('Failed to load products');
      }
    }
  }

  getProductBySKU(String sku) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-product', {'sku': sku});
    if (response.statusCode == 200) {
      Product product = Product.fromJson(json.decode(response.body));
      return product;
    } else {
      throw Exception('Failed to load products');
    }
  }

}