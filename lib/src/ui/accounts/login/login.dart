import 'package:app/src/ui/accounts/login/login1/login.dart';
import 'package:app/src/ui/accounts/login/login1/phone_number.dart';
import 'package:app/src/ui/accounts/login/login2/login.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../models/app_state_model.dart';

//import 'otp_login/phone_number.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (model.blocks.settings.pageLayout.login == 'layout1') {
            return LoginPage();
          } else if (model.blocks.settings.pageLayout.login == 'layout2') {
            return PhoneLogin();
          } else if (model.blocks.settings.pageLayout.login == 'layout4') {
            return Login2();
          } else if (model.blocks.settings.pageLayout.login == 'layout5') {
            return LoginPage();
          } else if (model.blocks.settings.pageLayout.login == 'layout7') {
            return LoginPage();
          } else {
            return LoginPage();
          }
        });
  }
}


