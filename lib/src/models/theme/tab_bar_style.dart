import 'package:flutter/material.dart';
import 'hex_color.dart';

class BlockTabBarStyle {
  BlockTabBarStyle({
    required this.isScrollable,
    required this.indicatorColor,
    required this.backgroundColor,
    required this.indicatorWeight,
    required this.indicatorPadding,
    required this.indicatorSize,
    required this.labelColor,
    //this.labelStyle,
    required this.labelPadding,
    required this.unselectedLabelColor,
    this.tabBarIndicatorSize = TabBarIndicatorSize.tab,
    //this.unselectedLabelStyle,
  });

  bool isScrollable;
  Color indicatorColor;
  Color backgroundColor;
  double indicatorWeight;
  double indicatorPadding;
  double indicatorSize;
  Color labelColor;
  //BlockTextStyle labelStyle;
  double labelPadding;
  Color unselectedLabelColor;
  TabBarIndicatorSize tabBarIndicatorSize;
  //BlockTextStyle unselectedLabelStyle;

  factory BlockTabBarStyle.fromJson(Map<String, dynamic> json) {
    return BlockTabBarStyle(
      isScrollable: json["isScrollable"] == false ? false : true,
      indicatorColor: _nullOrEmptyOrFalse(json["indicatorColor"]) ? Color(0xFF000000) : HexColor(json["indicatorColor"]),
      backgroundColor: _nullOrEmptyOrFalse(json["backgroundColor"]) ? Color(0xFFFFFFFF) : HexColor(json["backgroundColor"]),
      labelColor: _nullOrEmptyOrFalse(json["labelColor"]) ? Color(0xFF000000) : HexColor(json["labelColor"]),
      unselectedLabelColor: _nullOrEmptyOrFalse(json["unselectedLabelColor"]) ? Color(0xFF3D3D3D) : HexColor(json["unselectedLabelColor"]),
      labelPadding:  _nullOrEmptyOrFalse(json["labelPadding"]) ? 0.0 : double.parse(json["labelPadding"].toString()),
      indicatorWeight: _nullOrEmptyOrFalse(json["indicatorWeight"]) ? 4.0 : double.parse(json["indicatorWeight"].toString()),
      indicatorPadding: _nullOrEmptyOrFalse(json["indicatorPadding"]) ? 0 : double.parse(json["indicatorPadding"].toString()),
      indicatorSize: _nullOrEmptyOrFalse(json["indicatorSize"]) ? 0.0 : double.parse(json["indicatorSize"].toString()),
      tabBarIndicatorSize: json["tabBarIndicatorSize"] == 'TabBarIndicatorSize.label' ? TabBarIndicatorSize.label : TabBarIndicatorSize.tab,
      //labelStyle: json["labelStyle"] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json["labelStyle"] as Map<String, dynamic>),
      //unselectedLabelStyle: json["unselectedLabelStyle"] == null ? BlockTextStyle.fromJson({}) : BlockTextStyle.fromJson(json["unselectedLabelStyle"] as Map<String, dynamic>),
    );
  }
}

bool _nullOrEmptyOrFalse(dynamic json) {
  if(json == null || json == '' || json == false) {
    return true;
  } else return false;
}