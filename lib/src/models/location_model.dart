// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'dart:convert';

List<CustomLocation> locationFromJson(String str) => List<CustomLocation>.from(json.decode(str).map((x) => CustomLocation.fromJson(x)));

class CustomLocation {
  CustomLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.pincode,
  });

  String name;
  String latitude;
  String longitude;
  String address;
  String pincode;

  factory CustomLocation.fromJson(Map<String, dynamic> json) => CustomLocation(
    name: json["name"] == null ? '' : json["name"],
    latitude: json["latitude"] == null ? '' : json["latitude"],
    longitude: json["longitude"] == null ? '' : json["longitude"],
    address: json["address"] == null ? '' : json["address"],
    pincode: json["pincode"] == null ? '' : json["pincode"],
  );
}
