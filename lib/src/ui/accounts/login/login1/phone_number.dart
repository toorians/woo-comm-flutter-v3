import 'package:app/src/blocs/login_bloc.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:app/src/ui/accounts/login/login1/otp_verification.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneLogin extends StatefulWidget {
  final accountBloc = AccountBloc();
  PhoneLogin({Key? key}) : super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {

  String prefixCode = '+91';
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = new TextEditingController();
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    prefixCode = appStateModel.blocks.settings.dialCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    appStateModel.blocks.localeText.signIn,
                    style: const TextStyle(
                        fontSize: 30,
                        //color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    //cursorHeight: 18,
                    controller: phoneNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appStateModel
                            .blocks.localeText.pleaseEnterPhoneNumber;
                      }
                      return null;
                    },
                    autofocus: true,
                    style: const TextStyle(
                      //fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      labelText: appStateModel.blocks.localeText.phoneNumber,
                      hintText: appStateModel.blocks.settings.phoneNumber,
                      hintStyle:  const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          //color: Colors.black38
                      ),
                      prefix: CountryCodePicker(
                        padding: EdgeInsets.zero,
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            //color: Colors.black
                        ),
                        onChanged: _onCountryChange,
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: appStateModel.blocks.siteSettings.defaultCountry,
                        favorite: [prefixCode, appStateModel.blocks.siteSettings.defaultCountry],
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ) ,
                      labelStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          //color: Colors.black38
                      ),),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if(_formKey.currentState!.validate()) {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPVerification(phoneNumber: phoneNumberController.text, prefixCode: prefixCode, accountBloc: widget.accountBloc)));
                            }
                          },
                          child: Text(appStateModel.blocks.localeText.localeTextContinue),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      prefixCode = countryCode.toString();
    });
  }
}
