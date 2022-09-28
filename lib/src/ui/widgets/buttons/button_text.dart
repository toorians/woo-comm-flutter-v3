import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  const ButtonText({
    Key? key,
    required this.isLoading,
    required this.text,
  }) : super(key: key);

  final bool isLoading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      width: 20.0,
      height: 20.0,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: Theme.of(context).buttonTheme.colorScheme!.onPrimary,//Theme.of(context).buttonTheme.colorScheme.onPrimary,
      ),
    ) : Text(text);
  }
}