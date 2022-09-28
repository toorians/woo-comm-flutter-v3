import 'package:app/src/models/app_state_model.dart';
import 'package:flutter/material.dart';

class PercentOff extends StatelessWidget {
  final int percentOff;
  const PercentOff({Key? key, required this.percentOff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return percentOff != 0 ? Positioned(
      top: 8,
      left: 8,
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
          child: Center(
            child: Text(percentOff.toString() + '% ' + AppStateModel().blocks.localeText.off,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.w700,
                )
            ),
          ),
        ),
      ),
    ) : Container();
  }
}
