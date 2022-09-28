// To parse this JSON data, do
//
//     final error = errorFromJson(jsonString);

import 'dart:convert';

WpErrors errorFromJson(String str) => WpErrors.fromJson(json.decode(str));

class WpErrors {
  bool success;
  List<Datum> data;

  WpErrors({
    required this.success,
    required this.data,
  });

  factory WpErrors.fromJson(Map<String, dynamic> json) => new WpErrors(
    success: json["success"],
    data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );
}

class Datum {
  String code;
  String message;

  Datum({
    required this.code,
    required this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
    code: json["code"] != null ? json["code"].toString() : '0',
    message: json["message"] != null ? json["message"] : '',
  );
}


Notice noticeFromJson(String str) => Notice.fromJson(json.decode(str));

class Notice {
  Notice({
    required this.success,
    required this.data,
  });

  bool success;
  List<Messages> data;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    success: json["success"] == null ? '' : json["success"],
    data: json["data"] == null ? [] : List<Messages>.from(json["data"].map((x) => Messages.fromJson(x))),
  );
}

class Messages {
  Messages({
    required this.notice,
    required this.data,
  });

  String notice;
  List<dynamic> data;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    notice: json["notice"] == null ? '' : json["notice"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"].map((x) => x)),
  );
}
