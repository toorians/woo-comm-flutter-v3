import 'package:app/src/models/coupon.dart';
import 'package:app/src/resources/wc_api.dart';
import 'package:rxdart/rxdart.dart';

class CouponBloc {
  List<CouponModel> coupons = [];

  static WooCommerceAPI wc_api = new WooCommerceAPI();

  final _couponFetcher = BehaviorSubject<List<CouponModel>>();

  ValueStream<List<CouponModel>> get allCoupons => _couponFetcher.stream;

  fetchCoupons() async {
    final response = await wc_api.getAsync("coupons?per_page=100");
    if(response.statusCode == 200) {
      coupons = couponFromJson(response.body);
      final now = DateTime.now();
      coupons.removeWhere((element) => element.dateExpires != null && element.dateExpires!.isBefore(now));
      _couponFetcher.sink.add(coupons);
    } else {
      _couponFetcher.sink.add([]);
    }
  }

  dispose() {
    _couponFetcher.close();
  }
}
