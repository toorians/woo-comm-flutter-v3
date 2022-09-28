import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Listens for incoming foreground messages and displays them in a list.
class MessageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MessageList();
}

class _MessageList extends State<MessageList> {
  List<RemoteMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _messages = [..._messages, message];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: _messages.isEmpty ? Center(
          child: const Text('No messages received')) : ListView.builder(
          shrinkWrap: true,
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            RemoteMessage message = _messages[index];
            return message.notification != null ? ListTile(
              title: Text(message.notification!.title!),
              subtitle: Row(
                children: [
                  Text(message.notification!.body!),
                  Text(message.sentTime?.toString() ?? 'N/A'),
                ],
              ),
              onTap: () {},
            ) : Container();
          }),
    );
  }
}
