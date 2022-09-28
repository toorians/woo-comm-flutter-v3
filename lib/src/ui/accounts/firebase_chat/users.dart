import 'package:app/src/ui/accounts/firebase_chat/chat_room.dart';
import 'package:app/src/ui/accounts/firebase_chat/firebase_chat_core.dart';
import 'package:app/src/ui/accounts/firebase_chat/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';

class UsersPage extends StatelessWidget {
  UsersPage({Key? key}) : super(key: key);

  DateFormat dateFormat = DateFormat('dd-MM-yy  hh:mm a');

  void _handlePressed(types.User otherUser, BuildContext context) async {

    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    Navigator.of(context).pop();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatRoomPage(
          room: room,
        ),
      ),
    );
  }

  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = getUserName(user);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
          name.isEmpty ? '' : name[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Users'),
      ),
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No users'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];

              return ListTile(
                onTap: () {
                  _handlePressed(user, context);
                },
                title: Text(getUserName(user)),
                subtitle: user.lastSeen != null ? Text(dateFormat.format(DateTime.fromMillisecondsSinceEpoch(user.lastSeen!))) : null,
                leading: _buildAvatar(user),
              );

            },
          );
        },
      ),
    );
  }
}
