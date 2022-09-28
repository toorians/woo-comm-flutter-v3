// To parse this JSON data, do
//
//     final wooError = wooErrorFromJson(jsonString);

import 'dart:convert';

WooError wooErrorFromJson(String str) => WooError.fromJson(json.decode(str));

class WooError {
  WooError({
    required this.code,
    required this.message,
    required this.data,
  });

  String code;
  String message;
  Data data;

  factory WooError.fromJson(Map<String, dynamic> json) => WooError(
    code: json["code"] == null ? '' : json["code"],
    message: json["message"] == null ? '' : json["message"],
    data: json["data"] == null ? Data.fromJson({}) : Data.fromJson(json["data"]),
  );
}

class Data {
  Data({
    required this.status,
  });

  int status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"] == null ? 0 : json["status"],
  );
}
