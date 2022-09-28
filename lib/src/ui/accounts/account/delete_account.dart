import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/ui/checkout/payment/loading_button.dart';
import 'package:flutter/material.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {

  final model = AppStateModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Text(model.blocks.localeText.deleteAccountMessage, textAlign: TextAlign.center, style: Theme.of(context).textTheme.caption),
              SizedBox(height: 16),
              LoadingButton(
                  onPressed: () => _deleteAccount(),
                  text: model.blocks.localeText.deleteAccount,

              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    bool status = await model.deleteAccount();
  }
}
