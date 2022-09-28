import '../models/downloads_model.dart';
import '../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class DownloadsBloc {
  final apiProvider = ApiProvider();
  List<DownloadsModel> downloads = [];
  int page = 1;

  final _downloadsFetcher = BehaviorSubject<List<DownloadsModel>>();
  ValueStream<List<DownloadsModel>> get allDownloads => _downloadsFetcher.stream;

  getDownloads() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-downloads', Map());
    List<DownloadsModel> downloads = downloadsModelFromJson(response.body);
    _downloadsFetcher.sink.add(downloads);
  }

  dispose() {
    _downloadsFetcher.close();
  }
}
