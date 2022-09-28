// To parse this JSON data, do
//
//     final addToCartErrorModel = addToCartErrorModelFromJson(jsonString);

import 'dart:convert';

AddToCartErrorModel addToCartErrorModelFromJson(String str) => AddToCartErrorModel.fromJson(json.decode(str));

class AddToCartErrorModel {
  bool success;
  AddToCartErrorData data;

  AddToCartErrorModel({
    required this.success,
    required this.data,
  });

  factory AddToCartErrorModel.fromJson(Map<String, dynamic> json) => AddToCartErrorModel(
    success: json["success"] == null ? false : json["success"],
    data: json["data"] == null ? AddToCartErrorData.fromJson({}) : AddToCartErrorData.fromJson(json["data"]),
  );
}

class AddToCartErrorData {
  bool error;
  String notice;

  AddToCartErrorData({
    required this.error,
    required this.notice,
  });

  factory AddToCartErrorData.fromJson(Map<String, dynamic> json) => AddToCartErrorData(
    error: json["error"] == null ? false : json["error"],
    notice: json["notice"] == null ? '' : json["notice"],
  );
}
