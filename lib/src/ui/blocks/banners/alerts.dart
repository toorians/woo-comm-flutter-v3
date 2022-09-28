import '../../../../src/blocs/alerts_bloc.dart';
import '../../../../src/functions.dart';
import '../../../../src/models/category_model.dart';
import 'package:flutter/material.dart';
import '../../../../src/models/fcm_details_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AlertsPage extends StatefulWidget {
  List<Category> categories;
  final alertsBloc = AlertsBloc();
  AlertsPage({Key? key, required this.categories}) : super(key: key);
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {

  late String selectedTopic;

  @override
  void initState() {
    fetchTopics();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerts')
      ),
      body: StreamBuilder<FcmDetails>(
        stream: widget.alertsBloc.fcmDetails,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data != null ? ListView(
            children: _buildList(snapshot.data!.topics),
          ) : Center(child: CircularProgressIndicator());
        }
      ),
    );
  }

  _buildList(List<String> topics) {
    List<Widget> list = [];
    widget.categories.forEach((element) {
      list.add(
          Column(
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                margin: EdgeInsets.all(0),
                child: SwitchListTile(
                    //contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    value: topics.contains(element.slug),
                    title: Text(parseHtmlString(element.name)),
                    //subtitle: element.description.isNotEmpty ? Text(parseHtmlString(element.description), maxLines: 2) : null,
                    onChanged: (bool value) {_onChanged(element, value);}
        ),
              ),
              Divider(height: 0)
            ],
          )
      );
    });

    return list;
  }

  void _onChanged(Category category, bool value) {
    if(value) {
      FirebaseMessaging.instance.subscribeToTopic(category.slug);
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic(category.slug);
    }
    widget.alertsBloc.updateTopics(category, value);
  }

  fetchTopics() {
    FirebaseMessaging.instance.getToken().then((String? token) {
      widget.alertsBloc.fetchTopics(token!);
    });
  }
}
