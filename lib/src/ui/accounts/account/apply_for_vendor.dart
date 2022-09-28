import 'package:flutter/material.dart';
import '../../../config.dart';
import '../../../models/app_state_model.dart';
import '../../../models/register_model.dart';
import '../../widgets/buttons/button.dart';
import '../../color_override.dart';


class ApplyForVendor extends StatefulWidget {
  @override
  _ApplyForVendorState createState() => _ApplyForVendorState();
}

class _ApplyForVendorState extends State<ApplyForVendor> {

  final appStateModel = AppStateModel();
  RegisterModel _register = RegisterModel();
  bool _obscureText = true;
  var isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController shopUrlController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) => ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 15.0),
              Container(
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                child:  Form(
                  key: _formKey,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                        child: Container(
                          constraints: BoxConstraints(minWidth: 120, maxWidth: 220),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                        Column(
                          children: [
                            PrimaryColorOverride(
                              child: TextFormField(
                                onSaved: (val) =>
                                    setState(() {
                                      if(val != null)
                                      _register.shopName = val;
                                    }),
                                validator: (value) {
                                  if (value != null  && value.isEmpty) {
                                    return 'Please enter shop name';
                                  }
                                  return null;
                                },
                                onChanged: (val) =>
                                    setState(() {
                                      shopUrlController.text = val.toLowerCase().replaceAll(' ', '');
                                    }),
                                decoration: InputDecoration(labelText: 'Shop Name'),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            PrimaryColorOverride(
                              child: TextFormField(
                                controller: shopUrlController,
                                onSaved: (val) =>
                                    setState(() {
                                      if(val != null)
                                      _register.shopURL = val;
                                    }),
                                validator: (value) {
                                  if (value != null  && value.isEmpty) {
                                    return 'Please enter shop url';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(labelText: 'Shop Url'),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Align(
                                alignment: Alignment.centerLeft, child: Text(Config().url + '/' + shopUrlController.text, textAlign: TextAlign.left,)
                            ),
                            SizedBox(height: 12.0),
                            PrimaryColorOverride(
                              child: TextFormField(
                                onSaved: (val) =>
                                    setState(() {
                                      if(val != null)
                                      _register.phoneNumber = val;
                                    }),
                                validator: (value) {
                                  if (value != null  && value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(labelText: 'Phone Number'),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 30.0),
                      AccentButton(
                        onPressed: () => _submit(context),
                        text: appStateModel.blocks.localeText.signUp,
                        showProgress: isLoading,
                      ),
                      SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ),
            ]),
      )
    );
  }

  Future _submit(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      bool status = await appStateModel.applyVendor(_register.toJson(), context);
      setState(() {
        isLoading = false;
      });
      if (status) {
        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
      }
    }
  }

}
