// To parse this JSON data, do
//
//     final registerError = registerErrorFromJson(jsonString);

import 'dart:convert';

RegisterError registerErrorFromJson(String str) => RegisterError.fromJson(json.decode(str));

class RegisterError {
  bool success;
  List<Datum> data;

  RegisterError({
    required this.success,
    required this.data,
  });

  factory RegisterError.fromJson(Map<String, dynamic> json) => new RegisterError(
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
    code: json["code"].toString(),
    message: json["message"],
  );
}
