import 'dart:convert';
import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/models/category_model.dart';
import 'package:app/src/models/product_model.dart';
import 'package:app/src/themes/theme.dart';


StoreDetails storeDetailsFromJson(String str) => StoreDetails.fromJson(json.decode(str));

class StoreDetails {
  StoreDetails({
    required this.settings,
    required this.blocks,
    this.theme,
    required this.products,
    required this.categories,
  });

  List<Block> blocks;
  Settings settings;
  BlockThemes? theme;
  List<Product> products;
  List<Category> categories;

  factory StoreDetails.fromJson(Map<String, dynamic> json) => StoreDetails(
    settings: _nullOrEmptyOrBool(json["dotapp_settings"]) ? Settings.fromJson({}) : Settings.fromJson(json["dotapp_settings"]),
    blocks: _nullOrEmptyOrBool(json["dotapp_blocks"]) ? [] : List<Block>.from(json["dotapp_blocks"].map((x) => Block.fromJson(x))),
    theme: _nullOrEmptyOrBool(json["dotapp_theme"]) ? null : BlockThemes.fromJson(json["dotapp_theme"]),
    products: json["recentProducts"] == null ? [] : List<Product>.from(json["recentProducts"].map((x) => Product.fromJson(x))),
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );
}

_nullOrEmptyOrBool(json) {
  if(json == null || json == '' || json is bool) {
    return true;
  } else return false;
}