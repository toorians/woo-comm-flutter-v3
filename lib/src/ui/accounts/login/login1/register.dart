import 'package:app/src/blocs/login_bloc.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/ui/accounts/login/login1/loading_button.dart';
import 'package:app/src/ui/accounts/login/logo.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final AccountBloc accountBloc;
  const RegisterPage({Key? key, required this.accountBloc}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

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
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16.0),
            const Logo(),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: firstNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return appStateModel.blocks.localeText.pleaseEnterFirstName;
                }
                return null;
              },
              decoration: InputDecoration(labelText: appStateModel.blocks.localeText.firstName),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: lastNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return appStateModel.blocks.localeText.pleaseEnterLastName;
                }
                return null;
              },
              decoration: InputDecoration(labelText: appStateModel.blocks.localeText.lastName),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return appStateModel.blocks.localeText.pleaseEnterValidEmail;
                }
                return null;
              },
              decoration: InputDecoration(labelText: appStateModel.blocks.localeText.email),
              keyboardType: TextInputType.emailAddress,
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
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }
                  ),
                  labelText: appStateModel.blocks.localeText.password),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            LoadingButton(onPressed: () => register(context), text: appStateModel.blocks.localeText.signUp),
            const SizedBox(height: 16),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        appStateModel.blocks.localeText
                            .alreadyHaveAnAccount,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 15)),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                          appStateModel.blocks.localeText.signIn),
                    ),
                  ],
                )),
            const SizedBox(height: 16),
          ],
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
