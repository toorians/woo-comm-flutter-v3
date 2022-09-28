// To parse this JSON data, do
//
//     final releatedProducts = releatedProductsFromJson(jsonString);

import 'dart:convert';

import 'product_model.dart';

RelatedProductsModel releatedProductsFromJson(String str) => RelatedProductsModel.fromJson(json.decode(str));

class RelatedProductsModel {
  List<Product> relatedProducts;
  List<Product> upsellProducts;
  List<Product> crossProducts;

  RelatedProductsModel({
    required this.relatedProducts,
    required this.upsellProducts,
    required this.crossProducts,
  });

  factory RelatedProductsModel.fromJson(Map<String, dynamic> json) => RelatedProductsModel(
    relatedProducts: json["relatedProducts"] == null ? [] : List<Product>.from(json["relatedProducts"].map((x) => Product.fromJson(x))),
    upsellProducts: json["upsellProducts"] == null ? [] : List<Product>.from(json["upsellProducts"].map((x) => Product.fromJson(x))),
    crossProducts: json["crossProducts"] == null ? [] : List<Product>.from(json["crossProducts"].map((x) => Product.fromJson(x))),
  );
}