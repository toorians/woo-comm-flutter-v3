import 'package:rxdart/rxdart.dart';

import './../models/attributes_model.dart';
import './../resources/api_provider.dart';
import '../models/product_model.dart';

class ProductsBloc {
  Map<String, List<Product>> products = Map();
  Map<String, bool> moreItems = {};
  var productsPage = new Map<String, int>();
  List<AttributesModel> attributes = [];
  var productsFilter = new Map<String, dynamic>();

  final apiProvider = ApiProvider();
  final _productsFetcher = BehaviorSubject<List<Product>>();
  final _attributesFetcher = BehaviorSubject<List<AttributesModel>>();
  final _hasMoreItemsFetcher = BehaviorSubject<bool>();
  final _isLoadingProductsFetcher = BehaviorSubject<bool>();

  //ProductsBloc() : products = Map() {}

  //String search="";

  ValueStream<List<Product>> get allProducts => _productsFetcher.stream;
  ValueStream<List<AttributesModel>> get allAttributes =>
      _attributesFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreItemsFetcher.stream;
  ValueStream<bool> get isLoadingProducts => _isLoadingProductsFetcher.stream;

  fetchAllProducts(String id) async {
    productsFilter['id'] = id.toString();
    productsPage[id] = 1;
    if (products.containsKey(id) &&
        products[id]!.isNotEmpty) {
      _productsFetcher.sink.add(products[id]!);
      //_hasMoreItemsFetcher.sink.add(false);
    } else {
      _productsFetcher.sink.add([]);
      products[id] = [];
      productsFilter['page'] = productsPage[id].toString();
      _isLoadingProductsFetcher.sink.add(true);
      List<Product> newProducts =
      await apiProvider.fetchProductList(productsFilter);
      products[id]!.addAll(newProducts);
      if(productsFilter['id'] == id.toString())
      _productsFetcher.sink.add(products[id]!);
      _isLoadingProductsFetcher.sink.add(false);
      if (newProducts.length < 6) {
        moreItems[id] = false;
        _hasMoreItemsFetcher.sink.add(moreItems[id]!);
      } else {
        moreItems[id] = true;
        _hasMoreItemsFetcher.sink.add(moreItems[id]!);
      }
    }
  }

  reset() {
    products[productsFilter['id']] = [];
  }

  loadMore(String id) async {
    productsPage[id] = productsPage[id]! + 1;
    productsFilter['page'] = productsPage[id].toString();
    List<Product> moreProducts =
    await apiProvider.fetchProductList(productsFilter);
    products[id]!.addAll(moreProducts);
    _productsFetcher.sink.add(products[id]!);
    if (moreProducts.length < 6) {
      moreItems[id] = false;
      _hasMoreItemsFetcher.sink.add(moreItems[id]!);
    }
  }

  dispose() {
    _productsFetcher.close();
    _attributesFetcher.close();
    _hasMoreItemsFetcher.close();
    _isLoadingProductsFetcher.close();
  }

  Future fetchProductsAttributes() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-product-attributes',
        {'category': productsFilter['id'].toString()});
    if (response.statusCode == 200) {
      attributes = filterModelFromJson(response.body);
      _attributesFetcher.sink.add(attributes);
    } else {
      throw Exception('Unexpected response from server: (${response.statusCode}) ${response.reasonPhrase}');
    }
  }

  void clearFilter() {
    if (attributes != null)
      for (var i = 0; i < attributes.length; i++) {
        for (var j = 0; j < attributes[i].terms.length; j++) {
          productsFilter.remove('attribute_term' + j.toString());
          productsFilter.remove('attributes' + j.toString());
        }
      }
    for (var i = 0; i < attributes.length; i++) {
      for (var j = 0; j < attributes[i].terms.length; j++) {
        attributes[i].terms[j].selected = false;
      }
    }
    _attributesFetcher.sink.add(attributes);
    fetchAllProducts(productsFilter['id']);
  }

  void applyFilter(String id, double minPrice, double maxPrice) {
    if (products[productsFilter['id']] != null) {
      products[productsFilter['id']]!.clear();
    }

    //filter = new Map<String, dynamic>();
    //filter['id'] = id.toString();

    productsFilter['min_price'] = minPrice.toString();
    productsFilter['max_price'] = maxPrice.toString();
    if (attributes != null)
      for (var i = 0; i < attributes.length; i++) {
        for (var j = 0; j < attributes[i].terms.length; j++) {
          if (attributes[i].terms[j].selected) {
            productsFilter['attribute_term' + j.toString()] =
                attributes[i].terms[j].termId.toString();
            productsFilter['attributes' + j.toString()] =
                attributes[i].terms[j].taxonomy;
          }
        }
      }
    fetchAllProducts(productsFilter['id']);
  }

  void changeCategory(int id) {
    productsFilter['id'] = id.toString();
    fetchAllProducts(productsFilter['id']);
  }
}
