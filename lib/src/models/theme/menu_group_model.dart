// To parse this JSON data, do
//
//     final menuGroup = menuGroupFromJson(jsonString);

import 'dart:convert';

import 'package:app/src/models/blocks_model.dart';

List<MenuGroup> menuGroupFromJson(String str) => List<MenuGroup>.from(json.decode(str).map((x) => MenuGroup.fromJson(x)));

class MenuGroup {
  MenuGroup({
    this.type,
    this.showTitle = true,
    this.subTitle,
    this.title = '',
    required this.menuItems,
  });

  String? type;
  bool showTitle;
  String? subTitle;
  String title;
  List<Child> menuItems;

  factory MenuGroup.fromJson(Map<String, dynamic> json) => MenuGroup(
    type: json["type"] == null ? null : json["type"],
    showTitle: json["showTitle"] == null ? true : json["showTitle"],
    subTitle: json["subTitle"] == null ? null : json["subTitle"],
    title: json["title"] == null ? '' : json["title"],
    menuItems: json["menuItems"] == null ? [] : List<Child>.from(json["menuItems"].map((x) => Child.fromJson(x))),
  );
}


