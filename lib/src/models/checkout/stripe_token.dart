// To parse this JSON data, do
//
//     final stripeTokenModel = stripeTokenModelFromJson(jsonString);

import 'dart:convert';

StripeTokenModel stripeTokenModelFromJson(String str) => StripeTokenModel.fromJson(json.decode(str));

class StripeTokenModel {
  String id;
  //String object;
  TokenCard card;
  String clientIp;
  int created;
  bool livemode;
  String type;
  bool used;

  StripeTokenModel({
    required this.id,
    //required this.object,
    required this.card,
    required this.clientIp,
    required this.created,
    required this.livemode,
    required this.type,
    required this.used,
  });

  factory StripeTokenModel.fromJson(Map<String, dynamic> json) => StripeTokenModel(
    id: json["id"] == null ? '' : json["id"],
    //object: json["object"] == null ? null : json["object"],
    card: json["card"] == null ? TokenCard.fromJson({}) : TokenCard.fromJson(json["card"]),
    clientIp: json["client_ip"] == null ? '' : json["client_ip"],
    created: json["created"] == null ? 0 : json["created"],
    livemode: json["livemode"] == null ? false : json["livemode"],
    type: json["type"] == null ? '' : json["type"],
    used: json["used"] == null ? false : json["used"],
  );
}

class TokenCard {
  String id;
  String object;
  String addressCity;
  String addressCountry;
  String addressLine1;
  String addressLine1Check;
  String addressLine2;
  String addressState;
  String addressZip;
  String addressZipCheck;
  String brand;
  String country;
  String cvcCheck;
  dynamic dynamicLast4;
  int expMonth;
  int expYear;
  String funding;
  String last4;
  //Metadata metadata;
  String name;
  dynamic tokenizationMethod;

  TokenCard({
    required this.id,
    required this.object,
    required this.addressCity,
    required this.addressCountry,
    required this.addressLine1,
    required this.addressLine1Check,
    required this.addressLine2,
    required this.addressState,
    required this.addressZip,
    required this.addressZipCheck,
    required this.brand,
    required this.country,
    required this.cvcCheck,
    required this.dynamicLast4,
    required this.expMonth,
    required this.expYear,
    required this.funding,
    required this.last4,
    //required this.metadata,
    required this.name,
    required this.tokenizationMethod,
  });

  factory TokenCard.fromJson(Map<String, dynamic> json) => TokenCard(
    id: json["id"] == null ? '' : json["id"],
    object: json["object"] == null ? '' : json["object"],
    addressCity: json["address_city"] == null ? '' : json["address_city"],
    addressCountry: json["address_country"] == null ? '' : json["address_country"],
    addressLine1: json["address_line1"] == null ? '' : json["address_line1"],
    addressLine1Check: json["address_line1_check"] == null ? '' : json["address_line1_check"],
    addressLine2: json["address_line2"] == null ? '' : json["address_line2"],
    addressState: json["address_state"] == null ? '' : json["address_state"],
    addressZip: json["address_zip"] == null ? '' : json["address_zip"],
    addressZipCheck: json["address_zip_check"] == null ? '' : json["address_zip_check"],
    brand: json["brand"] == null ? '' : json["brand"],
    country: json["country"] == null ? '' : json["country"],
    cvcCheck: json["cvc_check"] == null ? '' : json["cvc_check"],
    dynamicLast4: json["dynamic_last4"],
    expMonth: json["exp_month"] == null ? 01 : json["exp_month"],
    expYear: json["exp_year"] == null ? 25 : json["exp_year"],
    funding: json["funding"] == null ? '' : json["funding"],
    last4: json["last4"] == null ? '1234' : json["last4"],
    //metadata: json["metadata"] == null ? Metadata.fromJson({}) : Metadata.fromJson(json["metadata"]),
    name: json["name"] == null ? '' : json["name"],
    tokenizationMethod: json["tokenization_method"],
  );
}
