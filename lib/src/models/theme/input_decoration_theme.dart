import 'package:flutter/material.dart';
import 'hex_color.dart';

class BlockInputDecoration {
  BlockInputDecoration({
    required this.isCollapsed,
    required this.filled,
    required this.isDense,
    required this.borderRadius,
    required this.contentPadding,
    required this.fillColor,
    required this.style,
  });

  bool isCollapsed;
  bool filled;
  bool isDense;
  double borderRadius;
  double contentPadding;
  Color fillColor;
  String style;

  factory BlockInputDecoration.fromJson(Map<String, dynamic> json) {
      return BlockInputDecoration(
      isCollapsed: json["isCollapsed"] == true ? true : false,
      filled: json["filled"] == true ? true : false,
      isDense: json["isDense"] == true ? true : false,
      borderRadius:  _nullOrEmptyOrFalse(json["borderRadius"]) ? 4.0 : double.parse(json["borderRadius"].toString()),
      contentPadding:  _nullOrEmptyOrFalse(json["contentPadding"]) ? 16.0 : double.parse(json["contentPadding"].toString()),
      fillColor: _nullOrEmptyOrFalse(json["fillColor"]) ? Colors.grey[200]! : HexColor(json["fillColor"]),
      style: _nullOrEmptyOrFalse(json["style"]) ? '' : json["style"].toString(),
    );
  }
}

bool _nullOrEmptyOrFalse(dynamic json) {
  if (json == null || json == '' || json == false) {
    return true;
  } else
    return false;
}

