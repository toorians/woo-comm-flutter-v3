import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class BlocksBloc {

  final apiProvider = ApiProvider();
  final _blockFetcher = BehaviorSubject<List<Block>>();

  ValueStream<List<Block>> get allBlocks => _blockFetcher.stream;

  getBlocks(String linkId) async {
    final response = await apiProvider.adminAjax({'action': 'build-app-online-block', 'id': linkId});
    if(response.statusCode == 200) {
      List<Block> blocks = blockFromJson(response.body);
      _blockFetcher.sink.add(blocks);
    } else {
      _blockFetcher.sink.add([]);
    }
  }

  dispose() {
    _blockFetcher.close();
  }
}
