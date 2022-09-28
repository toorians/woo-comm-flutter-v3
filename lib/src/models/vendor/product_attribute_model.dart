// To parse this JSON data, do
//
//     final productAttribute = productAttributeFromJson(jsonString);

import 'dart:convert';

List<ProductAttribute> productAttributeFromJson(String str) => List<ProductAttribute>.from(json.decode(str).map((x) => ProductAttribute.fromJson(x)));

class ProductAttribute {
  int id;
  String name;
  String slug;
  String type;
  String orderBy;
  bool hasArchives;

  ProductAttribute({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.orderBy,
    required this.hasArchives,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) => ProductAttribute(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? '' : json["slug"],
    type: json["type"] == null ? '' : json["type"],
    orderBy: json["order_by"] == null ? '' : json["order_by"],
    hasArchives: json["has_archives"] == null ? false : json["has_archives"],
  );
}

List<AttributeTerms> attributeTermsFromJson(String str) => List<AttributeTerms>.from(json.decode(str).map((x) => AttributeTerms.fromJson(x)));

class AttributeTerms {
  int id;
  String name;
  String slug;
  String description;
  int menuOrder;
  int count;

  AttributeTerms({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.menuOrder,
    required this.count,
  });

  factory AttributeTerms.fromJson(Map<String, dynamic> json) => AttributeTerms(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? '' : json["slug"],
    description: json["description"] == null ? '' : json["description"],
    menuOrder: json["menu_order"] == null ? 0 : json["menu_order"],
    count: json["count"] == null ? 0 : json["count"],
  );
}
