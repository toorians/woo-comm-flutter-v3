// To parse this JSON data, do
//
//     final vendorDetails = vendorDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:app/src/models/vendor/store_model.dart';

import '../blocks_model.dart';
import '../product_model.dart';

VendorDetailsModel vendorDetailsModelFromJson(String str) => VendorDetailsModel.fromJson(json.decode(str));

class VendorDetailsModel {
  StoreModel store;
  //TODO Implement Dynamic Blocks
  List<Block> blocks;
  List<Product> recentProducts;

  VendorDetailsModel({
    required this.store,
    required this.blocks,
    required this.recentProducts,
  });

  factory VendorDetailsModel.fromJson(Map<String, dynamic> json) => VendorDetailsModel(
    store: json["store"] == null ? StoreModel.fromJson({}) : StoreModel.fromJson(json["store"]),
    blocks: json["blocks"] == null ? [] : List<Block>.from(json["blocks"].map((x) => Block.fromJson(x))),
    recentProducts: json["recentProducts"] == null ? [] : List<Product>.from(json["recentProducts"].map((x) => Product.fromJson(x))),
  );

}

