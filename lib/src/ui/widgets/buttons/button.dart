import 'package:flutter/material.dart';
import './../../../models/app_state_model.dart';

class AccentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;
  AppStateModel appStateModel = AppStateModel();

  AccentButton({
    required this.onPressed,
    required this.text,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: showProgress ? Text(appStateModel.blocks.localeText.pleaseWait) : Text(text), //ButtonText(isLoading: showProgress, text: text),
      ),
    );
  }
}
