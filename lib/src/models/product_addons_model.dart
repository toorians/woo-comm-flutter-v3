// To parse this JSON data, do
//
//     final productAddons = productAddonsFromJson(jsonString);

import 'dart:convert';

List<ProductAddonsModel> productAddonsFromJson(String str) => List<ProductAddonsModel>.from(json.decode(str).map((x) => ProductAddonsModel.fromJson(x)));

class ProductAddonsModel {
  ProductAddonsModel({
    required this.id,
    required this.name,
    required this.priority,
    //required this.restrictToCategories,
    required this.fields,
  });

  int id;
  String name;
  int priority;
  //Map<String, String> restrictToCategories;
  List<AddonField> fields;

  factory ProductAddonsModel.fromJson(Map<String, dynamic> json) {
    try{
      return ProductAddonsModel(
        id: json["id"] == null ? 0 : json["id"],
        name: json["name"] == null ? '' : json["name"],
        priority: json["priority"] == null ? 0 : json["priority"],
        //restrictToCategories: json["restrict_to_categories"] == null ? null : (json["restrict_to_categories"] as Map).cast<String, String>(),
        fields: json["fields"] == null ? [] : List<AddonField>.from(
            json["fields"].map((x) => AddonField.fromJson(x))),
      );
    } catch (e, s) {
      return ProductAddonsModel(
        id: json["id"] == null ? 0 : json["id"],
        name: json["name"] == null ? '' : json["name"],
        priority: json["priority"] == null ? 0 : json["priority"],
        //restrictToCategories: {},
        fields: json["fields"] == null ? [] : List<AddonField>.from(
            json["fields"].map((x) => AddonField.fromJson(x))),
      );
    }
  }
}

class AddonField {
  AddonField({
    required this.name,
    required this.description,
    required this.type,
    required this.display,
    required this.position,
    required this.options,
    required this.required,
    required this.selected,
  });

  String name;
  String description;
  String type;
  String display;
  int position;
  List<AddonOption> options;
  int required;
  bool selected;

  factory AddonField.fromJson(Map<String, dynamic> json) => AddonField(
    name: json["name"] == null ? '' : json["name"],
    description: json["description"] == null ? '' : json["description"],
    type: json["type"] == null ? '' : json["type"],
    display: json["display"] == null ? 'radiobutton' : json["display"],
    position: json["position"] == null ? 0 : json["position"],
    options: json["options"] == null ? [] : List<AddonOption>.from(json["options"].map((x) => AddonOption.fromJson(x))),
    required: json["required"] == null ? 0 : json["required"],
    selected: false,
  );

}

class AddonOption {
  AddonOption({
    required this.label,
    required this.price,
    required this.min,
    required this.max,
  });

  String label;
  String price;
  int min;
  int max;

  factory AddonOption.fromJson(Map<String, dynamic> json) => AddonOption(
    label: json["label"] == null ? '' : json["label"],
    price: json["price"] == null ? '' : json["price"],
    min: (json["min"] == null || json["min"] == '') ? 100 : int.parse(json["min"]),
    max: (json["max"] == null || json["max"] == '') ? 1000 : int.parse(json["max"]),
  );

}
