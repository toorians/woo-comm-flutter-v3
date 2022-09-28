import 'package:app/src/models/app_state_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class HeaderLogo extends StatelessWidget {

  const HeaderLogo({
    Key? key,
    this.textColor = const Color(0xFF757575),
    this.style = FlutterLogoStyle.markOnly,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  final Color textColor;

  final FlutterLogoStyle style;

  final Duration duration;

  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final double iconSize = 42;
    return AnimatedContainer(
      height: iconSize,
      duration: duration,
      child: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            if (Theme.of(context).brightness == Brightness.light && model.blocks.settings.logo != null) {
              return CachedNetworkImage(
                imageUrl: model.blocks.settings.logo!,
                placeholder: (context, url) => Container(
                  color: Colors.transparent,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.transparent,
                ),
                fit: BoxFit.contain,
              );
            } else if (Theme.of(context).brightness == Brightness.dark && model.blocks.settings.darkLogo != null) {
              return CachedNetworkImage(
                imageUrl: model.blocks.settings.darkLogo!,
                placeholder: (context, url) => Container(
                  color: Colors.transparent,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.transparent,
                ),
                fit: BoxFit.contain,
              );
            } else {
              return Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              );
            }
          }),
    );
  }
}
