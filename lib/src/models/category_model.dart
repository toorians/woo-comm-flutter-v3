// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

class Category {
  int id;
  String name;
  String slug;
  String description;
  int parent;
  int count;
  String image;

  Category({
    required this.id,
    required this.name,
    this.slug = '',
    this.description = '',
    this.parent = 0,
    this.count = 0,
    this.image = '',
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? '' : json["slug"],
    description: json["description"] == null ? '' : json["description"],
    parent: json["parent"] == null ? 0 : json["parent"],
    count: json["count"] == null ? 0 : json["count"],
    image: json["image"] == null || json["image"] == false ? '' : json["image"],
  );
}