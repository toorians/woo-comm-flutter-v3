import 'dart:async';
import 'dart:io';
import 'package:app/src/blocs/login_bloc.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/ui/accounts/login/login1/loading_button.dart';
import 'package:app/src/ui/accounts/login/login1/phone_number.dart';
import 'package:app/src/ui/accounts/login/login1/register.dart';
import 'package:app/src/ui/accounts/login/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  final accountBloc = AccountBloc();
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.accountBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          //physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16.0),
            const Logo(),
            const SizedBox(height: 16.0),
              TextFormField(
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appStateModel.blocks.localeText.pleaseEnterUsername;
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: appStateModel.blocks.localeText.username),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: _obscureText,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appStateModel.blocks.localeText.pleaseEnterPassword;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        }),
                    labelText: appStateModel.blocks.localeText.password),
              ),
              const SizedBox(height: 24),
              LoadingButton(onPressed: () => login(context), text: appStateModel.blocks.localeText.signIn),
              const SizedBox(height: 12),
              TextButton(onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Material(child: ForgotPassword())));
              }, child: Text(
                  appStateModel.blocks.localeText.forgotPassword,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 15,
                  ))),
              TextButton(onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Material(child: RegisterPage(accountBloc: widget.accountBloc))));
              }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      appStateModel.blocks.localeText.dontHaveAnAccount,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 15,
                      )),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                        appStateModel.blocks.localeText.signUp),
                  ),
                ],
              )),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(Platform.isIOS && appStateModel.blocks.settings.appleLogin)
                  IconButton(
                      onPressed: () async {
                        bool status = await widget.accountBloc.signInWithApple(context);
                        if (status) {
                          Navigator.popUntil(
                              context, ModalRoute.withName(Navigator.defaultRouteName));
                        }
                      },
                      icon: const Icon(FontAwesomeIcons.apple)),
                if(appStateModel.blocks.settings.googleLogin)
                  IconButton(
                      onPressed: () async {
                        bool status =await widget.accountBloc.signInWithGoogle(context);
                        if (status) {
                          Navigator.popUntil(
                              context, ModalRoute.withName(Navigator.defaultRouteName));
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        color: Color(0xFFEA4335),
                      )),
                if(appStateModel.blocks.settings.otpLogin)
                  IconButton(
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PhoneLogin(),
                          ),
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.commentSms,
                        color: Color(0xFF34B7F1),
                      )),
                if(appStateModel.blocks.settings.fbLogin)
                  IconButton(
                      onPressed: () async {
                        bool status =await widget.accountBloc.signInWithFacebook(context);
                        if (status) {
                          Navigator.popUntil(
                              context, ModalRoute.withName(Navigator.defaultRouteName));
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.facebook,
                        color: Color(0xFF3b5998),
                      )),
              ],
            ),
            StreamBuilder<bool>(
                stream: widget.accountBloc.socialLoginLoading,
                builder: (context, snapshot) {
                  return snapshot.data == true ? Dialog(
                    elevation: 4,
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
                  ) : Container();
                }
            )
          ],
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

class SocialLoginPage extends StatefulWidget {
  final accountBloc = AccountBloc();
  SocialLoginPage({Key? key}) : super(key: key);

  @override
  State<SocialLoginPage> createState() => _SocialLoginPageState();
}

class _SocialLoginPageState extends State<SocialLoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.accountBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          //physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16.0),
            const AppLogo(size: 128),
            const SizedBox(height: 4.0),
            if(Platform.isIOS)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: isDark ? Colors.white : Colors.black, onPrimary: isDark ? Colors.black : Colors.white),
                onPressed: () async {
                  bool status = await widget.accountBloc.signInWithApple(context);
                  if (status) {
                    Navigator.popUntil(
                        context, ModalRoute.withName(Navigator.defaultRouteName));
                  }
                },
                icon: const Icon(FontAwesomeIcons.apple),
                label: Text('Apple Login'),
              ),
            const SizedBox(height: 4.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Color(0xFFEA4335), onPrimary: Colors.white),
              onPressed: () async {
                bool status =await widget.accountBloc.signInWithGoogle(context);
                if (status) {
                  Navigator.popUntil(
                      context, ModalRoute.withName(Navigator.defaultRouteName));
                }
              },
              icon: const Icon(
                FontAwesomeIcons.google,
              ),
              label: Text('Google Login'),
            ),
            const SizedBox(height: 4.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Color(0xFF34B7F1), onPrimary: Colors.white),
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PhoneLogin(),
                  ),
                );
              },
              icon: const Icon(
                FontAwesomeIcons.commentSms,
              ),
              label: Text('SMS Login'),
            ),
            const SizedBox(height: 4.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Color(0xFF3b5998), onPrimary: Colors.white),
              onPressed: () async {
                // UserCredential userCredential = await signInWithApple();
              },
              icon: const Icon(
                FontAwesomeIcons.facebook,
              ),
              label: Text('Facebook Login'),
            ),
          ],
        ),
      ),
    );
  }
}

