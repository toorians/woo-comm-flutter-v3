// To parse this JSON data, do
//
//     final payMongoCardModel = payMongoCardModelFromJson(jsonString);

import 'dart:convert';

PayMongoCardModel payMongoCardModelFromJson(String str) => PayMongoCardModel.fromJson(json.decode(str));

String payMongoCardModelToJson(PayMongoCardModel data) => json.encode(data.toJson());

class PayMongoCardModel {
  PayMongoCardModel({
    required this.data,
  });

  PyaMongoData data;

  factory PayMongoCardModel.fromJson(Map<String, dynamic> json) => PayMongoCardModel(
    data: json["data"] == null ? PyaMongoData.fromJson({}) : PyaMongoData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? '' : data.toJson(),
  };
}

class PyaMongoData {
  PyaMongoData({
    required this.id,
    required this.attributes,
  });

  String id;
  PyaMongAttributes attributes;

  factory PyaMongoData.fromJson(Map<String, dynamic> json) => PyaMongoData(
    id: json["id"] == null || json["id"] == '' ? '' : json["id"],
    attributes: json["attributes"] == null ? PyaMongAttributes.fromJson({}) : PyaMongAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "attributes": attributes == null ? '' : attributes.toJson(),
  };
}

class PyaMongAttributes {
  PyaMongAttributes({
    required this.type,
    required this.details,
    required this.billing,
  });

  String type;
  PyaMongDetails details;
  PyaMongBilling billing;

  factory PyaMongAttributes.fromJson(Map<String, dynamic> json) => PyaMongAttributes(
    type: json["type"] == null ? '' : json["type"],
    details: json["details"] == null ? PyaMongDetails.fromJson({}) : PyaMongDetails.fromJson(json["details"]),
    billing: json["billing"] == null ? PyaMongBilling.fromJson({}) : PyaMongBilling.fromJson(json["billing"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? '' : type,
    "details": details == null ? '' : details.toJson(),
    "billing": billing == null ? '' : billing.toJson(),
  };
}

class PyaMongBilling {
  PyaMongBilling({
    required this.address,
    required this.name,
    required this.email,
    required this.phone,
  });

  PyaMongAddress address;
  String name;
  String email;
  String phone;

  factory PyaMongBilling.fromJson(Map<String, dynamic> json) => PyaMongBilling(
    address: json["address"] == null ? PyaMongAddress.fromJson({}) : PyaMongAddress.fromJson(json["address"]),
    name: json["name"] == null ? '' : json["name"],
    email: json["email"] == null ? '' : json["email"],
    phone: json["phone"] == null ? '' : json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "address": address == null ? '' : address.toJson(),
    "name": name == null ? '' : name,
    "email": email == null ? '' : email,
    "phone": phone == null ? '' : phone,
  };
}

class PyaMongAddress {
  PyaMongAddress({
    required this.line1,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  String line1;
  String city;
  String state;
  String country;
  String postalCode;

  factory PyaMongAddress.fromJson(Map<String, dynamic> json) => PyaMongAddress(
    line1: json["line1"] == null ? '' : json["line1"],
    city: json["city"] == null ? '' : json["city"],
    state: json["state"] == null ? '' : json["state"],
    country: json["country"] == null ? '' : json["country"],
    postalCode: json["postal_code"] == null ? '' : json["postal_code"],
  );

  Map<String, dynamic> toJson() => {
    "line1": line1 == null ? '' : line1,
    "city": city == null ? '' : city,
    "state": state == null ? '' : state,
    "country": country == null ? '' : country,
    "postal_code": postalCode == null ? '' : postalCode,
  };
}

class PyaMongDetails {
  PyaMongDetails({
    required this.cardNumber,
    required this.expMonth,
    required this.expYear,
    required this.cvc,
  });

  String cardNumber;
  int expMonth;
  int expYear;
  String cvc;

  factory PyaMongDetails.fromJson(Map<String, dynamic> json) => PyaMongDetails(
    cardNumber: json["card_number"] == null ? '' : json["card_number"],
    expMonth: json["exp_month"] == null ? '' : json["exp_month"],
    expYear: json["exp_year"] == null ? '' : json["exp_year"],
    cvc: json["cvc"] == null ? '' : json["cvc"],
  );

  Map<String, dynamic> toJson() => {
    "card_number": cardNumber == null ? '' : cardNumber,
    "exp_month": expMonth == null ? '' : expMonth,
    "exp_year": expYear == null ? '' : expYear,
    "cvc": cvc == null ? '' : cvc,
  };
}
