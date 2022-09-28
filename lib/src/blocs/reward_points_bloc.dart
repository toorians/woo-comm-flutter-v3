import 'package:app/src/models/reward_points.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/api_provider.dart';

class RewardPointsBloc {

  var filter = new Map<String, dynamic>();
  bool hasMoreData = false;
  int page = 1;
  late RewardPointsModel rewardPoints;

  final apiProvider = ApiProvider();
  
  final _hasMoreRewardPointsFetcher = BehaviorSubject<bool>();
  final _rewardPointsFetcher = BehaviorSubject<RewardPointsModel>();

  ValueStream<bool> get hasMoreRewardPointsItems => _hasMoreRewardPointsFetcher.stream;
  ValueStream<RewardPointsModel> get RewardPointsData => _rewardPointsFetcher.stream;

  dispose() {
    _hasMoreRewardPointsFetcher.close();
    _rewardPointsFetcher.close();
  }

  getRewardPoints() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-getPointsHistory', Map());
    rewardPoints = rewardPointsFromJson(response.body);
    _rewardPointsFetcher.sink.add(rewardPoints);
    if (rewardPoints.items.length < 20) {
      hasMoreData = false;
      _hasMoreRewardPointsFetcher.sink.add(hasMoreData);
    }
  }

  Future loadMoreRewardPoints() async {
    page = page + 1;
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-getPointsHistory', {'page': page.toString()});
    RewardPointsModel points = rewardPointsFromJson(response.body);
    rewardPoints.items.addAll(points.items);
    _rewardPointsFetcher.sink.add(rewardPoints);
    if (points.items.length == 0 || points.items.length < 20) {
      hasMoreData = false;
      _hasMoreRewardPointsFetcher.sink.add(hasMoreData);
    }
  }
}
