import 'package:app/src/models/app_state_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Container(
        constraints: BoxConstraints(minWidth: 120),
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
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  /// Creates a widget that paints the Flutter logo.
  ///
  /// The [size] defaults to the value given by the current [IconTheme].
  ///
  /// The [textColor], [style], [duration], and [curve] arguments must not be
  /// null.
  const AppLogo({
    Key? key,
    this.size,
    this.textColor = const Color(0xFF757575),
    this.style = FlutterLogoStyle.markOnly,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.fastOutSlowIn,
  }) : assert(textColor != null),
        assert(style != null),
        assert(duration != null),
        assert(curve != null),
        super(key: key);

  /// The size of the logo in logical pixels.
  ///
  /// The logo will be fit into a square this size.
  ///
  /// Defaults to the current [IconTheme] size, if any. If there is no
  /// [IconTheme], or it does not specify an explicit size, then it defaults to
  /// 24.0.
  final double? size;

  /// The color used to paint the "Flutter" text on the logo, if [style] is
  /// [FlutterLogoStyle.horizontal] or [FlutterLogoStyle.stacked].
  ///
  /// If possible, the default (a medium grey) should be used against a white
  /// background.
  final Color textColor;

  /// Whether and where to draw the "Flutter" text. By default, only the logo
  /// itself is drawn.
  final FlutterLogoStyle style;

  /// The length of time for the animation if the [style] or [textColor]
  /// properties are changed.
  final Duration duration;

  /// The curve for the logo animation if the [style] or [textColor] change.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double? iconSize = size ?? iconTheme.size;
    return AnimatedContainer(
      width: iconSize,
      height: iconSize,
      duration: duration,
      curve: curve,
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
