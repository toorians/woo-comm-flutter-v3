import 'package:app/src/models/vendor/store_model.dart';
import 'package:app/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class StoresBloc {

  List<StoreModel> stores = [];
  int page = 1;
  var filter = new Map<String, dynamic>();
  bool hasMoreItems = false;

  final apiProvider = ApiProvider();
  final _storeListFetcher = BehaviorSubject<List<StoreModel>>();

  ValueStream<List<StoreModel>> get storeList => _storeListFetcher.stream;

  getAllStores() async {
    if(stores.length == 0) {
      filter['page'] = '1';
      final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-vendors', filter);
      if(response.statusCode == 200) {
        stores = storeModelFromJson(response.body);
        _storeListFetcher.add(stores);
        hasMoreItems = stores.length > 9;
      }
    }
  }

  loadMoreStores() async {
    page = page + 1;
    filter['page'] = page.toString();
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-vendors',filter);
    if(response.statusCode == 200) {
      List<StoreModel> moreStore = storeModelFromJson(response.body);
      stores.addAll(moreStore);
      _storeListFetcher.add(stores);
      hasMoreItems = moreStore.length > 9;
    }
  }

  refresh() async {
    page = 1;
    filter['page'] = page.toString();
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-vendors', filter);
    stores = storeModelFromJson(response.body);
    hasMoreItems = stores.length > 9;
    _storeListFetcher.add(stores);
    return true;
  }

  dispose() {
    _storeListFetcher.close();
  }
}