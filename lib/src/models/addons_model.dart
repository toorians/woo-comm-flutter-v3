// To parse this JSON data, do
//
//     final addonsModel = addonsModelFromJson(jsonString);

import 'dart:convert';

List<AddonsGroup> addonsGroupFromJson(String str) => List<AddonsGroup>.from(json.decode(str).map((x) => AddonsGroup.fromJson(x)));

class AddonsGroup {
  AddonsGroup({
    required this.name,
    required this.addons,
  });

  String name;
  List<AddonsModel> addons;

  factory AddonsGroup.fromJson(Map<String, dynamic> json) => AddonsGroup(
    name: json["name"] == null ? '' : json["name"],
    addons: json["addons"] == null ? [] : List<AddonsModel>.from(json["addons"].map((x) => AddonsModel.fromJson(x))),
  );
}

List<AddonsModel> addonsModelFromJson(String str) => List<AddonsModel>.from(json.decode(str).map((x) => AddonsModel.fromJson(x)));

class AddonsModel {
  AddonsModel({
    required this.name,
    //required this.titleFormat,
    required this.descriptionEnable,
    required this.description,
    required this.type,
    required this.display,
    required this.position,
    required this.required,
    required this.restrictions,
    required this.restrictionsType,
    required this.adjustPrice,
    //required this.priceType,
    required this.price,
    required this.min,
    required this.max,
    required this.options,
    required this.wcBookingPersonQtyMultiplier,
    required this.wcBookingBlockQtyMultiplier,
    required this.fieldName,
  });

  String name;
  //String titleFormat;
  int descriptionEnable;
  String description;
  String type;
  String display;
  int position;
  int required;
  int restrictions;
  String restrictionsType;
  int adjustPrice;
  //PriceType? priceType;
  String price;
  int min;
  int max;
  List<Option> options;
  int wcBookingPersonQtyMultiplier;
  int wcBookingBlockQtyMultiplier;
  String fieldName;

  factory AddonsModel.fromJson(Map<String, dynamic> json) => AddonsModel(
    name: json["name"] == null ? '' : json["name"],
    //titleFormat: json["title_format"] == null ? null : json["title_format"],
    descriptionEnable: json["description_enable"] == null ? 0 : json["description_enable"],
    description: json["description"] == null ? '' : json["description"],
    type: json["type"] == null ? '' : json["type"],
    display: json["display"] == null ? '' : json["display"],
    position: json["position"] == null ? 0 : json["position"],
    required: json["required"] == null ? 0 : json["required"],
    restrictions: json["restrictions"] == null ? 0 : json["restrictions"],
    restrictionsType: json["restrictions_type"] == null ? '' : json["restrictions_type"],
    adjustPrice: json["adjust_price"] == null ? 0 : json["adjust_price"],
    //priceType: json["price_type"] == null ? null : priceTypeValues.map[json["price_type"]],
    price: json["price"] == null ? '0' : json["price"],
    min: json["min"] == null ? 0 : json["min"],
    max: json["max"] == null ? 1 : json["max"],
    options: json["options"] == null ? [] : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    wcBookingPersonQtyMultiplier: json["wc_booking_person_qty_multiplier"] == null ? 1 : json["wc_booking_person_qty_multiplier"],
    wcBookingBlockQtyMultiplier: json["wc_booking_block_qty_multiplier"] == null ? 1 : json["wc_booking_block_qty_multiplier"],
    fieldName: json["field-name"] == null ? '' : json["field-name"],
  );
}

class Option {
  Option({
    required this.label,
    required this.price,
    this.image,
    //this.priceType,
    required this.key,
  });

  String label;
  String price;
  String? image;
  //PriceType? priceType;
  String key;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    label: json["label"] == null ? '' : json["label"],
    price: json["price"] == null ? null : json["price"],
    image: json["image"] == null ? null : json["image"],
    //priceType: json["price_type"] == null ? null : priceTypeValues.map[json["price_type"]],
    key: json["key"] == null ? null : json["key"],
  );
}

enum PriceType { FLAT_FEE, QUANTITY_BASED }

final priceTypeValues = EnumValues({
  "flat_fee": PriceType.FLAT_FEE,
  "quantity_based": PriceType.QUANTITY_BASED
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
