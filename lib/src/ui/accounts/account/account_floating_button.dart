import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/models/vendor/store_model.dart';
import 'package:app/src/resources/get_icon.dart';
import 'package:app/src/ui/accounts/firebase_chat/chat.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../models/app_state_model.dart';
import '../../../ui/accounts/login/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountFloatingButton extends StatelessWidget {
  final String? page;
  final model = AppStateModel();

  AccountFloatingButton({Key? key, this.page}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    if(model.blocks.settings.floatingButtons.any((element) => element.parent == page)) {
      Child child = model.blocks.settings.floatingButtons.firstWhere((element) => element.parent == page);
      return FloatingActionButton(
          onPressed: () => onItemClick(child, context),
          tooltip: child.title,
          child: Icon(baoIconList.firstWhere((element) => element.label == child.leading).icon)
      );
    } else if(model.blocks.settings.chatType == 'whatsapp') {
      return FloatingActionButton(
        backgroundColor: Color(0xFF128C7E),
        onPressed: () => _launch('https://wa.me/' + model.blocks.settings.whatsapp),
        tooltip: 'Chat',
        child: Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
      );
    } else if(model.blocks.settings.chatType == 'call') {
      return FloatingActionButton(
        onPressed: () => _launch('tel:' + model.blocks.settings.phoneNumber),
        tooltip: 'Chat',
        child: Icon(FontAwesomeIcons.phone),
      );
    } if(model.blocks.settings.chatType == 'message') {
      return FloatingActionButton(
        onPressed: () => _launch('sms:' + model.blocks.settings.phoneNumber),
        tooltip: 'Chat',
        child: Icon(Icons.chat_bubble),
      );
    } if(model.blocks.settings.chatType == 'mail') {
      return FloatingActionButton(
        onPressed: () => _launch('mailto:' + model.blocks.settings.email),
        tooltip: 'Chat',
        child: Icon(Icons.email),
      );
    } if(model.blocks.settings.chatType == 'messenger') {
      return FloatingActionButton(
        backgroundColor: Color(0xFF00B2FF),
        onPressed: () => _launch('https://m.me/' + model.blocks.settings.fbPageName),
        tooltip: 'Chat',
        child: Icon(FontAwesomeIcons.facebookMessenger, color: Colors.white),
      );
    } if(model.blocks.settings.chatType == 'firebaseChat') {
      return FloatingActionButton(
        onPressed: () => _fireBaseChat(context),
        tooltip: 'Chat',
        child: Icon(Icons.chat_bubble),
      );
    } if(model.blocks.settings.chatType == 'circular') {
      return FabCircularMenu(
          fabOpenColor: secondary,
          fabCloseColor: secondary,
          fabOpenIcon: Icon(
            Icons.chat_bubble,
            color: onSecondary,
          ),
          fabMargin: EdgeInsets.all(12),
          fabCloseIcon: Icon(
            Icons.close,
            color: onSecondary,
          ),
          //child: Container(),
          ringColor: secondary,
          ringDiameter: 250.0,
          ringWidth: 100.0,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.chat_bubble,
                  color: onSecondary,
                ),
                onPressed: () => _fireBaseChat(context),
                iconSize: 20.0,
                color: Colors.black),
            if(model.blocks.settings.email.isNotEmpty)
              IconButton(
                  icon: Icon(
                    Icons.mail,
                    color: onSecondary,
                  ),
                  onPressed: () {
                    _launch('mailto:'+model.blocks.settings.email);
                  },
                  iconSize: 20.0,
                  color: Colors.black),
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: onSecondary,
                ),
                onPressed: () => _launch('https://wa.me/' + model.blocks.settings.phoneNumber),
                iconSize: 20.0,
                color: Colors.black),
            IconButton(
                icon: Icon(
                  Icons.call,
                  color: onSecondary,
                ),
                onPressed: () {
                  _launch('tel:' + model.blocks.settings.phoneNumber);
                },
                iconSize: 20.0,
                color: Colors.black),
          ]);
    } else return Container();
  }

  _launch(url) async {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    //canLaunch not working for some android device
    /*if (await canLaunch(url)) {
      await launchUri(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }*/
  }

  _fireBaseChat(BuildContext context) {
    if (model.user.id > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FireBaseChat(otherUserId: model.blocks.siteSettings.adminUIDs.first)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Login()));
    }
  }
}

class VendorFloatingButton extends StatelessWidget {
  final String email;
  final String whatsapp;
  final String phoneNumber;
  final StoreModel store;
  final model = AppStateModel();
  VendorFloatingButton({Key? key, required this.email, required this.whatsapp, required this.phoneNumber, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(model.blocks.settings.vendorChatType == 'whatsapp') {
      return FloatingActionButton(
        backgroundColor: Color(0xFF128C7E),
        onPressed: () => _launch('https://wa.me/' + whatsapp),
        tooltip: 'Chat',
        child: Icon(FontAwesomeIcons.whatsapp),
      );
    } else if(model.blocks.settings.vendorChatType == 'call') {
      return FloatingActionButton(
        onPressed: () => _launch('tel:' + phoneNumber),
        tooltip: 'Chat',
        child: Icon(FontAwesomeIcons.phone),
      );
    } if(model.blocks.settings.vendorChatType == 'message') {
      return FloatingActionButton(
        onPressed: () => _launch('sms:' + phoneNumber),
        tooltip: 'Chat',
        child: Icon(Icons.chat_bubble),
      );
    } if(model.blocks.settings.vendorChatType == 'mail') {
      return FloatingActionButton(
        onPressed: () => _launch('mailto:' + email),
        tooltip: 'Chat',
        child: Icon(Icons.email),
      );
    } if(model.blocks.settings.vendorChatType == 'messenger') {
      return FloatingActionButton(
        backgroundColor: Color(0xFF00B2FF),
        onPressed: () => _launch('https://m.me/' + model.blocks.settings.fbPageName),
        tooltip: 'Chat',
        child: Icon(FontAwesomeIcons.facebookMessenger),
      );
    } if(model.blocks.settings.vendorChatType == 'firebaseChat' && store.UID != null) {
      return FloatingActionButton(
        onPressed: () => _fireBaseChat(context),
        tooltip: 'Chat',
        child: Icon(Icons.chat_bubble),
      );
    } if(model.blocks.settings.vendorChatType == 'circular') {
      return Container();
    } else return Container();
  }

  _launch(url) async {
    launchUrl(Uri.parse(url));
    //canLaunch not working for some android device
    /*if (await canLaunch(url)) {
      await launchUri(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }*/
  }

  _fireBaseChat(BuildContext context) {
    if (model.user.id > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FireBaseChat(otherUserId: store.UID!)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Login()));
    }
  }
}
