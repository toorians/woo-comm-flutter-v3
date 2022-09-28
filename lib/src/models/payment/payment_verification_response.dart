// To parse this JSON data, do
//
//     final paymentVerificationResponse = paymentVerificationResponseFromJson(jsonString);

import 'dart:convert';

PaymentVerificationResponse paymentVerificationResponseFromJson(String str) => PaymentVerificationResponse.fromJson(json.decode(str));

class PaymentVerificationResponse {
  PaymentVerificationResponse({
    required this.status,
    required this.message,
    //required this.data,
  });

  bool status;
  String message;
  //Data data;

  factory PaymentVerificationResponse.fromJson(Map<String, dynamic> json) => PaymentVerificationResponse(
    status: json["status"] == null ? false : json["status"],
    message: json["message"] == null ? '' : json["message"],
    //data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}
