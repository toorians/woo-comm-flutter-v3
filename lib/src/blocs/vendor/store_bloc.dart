import 'package:app/src/models/product_model.dart';
import 'package:app/src/models/vendor/store_details.dart';
import 'package:app/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class StoreHomeBloc {

  int page = 1;
  late StoreDetails storeDetail;
  var filter = new Map<String, dynamic>();
  var hasMoreItems = false;

  final apiProvider = ApiProvider();
  final _storeFetcher = BehaviorSubject<StoreDetails>();

  bool loadingHomeProducts = false;

  ValueStream<StoreDetails> get storeDetails => _storeFetcher.stream;

  fetchStoreDetails() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-store_details', {});
    if(response.statusCode == 200) {
      storeDetail = storeDetailsFromJson(response.body);
      if(storeDetail.products.length > 9) {
        hasMoreItems = true;
      }
      _storeFetcher.sink.add(storeDetail);
    } else {
      _storeFetcher.sink.addError(true);
      throw Exception(
        'Unexpected response from server: (${response.statusCode}) ${response.reasonPhrase}',
      );
    }
  }

  loadMoreProducts() async {
    page = page + 1;
    filter['page'] = page.toString();
    loadingHomeProducts = true;
    List<Product> moreProducts = await apiProvider.fetchProductList(filter);
    storeDetail.products.addAll(moreProducts);
    _storeFetcher.sink.add(storeDetail);
    hasMoreItems = moreProducts.length > 9;
    loadingHomeProducts = false;
  }

  dispose() {
    _storeFetcher.close();
  }
}