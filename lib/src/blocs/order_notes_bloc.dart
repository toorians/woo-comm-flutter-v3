import '../blocs/vendor/vendor_bloc.dart';
import '../models/order_notes_model.dart';
import '../resources/wc_api.dart';
import 'package:rxdart/rxdart.dart';

class OrderNotesBloc {
  var filter = new Map<String, dynamic>();
  int page = 0;
  bool hasMoreItems = true;
  late String orderId;

  static WooCommerceAPI wc_api = new WooCommerceAPI();

  final _notesFetcher = BehaviorSubject<List<OrderNote>>();

  ValueStream<List<OrderNote>> get allNotes => _notesFetcher.stream;

  fetchItems() async {
    filter['page'] = page + 1;
    final response = await wc_api.getAsync("orders/" + orderId + "/notes" + getQueryString(filter));
    if(response.statusCode == 200) {
      List<OrderNote> notes = orderNoteFromJson(response.body);
      _notesFetcher.sink.add(notes);
      hasMoreItems = notes.length > 0;
    } else {
      _notesFetcher.sink.add([]);
    }

  }

  dispose() {
    _notesFetcher.close();
  }

}