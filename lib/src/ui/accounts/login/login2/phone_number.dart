import 'package:app/src/ui/accounts/login/logo.dart';
import 'package:app/src/ui/widgets/buttons/button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import './../../../../ui/accounts/login/login2/bezierContainer.dart';
import './../../../../ui/color_override.dart';
import './../../../../models/app_state_model.dart';
import 'otp_verification.dart';
import 'theme_override.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  String prefixCode = '+91';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String verificationId;
  final appStateModel = AppStateModel();
  TextEditingController phoneNumberController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  @override
  void initState() {
    prefixCode = appStateModel.blocks.settings.dialCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
            builder: (context) => Stack(children: [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CountryCodePicker(
                            onChanged: _onCountryChange,
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: appStateModel
                                .blocks.siteSettings.defaultCountry,
                            favorite: [
                              prefixCode,
                              appStateModel.blocks.siteSettings.defaultCountry
                            ],
                            // optional. Shows only country name and flag
                            showCountryOnly: false,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: PrimaryColorOverride(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    /*Text(
                                      appStateModel.blocks.localeText.pleaseEnterPhoneNumber,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),*/
                                    TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      obscureText: false,
                                      controller: phoneNumberController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return appStateModel
                                              .blocks
                                              .localeText
                                              .pleaseEnterPhoneNumber;
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: appStateModel.blocks
                                              .localeText.phoneNumber),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ]),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 24),
                      AccentButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            sendOTP(context);
                          }
                        },
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            sendOTP(context);
                          }
                        },
                        animateOnTap: false,
                        width: MediaQuery.of(context).size.width - 34,
                      ),*/
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      prefixCode = countryCode.toString();
    });
  }

  onOTPSent(String verificationId) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Material(
            child: OTPVerification(
                verificationId: verificationId,
                phoneNumber:
                    prefixCode + phoneNumberController.text.toString()))));
    //TODO Navigate to OTP Verification Page
  }

  onVerificationCompleted(AuthCredential phoneAuthCredential) {
    //TODO Wordpress Login User
  }

  Future<void> sendOTP(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: prefixCode + phoneNumberController.text.toString(),
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
            //onOTPSent(verId, phoneController.text);
          },
          codeSent: (String? verId, [int? forceCodeResend]) {
            setState(() {
              isLoading = false;
            });
            onOTPSent(verId!);
          },
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            onVerificationCompleted(phoneAuthCredential);
            await _auth.signInWithCredential(phoneAuthCredential);
            setState(() {
              isLoading = false;
            });
          },
          verificationFailed: (exception) {
            handlePhoneNumberError(exception, context);
            setState(() {
              isLoading = false;
            });
          });
    } catch (e) {
      handleOtpError(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  handleOtpError(error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        showSnackBar(context, appStateModel.blocks.localeText.inValidCode);
        break;
      default:
        showSnackBar(context, appStateModel.blocks.localeText.inValidCode);
        break;
    }
  }

  verifyOTP(String smsCode, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      await _auth.signInWithCredential(phoneAuthCredential);
      //Wordpress Login user with
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, appStateModel.blocks.localeText.inValidCode);
    }
    setState(() {
      isLoading = false;
    });
  }

  handlePhoneNumberError(FirebaseAuthException error, BuildContext context) {
    switch (error.code) {
      case 'TOO_LONG':
        FocusScope.of(context).requestFocus(new FocusNode());
        showSnackBar(context, appStateModel.blocks.localeText.inValidNumber);
        break;
      case 'TOO_SHORT':
        FocusScope.of(context).requestFocus(new FocusNode());
        showSnackBar(context, appStateModel.blocks.localeText.inValidNumber);
        break;
      case 'SESSION_EXPIRED':
        showSnackBar(context, appStateModel.blocks.localeText.message);
        break;
      case 'INVALID_SESSION_INFO':
        showSnackBar(context, appStateModel.blocks.localeText.message);
        break;
      default:
        showSnackBar(context, appStateModel.blocks.localeText.message);
        break;
    }
  }

  showSnackBar(BuildContext context, String message) {
    //Fluttertoast.showToast(msg: message, gravity: ToastGravity.TOP);

    final snackBar =
        SnackBar(backgroundColor: Colors.red, content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
