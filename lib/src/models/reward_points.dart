// To parse this JSON data, do
//
//     final rewardPoints = rewardPointsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RewardPointsModel rewardPointsFromJson(String str) => RewardPointsModel.fromJson(json.decode(str));

class RewardPointsModel {
  RewardPointsModel({
    required this.items,
    required this.points,
    required this.pointsValue,
  });

  List<Item> items;
  int points;
  String pointsValue;

  factory RewardPointsModel.fromJson(Map<String, dynamic> json) => RewardPointsModel(
    items: json["items"] == null ? [] : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    points: json["points"] == null ? 0 : json["points"],
    pointsValue: json["points_value"] != json["points_value"] ? json["points_vlaue"] != null ? json["points_vlaue"] : '0.0' : '0.0',
  );
}

class Item {
  Item({
    //required this.id,
    //required this.userId,
    required this.points,
    required this.type,
    //required this.userPointsId,
    required this.orderId,
    //required this.adminUserId,
    //required this.data,
    required this.date,
    //required this.dateDisplayHuman,
    required this.dateDisplay,
    required this.description,
  });

  //String id;
  //String userId;
  String points;
  String type;
  //dynamic userPointsId;
  dynamic orderId;
  //String adminUserId;
  //dynamic data;
  DateTime date;
  //String dateDisplayHuman;
  String dateDisplay;
  String description;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    //id: json["id"] == null ? null : json["id"],
    //userId: json["user_id"] == null ? null : json["user_id"],
    points: json["points"] == null ? null : json["points"],
    type: json["type"] == null ? null : json["type"],
    //userPointsId: json["user_points_id"],
    orderId: json["order_id"],
    //adminUserId: json["admin_user_id"] == null ? null : json["admin_user_id"],
    //data: json["data"],
    date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
    //dateDisplayHuman: json["date_display_human"] == null ? null : json["date_display_human"],
    dateDisplay: json["date_display"] == null ? null : json["date_display"],
    description: json["description"] == null ? null : json["description"],
  );
}
