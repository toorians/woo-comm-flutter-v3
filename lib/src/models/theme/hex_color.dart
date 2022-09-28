import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "0xFF" + hexColor;
    }
    return int.parse(hexColor);
  }

  HexColor(final dynamic hexColor) : super(_getColorFromHex(hexColor.toString()));
}

String toHexColor(Color color) {
  return '0x${color.value.toRadixString(16)}';
}