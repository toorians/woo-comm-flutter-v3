import 'dart:convert';
import 'package:app/src/ui/accounts/login/logo.dart';
import 'package:app/src/ui/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import './../../../../ui/accounts/login/login2/bezierContainer.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/errors/error.dart';
import './../../../../resources/api_provider.dart';
import '../../../../functions.dart';
import '../../../color_override.dart';
import 'theme_override.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final appStateModel = AppStateModel();
  TextEditingController emailController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final apiProvider = ApiProvider();
  /*final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();*/

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                //means -150 of total height; i.e above the screen
                right: MediaQuery.of(context).size.width * -.45,
                //means -40% of total width; i.e more than  right the screen
                child: BezierContainer(),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
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
                              appStateModel.blocks.localeText.email,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              style: TextStyle(color: Colors.black),
                              obscureText: false,
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appStateModel.blocks.localeText
                                      .pleaseEnterValidEmail;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText:
                                      appStateModel.blocks.localeText.email),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      AccentButton(
                        onPressed: () => _sendOtp(context),
                        text: appStateModel.blocks.localeText.sendOtp,
                        showProgress: isLoading,
                      ),
                      /*RoundedLoadingButton(
                        borderRadius: 30,
                        child: Text(appStateModel.blocks.localeText.sendOtp, style: TextStyle(color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .onPrimary),),
                        controller: _btnController,
                        onPressed: () => _sendOtp(context),
                        animateOnTap: false,
                        width: MediaQuery.of(context).size.width - 34,
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  _sendOtp(BuildContext context) async {
    var data = new Map<String, dynamic>();
    if (_formKey.currentState!.validate()) {
      data["email"] = emailController.text;
      setState(() {
        isLoading =true;
      });
      final response = await apiProvider.postWithCookies(
          '/wp-admin/admin-ajax.php?action=build-app-online-email-otp', data);
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Material(
                    child: ResetPassword(
                  email: emailController.text,
                ))));
      } else if (response.statusCode == 400) {
        WpErrors error = WpErrors.fromJson(json.decode(response.body));
        showSnackBarError(context, parseHtmlString(error.data[0].message));
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}

class ResetPassword extends StatefulWidget {
  ResetPassword({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final appStateModel = AppStateModel();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final apiProvider = ApiProvider();
  bool _obscureText = true;

  TextEditingController otpController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  /*final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();*/

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                  //means -150 of total height; i.e above the screen
                  right: MediaQuery.of(context).size.width * -.45,
                  //means -40% of total width; i.e more than  right the screen
                  child: BezierContainer(),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: new Form(
                    key: _formKey,
                    child: new ListView(
                      children: <Widget>[
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
                                  appStateModel.blocks.localeText.enterOtp,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  obscureText: false,
                                  controller: otpController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return appStateModel
                                          .blocks.localeText.pleaseEnterOtp;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        appStateModel.blocks.localeText.otp,
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        PrimaryColorOverride(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appStateModel.blocks.localeText.newPassword,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  obscureText: _obscureText,
                                  controller: newPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return appStateModel.blocks.localeText
                                          .pleaseEnterPassword;
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
                                      hintText: appStateModel
                                          .blocks.localeText.newPassword),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        AccentButton(
                          onPressed: () => _resetPassword(context),
                          text: appStateModel.blocks.localeText.signIn,
                          showProgress: isLoading,
                        ),
                        /*RoundedLoadingButton(
                          borderRadius: 30,
                          child: Text(appStateModel.blocks.localeText.resetPassword, style: TextStyle(color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .onPrimary),),
                          controller: _btnController,
                          onPressed: () => _resetPassword(context),
                          animateOnTap: false,
                          width: MediaQuery.of(context).size.width - 34,
                        ),*/
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _resetPassword(BuildContext context) async {
    var data = new Map<String, dynamic>();
    if (_formKey.currentState!.validate()) {
      data["email"] = widget.email;
      data["password"] = newPasswordController.text;
      data["otp"] = otpController.text;
      setState(() {
        isLoading = true;
      });
      final response = await apiProvider.postWithCookies(
          '/wp-admin/admin-ajax.php?action=build-app-online-reset-user-password',
          data);
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        int count = 0;
        Navigator.popUntil(context, (route) {
          return count++ == 2;
        });
      } else {
        WpErrors error = WpErrors.fromJson(json.decode(response.body));
        showSnackBarError(context, parseHtmlString(error.data[0].message));
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
