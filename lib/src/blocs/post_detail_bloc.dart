import 'package:app/src/models/post_model.dart';
import 'package:rxdart/rxdart.dart';
import './../resources/api_provider.dart';

class PostBloc {

  String path = 'post';
  final apiProvider = ApiProvider();
  final _dataFetcher = BehaviorSubject<Post>();

  ValueStream<Post> get post => _dataFetcher.stream;

  fetchData(String id, String path) async {
    final response = await apiProvider.wpGet(path + 's/' + id.toString());
    if (response.statusCode == 200) {
      _dataFetcher.sink.add(postFromJson(response.body));
    } else {

    }
  }

  dispose() {
    _dataFetcher.close();
  }
}
