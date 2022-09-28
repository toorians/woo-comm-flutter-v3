// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

import '../category_model.dart';

List<StoreModel> storeModelFromJson(String str) => List<StoreModel>.from(json.decode(str).map((x) => StoreModel.fromJson(x)));

class StoreModel {
  int id;
  String name;
  String icon;
  String banner;
  //Address address;
  String description;
  String latitude;
  String longitude;
  double averageRating;
  int ratingCount;
  int productsCount;
  List<Category> categories;
  bool isClosed;
  String deliveryTime;
  String? UID;

  StoreModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.banner,
    //required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.averageRating,
    required this.ratingCount,
    required this.productsCount,
    required this.categories,
    required this.isClosed,
    required this.deliveryTime,
    this.UID,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    id: json["id"] == null ? 0 : int.parse(json["id"].toString()),
    name: json["name"] == null ? '' : json["name"],
    icon: _nullOrEmptyOrFalse(json["icon"]) ? '' : json["icon"],
    banner: _nullOrEmptyOrFalse(json["banner"]) ? '' : json["banner"],
    //address: json["address"] == null ? null : Address.fromJson(json["address"]),
    description: json["description"] == null ? '' : json["description"],
    latitude: json["latitude"] == null ? '' : json["latitude"],
    longitude: json["longitude"] == null ? '' : json["longitude"],
    averageRating: json["average_rating"] == null ? 0 : json["average_rating"].toDouble(),
    ratingCount: json["rating_count"] == null ? 0 : json["rating_count"],
    productsCount: json["products_count"] == null ? 0 : json["products_count"],
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    isClosed: json["is_close"] == true ? true : false,
    deliveryTime: json["deliveryTime"] == null ? '' : json["deliveryTime"],
    UID: json["UID"] == null ? null : json["UID"],
  );

}

_nullOrEmptyOrFalse(json) {
  if(json == null || json == '' || json == false) {
    return true;
  } else return false;
}

class Address {
  String street1;
  String street2;
  String city;
  String zip;
  String country;
  String state;

  Address({
    required this.street1,
    required this.street2,
    required this.city,
    required this.zip,
    required this.country,
    required this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street1: json["street_1"] == null ? '' : json["street_1"],
    street2: json["street_2"] == null ? '' : json["street_2"],
    city: json["city"] == null ? '' : json["city"],
    zip: json["zip"] == null ? '' : json["zip"],
    country: json["country"] == null ? '' : json["country"],
    state: json["state"] == null ? '' : json["state"],
  );

}
