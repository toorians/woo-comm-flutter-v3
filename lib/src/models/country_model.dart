// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

List<CountryModel> countryModelFromJson(String str) => List<CountryModel>.from(json.decode(str).map((x) => CountryModel.fromJson(x)));

class CountryModel {
  String label;
  String value;
  List<Region> regions;

  CountryModel({
    required this.label,
    required this.value,
    required this.regions,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    label: json["label"] == null ? '' : json["label"],
    value: json["value"] == null ? '' : json["value"],
    regions: json["regions"] == null ? [] : List<Region>.from(json["regions"].map((x) => Region.fromJson(x))),
  );
}

class Region {
  String label;
  String value;

  Region({
    required this.label,
    required this.value,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    label: json["label"] == null ? '' : json["label"],
    value: json["value"] == null ? '' : json["value"],
  );
}
