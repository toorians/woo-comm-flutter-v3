import 'package:app/src/ui/accounts/firebase_chat/chat_room.dart';
import 'package:app/src/ui/accounts/firebase_chat/firebase_chat_core.dart';
import 'package:app/src/ui/accounts/login/login1/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class FireBaseChat extends StatefulWidget {
  final String otherUserId;
  const FireBaseChat({Key? key, required this.otherUserId}) : super(key: key);

  @override
  State<FireBaseChat> createState() => _FireBaseChatState();
}

class _FireBaseChatState extends State<FireBaseChat> {

  bool _error = false;
  bool _initialized = false;
  User? _user;
  types.User? _otherUser;
  types.Room? room;
  String _userId = '10';

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            bottom: 200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Not authenticated'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => SocialLoginPage(),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    } else if (room != null) {
      return ChatRoomPage(room: room!);
    } else {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> initializeFlutterFire() async {

    try {

      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });

      //TODO replace id with widget.otherUserId after testing
      _otherUser = await FirebaseChatCore.instance.user(widget.otherUserId);

      if(_otherUser != null) {
        room = await FirebaseChatCore.instance.createRoom(_otherUser!);
      } else {
        //Chat not possible unless other user create account in firebase and update firebase uid in wordpress database
        //TODO Show error message
      }

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

}

