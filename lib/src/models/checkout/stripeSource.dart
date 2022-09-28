// To parse this JSON data, do
//
//     final stripeSourceModel = stripeSourceModelFromJson(jsonString);

import 'dart:convert';

StripeSourceModel stripeSourceModelFromJson(String str) => StripeSourceModel.fromJson(json.decode(str));

class StripeSourceModel {
  String id;
  //String object;
  dynamic amount;
  StripeCard card;
  String clientSecret;
  int created;
  dynamic currency;
  String flow;
  bool livemode;
  //Metadata metadata;
  Owner owner;
  dynamic statementDescriptor;
  String status;
  String type;
  String usage;

  StripeSourceModel({
    required this.id,
    //required this.object,
    required this.amount,
    required this.card,
    required this.clientSecret,
    required this.created,
    required this.currency,
    required this.flow,
    required this.livemode,
    //required this.metadata,
    required this.owner,
    required this.statementDescriptor,
    required this.status,
    required this.type,
    required this.usage,
  });

  factory StripeSourceModel.fromJson(Map<String, dynamic> json) => StripeSourceModel(
    id: json["id"] == null ? '0' : json["id"],
    //object: json["object"] == null ? null : json["object"],
    amount: json["amount"],
    card: json["card"] == null ? StripeCard.fromJson({}) : StripeCard.fromJson(json["card"]),
    clientSecret: json["client_secret"] == null ? '' : json["client_secret"],
    created: json["created"] == null ? 0 : json["created"],
    currency: json["currency"],
    flow: json["flow"] == null ? '' : json["flow"],
    livemode: json["livemode"] == null ? false : json["livemode"],
    //metadata: json["metadata"] == null ? Metadata.fromJson({}) : Metadata.fromJson(json["metadata"]),
    owner: json["owner"] == null ? Owner.fromJson({}) : Owner.fromJson(json["owner"]),
    statementDescriptor: json["statement_descriptor"],
    status: json["status"] == null ? '' : json["status"],
    type: json["type"] == null ? '' : json["type"],
    usage: json["usage"] == null ? '' : json["usage"],
  );
}

class StripeCard {
  int expMonth;
  int expYear;
  String last4;
  String country;
  String brand;
  String addressLine1Check;
  String addressZipCheck;
  String cvcCheck;
  String funding;
  String threeDSecure;
  dynamic name;
  dynamic tokenizationMethod;
  dynamic dynamicLast4;

  StripeCard({
    required this.expMonth,
    required this.expYear,
    required this.last4,
    required this.country,
    required this.brand,
    required this.addressLine1Check,
    required this.addressZipCheck,
    required this.cvcCheck,
    required this.funding,
    required this.threeDSecure,
    required this.name,
    required this.tokenizationMethod,
    required this.dynamicLast4,
  });

  factory StripeCard.fromJson(Map<String, dynamic> json) => StripeCard(
    expMonth: json["exp_month"] == null ? 12 : json["exp_month"],
    expYear: json["exp_year"] == null ? 25 : json["exp_year"],
    last4: json["last4"] == null ? '1234' : json["last4"],
    country: json["country"] == null ? 'US' : json["country"],
    brand: json["brand"] == null ? '' : json["brand"],
    addressLine1Check: json["address_line1_check"] == null ? '' : json["address_line1_check"],
    addressZipCheck: json["address_zip_check"] == null ? '' : json["address_zip_check"],
    cvcCheck: json["cvc_check"] == null ? '123' : json["cvc_check"],
    funding: json["funding"] == null ? '' : json["funding"],
    threeDSecure: json["three_d_secure"] == null ? '' : json["three_d_secure"],
    name: json["name"],
    tokenizationMethod: json["tokenization_method"],
    dynamicLast4: json["dynamic_last4"],
  );
}

class Owner {
  StripeAddress address;
  dynamic email;
  String name;
  dynamic phone;
  dynamic verifiedAddress;
  dynamic verifiedEmail;
  dynamic verifiedName;
  dynamic verifiedPhone;

  Owner({
    required this.address,
    required this.email,
    required this.name,
    required this.phone,
    required this.verifiedAddress,
    required this.verifiedEmail,
    required this.verifiedName,
    required this.verifiedPhone,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    address: json["address"] == null ? StripeAddress.fromJson({}) : StripeAddress.fromJson(json["address"]),
    email: json["email"],
    name: json["name"] == null ? '' : json["name"],
    phone: json["phone"],
    verifiedAddress: json["verified_address"],
    verifiedEmail: json["verified_email"],
    verifiedName: json["verified_name"],
    verifiedPhone: json["verified_phone"],
  );
}

class StripeAddress {
  String city;
  String country;
  String line1;
  String line2;
  String postalCode;
  String state;

  StripeAddress({
    required this.city,
    required this.country,
    required this.line1,
    required this.line2,
    required this.postalCode,
    required this.state,
  });

  factory StripeAddress.fromJson(Map<String, dynamic> json) => StripeAddress(
    city: json["city"] == null ? '' : json["city"],
    country: json["country"] == null ? '' : json["country"],
    line1: json["line1"] == null ? '' : json["line1"],
    line2: json["line2"] == null ? '' : json["line2"],
    postalCode: json["postal_code"] == null ? '' : json["postal_code"],
    state: json["state"] == null ? '' : json["state"],
  );
}
