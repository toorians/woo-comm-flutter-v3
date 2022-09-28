// To parse this JSON data, do
//
//     final picture = pictureFromJson(jsonString);

import 'dart:convert';

Picture pictureFromJson(String str) => Picture.fromJson(json.decode(str));

class Picture {
  int id;
  String src;
  String name;
  String alt;
  int position;

  Picture({
    required this.id,
    required this.src,
    required this.name,
    required this.alt,
    required this.position,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    id: json["id"] == null ? 0 : json["id"],
    src: (json["src"] == null || json["src"] == false) ? '' : json["src"],
    name: json["name"] == null ? '' : json["name"],
    alt: json["alt"] == null ? '' : json["alt"],
    position: json["position"] == null ? 0 : json["position"],
  );
}
