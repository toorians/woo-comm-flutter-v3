import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/resources/get_icon.dart';
import 'package:flutter/material.dart';

class ColoredIcon extends StatelessWidget {

  const ColoredIcon({Key? key, required this.item}) : super(key: key);

  final Child item;

  @override
  Widget build(BuildContext context) {

    //bool isDark = Theme.of(context).brightness == Brightness.dark;
    //Color iconColor = isDark ? Theme.of(context).iconTheme.color! : AppStateModel().blocks.settings.menuTheme.light.hintColor;

    return item.iconStyle != null ? Card(
      margin: EdgeInsets.all(0),
      color: _getBackgroundColor(item.iconStyle!, context),
      elevation: item.iconStyle!.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(item.iconStyle!.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(baoIconList.firstWhere((element) => element.label == item.leading).icon, color: _getIconColor(item.iconStyle!, context)),
      ),
    ) : Icon(baoIconList.firstWhere((element) => element.label == item.leading).icon/*, color: iconColor*/);
  }

  _getBackgroundColor(IconStyle iconStyle, BuildContext context) {
    switch (iconStyle.style) {
      case 'primary':
        return Colors.transparent;
      case 'secondary':
        return Colors.transparent;
      case 'error':
        return Colors.transparent;
      case 'onPrimary':
        return Theme.of(context).colorScheme.primary;
      case 'onSecondary':
        return Theme.of(context).colorScheme.secondary;
      case 'onSurface':
        return Theme.of(context).colorScheme.surface;
      case 'onBackground':
        return Theme.of(context).colorScheme.background;
      default: return iconStyle.backgroundColor;
    }
  }

  _getIconColor(IconStyle iconStyle, BuildContext context) {
    switch (iconStyle.style) {
      case 'primary':
        return Theme.of(context).colorScheme.primary;
      case 'secondary':
        return Theme.of(context).colorScheme.secondary;
      case 'error':
        return Theme.of(context).colorScheme.error;
      case 'onPrimary':
        return Theme.of(context).colorScheme.onPrimary;
      case 'onSecondary':
        return Theme.of(context).colorScheme.onSecondary;
      case 'onSurface':
        return Theme.of(context).colorScheme.onSurface;
      case 'onBackground':
        return Theme.of(context).colorScheme.onBackground;
      default: return iconStyle.color;
    }
  }
}