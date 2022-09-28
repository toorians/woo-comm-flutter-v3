import 'dart:io';
import 'package:app/src/blocs/login_bloc.dart';
import 'package:app/src/ui/accounts/login/logo.dart';
import 'package:app/src/ui/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../../ui/accounts/login/login2/bezierContainer.dart';
import './../../../../models/app_state_model.dart';
import './../../../../ui/accounts/login/login2/forgot_password.dart';
import './../../../../ui/accounts/login/login2/phone_number.dart';
import './../../../../ui/accounts/login/login2/register.dart';
import '../../../color_override.dart';

class Login2 extends StatefulWidget {
  final accountBloc = AccountBloc();
  @override
  _Login2State createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final appStateModel = AppStateModel();
  final _formKey = GlobalKey<FormState>();
  var formData = new Map<String, dynamic>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  late LinearGradient gradient;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Theme.of(context).primaryColorLight,
          Theme.of(context).primaryColorDark,
        ]);

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Builder(
      builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colors.black
            ),
          ),
          body: Builder(
            builder: (context) => Stack(
              children: [
                Positioned(
                  top: height * -.16,
                  //means -160 of total height; i.e above the screen
                  right: MediaQuery.of(context).size.width * -.45,
                  //means -40% of total width; i.e more than  right the screen
                  child: BezierContainer(),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        /*Lottie.asset(
                          'assets/images/intro/lottie3.json',
                          width: 220,
                          height: 220,
                        ),*/
                        Logo(),
                        PrimaryColorOverride(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appStateModel.blocks.localeText.username,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: usernameController,
                                onSaved: (value) => setState(
                                    () => formData['username'] = value),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return appStateModel.blocks.localeText
                                        .pleaseEnterUsername;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                  hintText: appStateModel
                                      .blocks.localeText.username,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        PrimaryColorOverride(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appStateModel.blocks.localeText.password,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: passwordController,
                                obscureText: true,
                                onSaved: (value) => setState(
                                    () => formData['password'] = value),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return appStateModel.blocks.localeText
                                        .pleaseEnterPassword;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                  hintText: appStateModel
                                      .blocks.localeText.password,
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        AccentButton(
                          onPressed: () => login(context),
                          text: appStateModel.blocks.localeText.signIn,
                          showProgress: isLoading,
                        ),
                        /*RoundedLoadingButton(
                          borderRadius: 30,
                          //elevation: 0,
                          child: Text(appStateModel.blocks.localeText.signIn),
                          controller: _btnController,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _submit(context);
                            }
                          },
                          animateOnTap: false,
                          width: MediaQuery.of(context).size.width - 34,
                        ),*/
                        SizedBox(height: 10.0),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Material(child: ForgotPassword())));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      appStateModel
                                          .blocks.localeText.forgotPassword,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              fontWeight: FontWeight.w500)),
                                ],
                              ),
                            )),
                        SizedBox(height: 10.0),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                      thickness: 1,
                                      color: Colors.grey.shade300),
                                ),
                              ),
                              Text('or'),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                      thickness: 1,
                                      color: Colors.grey.shade300),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if(appStateModel.blocks.settings.googleLogin)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 50.0, // height of the button
                                  width: 50.0,
                                  child: Card(
                                    shape: StadiumBorder(),
                                    margin: EdgeInsets.all(0),
                                    child: Center(
                                      child: IconButton(
                                        splashRadius: 25.0,
                                        splashColor: Colors.transparent,
                                        icon: Icon(
                                          FontAwesomeIcons.google,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          bool status = await widget.accountBloc.signInWithGoogle(context);
                                          if (status) {
                                            Navigator.popUntil(
                                                context, ModalRoute.withName(Navigator.defaultRouteName));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if(appStateModel.blocks.settings.fbLogin)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: StadiumBorder(),
                                  margin: EdgeInsets.all(0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: IconButton(
                                      splashRadius: 25.0,
                                      icon: Icon(
                                        FontAwesomeIcons.facebookF,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        bool status = await widget.accountBloc.signInWithFacebook(context);
                                        if (status) {
                                          Navigator.popUntil(
                                              context, ModalRoute.withName(Navigator.defaultRouteName));
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              if(appStateModel.blocks.settings.fbLogin && Platform.isIOS)
                              Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shape: StadiumBorder(),
                                        margin: EdgeInsets.all(0),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          child: IconButton(
                                            splashRadius: 25.0,
                                            icon: Icon(
                                              FontAwesomeIcons.apple,
                                              size: 20,
                                            ),
                                            onPressed: () async {
                                              bool status = await widget.accountBloc.signInWithApple(context);
                                              if (status) {
                                                Navigator.popUntil(
                                                    context, ModalRoute.withName(Navigator.defaultRouteName));
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                              if(appStateModel.blocks.settings.otpLogin)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: StadiumBorder(),
                                  margin: EdgeInsets.all(0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: IconButton(
                                      splashRadius: 25.0,
                                      icon: Icon(
                                        FontAwesomeIcons.sms,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => PhoneLogin(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextButton(
                            //padding: EdgeInsets.all(16.0),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Material(child: Register(accountBloc: widget.accountBloc))));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    appStateModel
                                        .blocks.localeText.dontHaveAnAccount,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          fontSize: 15,
                                        )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                      appStateModel.blocks.localeText.signUp,
                                      /*style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .buttonColor,
                                              fontWeight: FontWeight.w500)*/),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
                ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                  if (model.loginLoading) {
                    return Center(
                      child: Dialog(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          child: Wrap(
                            children: [
                              new Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new CircularProgressIndicator(),
                                  SizedBox(
                                    width: 24,
                                  ),
                                  new Text(appStateModel
                                      .blocks.localeText.pleaseWait),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future login(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      var loginData = new Map<String, dynamic>();
      loginData["username"] = usernameController.text;
      loginData["password"] = passwordController.text;
      _formKey.currentState!.save();
      bool status = await widget.accountBloc.login(context, loginData);
      if (status) {
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
      }
      return status;
    }
  }

}
