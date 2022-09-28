import 'package:rxdart/rxdart.dart';

import './../models/WalletModel.dart';
import './../resources/api_provider.dart';

class WalletBloc {
  late List<WalletModel> transaction;
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool hasMoreItems = true;

  final apiProvider = ApiProvider();
  final _walletFetcher = BehaviorSubject<List<WalletModel>>();

  ValueStream<List<WalletModel>> get allTransactions => _walletFetcher.stream;

  load() async {
    page = 1;
    filter['page'] = page.toString();
    dynamic response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=build-app-online-wallet', filter);
    if (response.statusCode == 200) {
      transaction = walletModelFromJson(response.body);
      _walletFetcher.sink.add(transaction);
    } else {
      throw Exception('Failed to load wallet');
    }
  }

  loadMore() async {
    page = page + 1;
    filter['page'] = page.toString();
    if (hasMoreItems) {
      dynamic response = await apiProvider.postWithCookies(
          '/wp-admin/admin-ajax.php?action=build-app-online-wallet', filter);
      if (response.statusCode == 200) {
        List<WalletModel> moreData = walletModelFromJson(response.body);
        transaction.addAll(moreData);
        hasMoreItems = moreData.length == 0;
      } else {
        throw Exception('Failed to load wallet');
      }
    }
  }

  dispose() {
    _walletFetcher.close();
  }

  addBalance(Map<String, dynamic> data) async {
    //dynamic response = await apiProvider.postWithCookies('/wp-admin/admin-ajax.php', data);
    dynamic response = await apiProvider.postWithCookies('/my-account/woo-wallet/add/', data);
    return true;
  }

}
