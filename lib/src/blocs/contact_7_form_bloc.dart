import 'dart:async';
import './../models/contact_form.dart';
import './../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;


class ContactFormBloc {

  final api = ApiProvider();
  late int formId;
  final _formFetcher = BehaviorSubject<Contact7Form>();
  final _resultFetcher = BehaviorSubject<Contact7FormResult>();
  final _idController = StreamController<int>();
  final _loadingFetcher = BehaviorSubject<bool>();


  Sink<int> get id => _idController.sink;
  ValueStream<Contact7Form> get form => _formFetcher.stream;
  ValueStream<Contact7FormResult> get result => _resultFetcher.stream;
  ValueStream<bool> get loading => _loadingFetcher.stream;
  
  ContactFormBloc() {
    _idController.stream.listen((id) async {
      formId = id;
      fetchForm(id);
    });
  }

  fetchForm(id) async {
    final url = api.config.url + '/wp-json/contact-form-7/v1/contact-forms/'+ id.toString();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Contact7Form form = contact7FormFromJson(response.body);
      _formFetcher.sink.add(form);
    } else {
      _formFetcher.sink.addError(true);
      throw Exception('Failed to fetch form');
    }
  }

  submitForm(data) async {
    final url = '/wp-json/contact-form-7/v1/contact-forms/' + formId.toString() + '/feedback';
    _loadingFetcher.sink.add(true);
    final response = await api.post(url, data);
    _loadingFetcher.sink.add(false);
    if (response.statusCode == 200) {
      Contact7FormResult result = contact7FormResultFromJson(response.body);
      _resultFetcher.sink.add(result);
    } else if (response.statusCode == 404) {
      throw Exception(
        'Unexpected response from server: (${response.statusCode}) ${response.reasonPhrase}',
      );
    } else {
      Contact7FormResult result = contact7FormResultFromJson(response.body);
      _resultFetcher.sink.addError(result);
      throw Exception(
        'Unexpected response from server: (${response.statusCode}) ${response.reasonPhrase}',
      );
    }
  }

  dispose() {
    _formFetcher.close();
    _idController.close();
    _resultFetcher.close();
    _loadingFetcher.close();
  }
}