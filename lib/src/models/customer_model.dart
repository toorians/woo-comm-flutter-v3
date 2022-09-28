// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

class Customer {
  int id;
  String email;
  String firstName;
  String lastName;
  String role;
  String username;
  Address billing;
  Address shipping;
  bool isPayingCustomer;
  int ordersCount;
  String totalSpent;
  String avatarUrl;
  List<MetaDatum> metaData;
  String guest;

  Customer({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.username,
    required this.billing,
    required this.shipping,
    required this.isPayingCustomer,
    required this.ordersCount,
    required this.totalSpent,
    required this.avatarUrl,
    required this.metaData,
    required this.guest
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"] == null ? 0 : json["id"],
    email: json["email"] == null ? '' : json["email"],
    firstName: json["first_name"] == null ? '' : json["first_name"],
    lastName: json["last_name"] == null ? '' : json["last_name"],
    role: json["role"] == null ? '' : json["role"],
    username: json["username"] == null ? '' : json["username"],
    billing: json["billing"] == null ? Address.fromJson({}) : Address.fromJson(json["billing"]),
    shipping: json["shipping"] == null ? Address.fromJson({}) : Address.fromJson(json["shipping"]),
    isPayingCustomer: json["is_paying_customer"] == null ? true : json["is_paying_customer"],
    ordersCount: json["orders_count"] == null ? 0 : json["orders_count"],
    totalSpent: json["total_spent"] == null ? '' : json["total_spent"],
    avatarUrl: json["avatar_url"] == null ? '' : json["avatar_url"],
    metaData: json["meta_data"] == null ? [] : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
    guest: json["guest"] == null ? '' : json["guest"],
  );
}

class Address {
  String firstName;
  String lastName;
  String company;
  String address1;
  String address2;
  String city;
  String postcode;
  String country;
  String state;
  String email;
  String phone;

  Address({
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.address1,
    required this.address2,
    required this.city,
    required this.postcode,
    required this.country,
    required this.state,
    required this.email,
    required this.phone,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    firstName: json["first_name"] == null ? '' : json["first_name"],
    lastName: json["last_name"] == null ? '' : json["last_name"],
    company: json["company"] == null ? '' : json["company"],
    address1: json["address_1"] == null ? '' : json["address_1"],
    address2: json["address_2"] == null ? '' : json["address_2"],
    city: json["city"] == null ? '' : json["city"],
    postcode: json["postcode"] == null ? '' : json["postcode"],
    country: json["country"] == null ? '' : json["country"],
    state: json["state"] == null ? '' : json["state"],
    email: json["email"] == null ? '' : json["email"],
    phone: json["phone"] == null ? '' : json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName.isEmpty ? null : firstName,
    "last_name": lastName.isEmpty ? null : lastName,
    "company": company.isEmpty ? null : company,
    "address_1": address1.isEmpty ? null : address1,
    "address_2": address2.isEmpty ? null : address2,
    "city": city.isEmpty ? null : city,
    "postcode": postcode.isEmpty ? null : postcode,
    "country": country.isEmpty ? null : country,
    "state": state.isEmpty ? null : state,
    "email": email.isEmpty ? null : email,
    "phone": phone.isEmpty ? null : phone,
  };
}

class MetaDatum {
  int id;
  String key;
  dynamic value;

  MetaDatum({
    required this.id,
    required this.key,
    required this.value,
  });

  factory MetaDatum.fromJson(Map<String, dynamic> json) => MetaDatum(
    id: json["id"] == null ? null : json["id"],
    key: json["key"] == null ? null : json["key"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "key": key == null ? null : key,
    "value": value == null ? null : value,
  };
}
