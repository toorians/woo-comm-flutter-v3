// To parse this JSON data, do
//
//     final block = blockFromJson(jsonString);

import 'package:app/src/models/theme/hex_color.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarModel {
  BottomNavigationBarModel({
    required this.items,
    required this.type,
    required this.backgroundColor,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    required this.showSelectedLabels,
    required this.showUnselectedLabels,
    required this.elevation
  });

  List<NavigationItem> items;
  BottomNavigationBarType type;
  Color backgroundColor;
  Color selectedItemColor;
  Color unselectedItemColor;
  bool showSelectedLabels;
  bool showUnselectedLabels;
  double elevation;

  factory BottomNavigationBarModel.fromJson(Map<String, dynamic> json) => BottomNavigationBarModel(
    items: json["items"] == null ? navigationItem : List<NavigationItem>.from(json["items"].map((x) => NavigationItem.fromJson(x))),
    showSelectedLabels: json["showSelectedLabels"] == false ? false : true,
    showUnselectedLabels: json["showUnselectedLabels"] ==false  ? false : true,
    type: json["type"] == 'BottomNavigationBarType.shifting' ? BottomNavigationBarType.shifting : BottomNavigationBarType.fixed,
    backgroundColor: _nullOrEmptyOrFalse(json["backgroundColor"]) ? Colors.blue : HexColor(json["backgroundColor"]),
    selectedItemColor: _nullOrEmptyOrFalse(json["selectedItemColor"]) ? Colors.white : HexColor(json["selectedItemColor"]),
    unselectedItemColor: _nullOrEmptyOrFalse(json["unselectedItemColor"]) ? Colors.white70 : HexColor(json["unselectedItemColor"]),
    elevation: json["elevation"] == null ? 8.0 : double.parse(json["elevation"].toString()),
  );
}

List<NavigationItem> navigationItem = [
  NavigationItem(
      title: 'Home',
      backgroundColor: Colors.blue,
      icon: 'CupertinoIcons.home',
      activeIcon: 'CupertinoIcons.house_fill',
      link: 'home'
  ),
  NavigationItem(
      title: 'Category',
      backgroundColor: Colors.teal,
      icon: 'CupertinoIcons.square_grid_2x2',
      activeIcon: 'CupertinoIcons.square_grid_2x2_fill',
      link: 'category'
  ),
  NavigationItem(
      title: 'Cart',
      backgroundColor: Colors.deepOrangeAccent,
      icon: 'CupertinoIcons.bag',
      activeIcon: 'CupertinoIcons.bag_fill',
      link: 'cart'
  ),
  NavigationItem(
      title: 'Account',
      backgroundColor: Colors.green,
      icon: 'CupertinoIcons.person_alt_circle',
      activeIcon: 'CupertinoIcons.person_alt_circle_fill',
      link: 'account'
  ),
];

class NavigationItem {
  NavigationItem({
    required this.backgroundColor,
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.link,
    this.linkId
  });

  Color backgroundColor;
  String title;
  String icon;
  String activeIcon;
  String link;
  String? linkId;

  factory NavigationItem.fromJson(Map<String, dynamic> json) => NavigationItem(
    backgroundColor: _nullOrEmptyOrFalse(json["backgroundColor"]) ? Colors.white : HexColor(json["backgroundColor"]),
    title: _nullOrEmptyOrFalse(json["label"]) ? '' : json["label"],
    icon: json["icon"] == null ? 'CupertinoIcons.home' : json["icon"],
    activeIcon: json["activeIcon"] == null ? 'CupertinoIcons.house_fill' : json["activeIcon"],
    link: json["link"] == null ? '' : json["link"],
    linkId: json["linkId"] == null ? '0' : json["linkId"],
  );
}

_nullOrEmptyOrFalse(json) {
  if(json == null || json == '' || json == false) {
    return true;
  } else return false;
}