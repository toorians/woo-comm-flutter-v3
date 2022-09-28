import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/ui/widgets/buttons/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerification extends StatefulWidget {
  final String phoneNumber;
  final String prefixCode;
  const OTPVerification({Key? key, required this.phoneNumber, required this.prefixCode}) : super(key: key);
  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {

  late Timer _timer;
  int _start = 30;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;
  final appStateModel = AppStateModel();
  
  var onTapRecognizer;
  TextEditingController otpTextController = TextEditingController();
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };

    super.initState();
    sendOTP();
    startTimer();
  }

  @override
  void dispose() {
    errorController.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      appStateModel.blocks.localeText.verifyNumber,
                      style: TextStyle(
                          fontSize: 30,
                          //color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appStateModel.blocks.localeText.enterOtpThatWasSentTo, style: TextStyle(
                            //color: Colors.black,
                            fontSize: 15, height: 1.5)),
                        Text(widget.prefixCode + ' ' + widget.phoneNumber, style: TextStyle(
                            //color: Colors.black87,
                            fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                          child: SizedBox(
                            height: 90,
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v != null && v.length < 6) {
                                  //return appStateModel.blocks.localeText.pleaseEnterOtp;
                                  return null;
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                inactiveColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                inactiveFillColor: Colors.transparent,
                                disabledColor: Theme.of(context).disabledColor,
                                selectedColor: Theme.of(context).colorScheme.secondary,
                                activeColor: Theme.of(context).colorScheme.secondary,
                                selectedFillColor: isDark ? Colors.black : Colors.white,
                                shape: PinCodeFieldShape.box,
                                borderWidth: 1,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 45,
                                activeFillColor: isDark ? Colors.black : Colors.white,
                              ),
                              animationDuration: Duration(milliseconds: 300),
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              //backgroundColor: Colors.transparent,
                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: otpTextController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {

                              },
                              beforeTextPaste: (text) {
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                          )),
                    ),
                    Row(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: appStateModel.blocks.localeText.didNotReceiveCode,
                              style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 15),
                              children: [

                              ]),
                        ),
                        _start == 0 ? TextButton(onPressed: () {
                          setState(() {_start = 30;});
                          startTimer();
                          sendOTP();
                        }, child: Text(appStateModel.blocks.localeText.resendOTP, style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),)) : TextButton(onPressed: () {}, child: Text(_start.toString().padLeft(2, '0'), style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),),),
                      ],
                    ),

                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Center(
                            child: AccentButton(
                              onPressed: () {
                                if(formKey.currentState!.validate()) {
                                  if (otpTextController.text.length > 6) {
                                    errorController.add(ErrorAnimationType
                                        .shake); // Triggering error shake animation
                                    setState(() {
                                      hasError = true;
                                    });
                                  } else {
                                    setState(() {
                                      loginWithPhoneNumber(context);
                                    });
                                  }
                                }
                              },
                              showProgress: isLoading,
                              text: appStateModel.blocks.localeText.localeTextContinue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<void> sendOTP() async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: widget.prefixCode + widget.phoneNumber,
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
          codeSent: (String? verId, [int? forceCodeResend]) {
            verificationId = verId;
          },
          timeout: const Duration(seconds: 10),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            await _auth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {

          });
    } catch (e) {

    }
  }

  loginWithPhoneNumber(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var data = new Map<String, dynamic>();
    data["smsOTP"] = otpTextController.text;
    data["verificationId"] = verificationId;
    data["phoneNumber"] = widget.phoneNumber;
    bool status = await appStateModel.phoneLogin(data, context);
    if (status) {
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    }
    setState(() {
      isLoading = false;
    });
  }
}
