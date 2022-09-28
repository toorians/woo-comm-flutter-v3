
import 'dart:convert';

OrderResult OrderResultFromJson(String str) => OrderResult.fromJson(json.decode(str));

class OrderResult {
  String result;
  String messages;
  String? redirect;
  String? orderId;

  OrderResult({
    required this.result,
    required this.messages,
    this.redirect,
    this.orderId
  });

  factory OrderResult.fromJson(Map<String, dynamic> json) => new OrderResult(
    result: json["result"] == null ? '' : json["result"],
    messages: json["messages"] == null ? '' : json["messages"],
    redirect: json["redirect"] == null ? null : json["redirect"],
    orderId: json["order_id"] == null ? null : json["order_id"].toString(),
  );

}