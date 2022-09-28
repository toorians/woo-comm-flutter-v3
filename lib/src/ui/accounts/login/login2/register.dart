import 'package:app/src/blocs/login_bloc.dart';
import 'package:app/src/ui/accounts/login/logo.dart';
import 'package:app/src/ui/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './../../../../ui/accounts/login/login2/bezierContainer.dart';
import './../../../../models/app_state_model.dart';
import './../../../../ui/color_override.dart';


class Register extends StatefulWidget {
  final AccountBloc accountBloc;
  const Register({Key? key, required this.accountBloc});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;
  AppStateModel appStateModel = AppStateModel();

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
                                appStateModel.blocks.localeText.firstName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: firstNameController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return appStateModel.blocks.localeText.pleaseEnterFirstName;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                  hintText: appStateModel
                                      .blocks.localeText.firstName,
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
                                appStateModel.blocks.localeText.lastName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: lastNameController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return appStateModel.blocks.localeText.pleaseEnterLastName;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                  hintText: appStateModel
                                      .blocks.localeText.lastName,
                                ),
                                keyboardType: TextInputType.text,
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
                                appStateModel.blocks.localeText.email,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: usernameController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return appStateModel.blocks.localeText.pleaseEnterValidEmail;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: appStateModel.blocks.localeText.email,
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
                                obscureText: _obscureText,
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return appStateModel.blocks.localeText.pleaseEnterPassword;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                  hintText: appStateModel
                                      .blocks.localeText.password,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        AccentButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              register(context);
                            }
                          },
                          text: appStateModel.blocks.localeText.signUp,
                          showProgress: isLoading,
                        ),
                        /*RoundedLoadingButton(
                          borderRadius: 30,
                          child: Text(appStateModel.blocks.localeText.signUp, style: TextStyle(color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .onPrimary),),
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
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(appStateModel.blocks.localeText.alreadyHaveAnAccount,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          fontSize: 15,
                                        )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(appStateModel.blocks.localeText.signIn),
                                ),
                              ],
                            )),
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

  Future register(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var register = <String, dynamic>{};
      register["username"] = usernameController.text;
      register["email"] = usernameController.text;
      register["password"] = passwordController.text;
      register["first_name"] = firstNameController.text;
      register["last_name"] = lastNameController.text;
      bool status = await widget.accountBloc.register(context, register);
      if (status) {
        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
      }
      return status;
    }
  }
}
