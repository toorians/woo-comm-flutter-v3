// To parse this JSON data, do
//
//     final productVariation = productVariationFromJson(jsonString);

import 'dart:convert';

List<ProductVariation> productVariationFromJson(String str) => List<ProductVariation>.from(json.decode(str).map((x) => ProductVariation.fromJson(x)));

class ProductVariation {
  int id;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  DateTime dateModified;
  DateTime dateModifiedGmt;
  String description;
  String permalink;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  dynamic dateOnSaleFrom;
  dynamic dateOnSaleFromGmt;
  dynamic dateOnSaleTo;
  dynamic dateOnSaleToGmt;
  bool onSale;
  String status;
  bool purchasable;
  bool virtual;
  bool downloadable;
  List<dynamic> downloads;
  int downloadLimit;
  int downloadExpiry;
  String taxStatus;
  String taxClass;
  bool manageStock;
  dynamic stockQuantity;
  String stockStatus;
  String backorders;
  bool backordersAllowed;
  bool backordered;
  String weight;
  Dimensions dimensions;
  String shippingClass;
  int shippingClassId;
  VariationImage image;
  List<VariationAttribute> attributes;
  int menuOrder;
  List<dynamic> metaData;

  ProductVariation({
    required this.id,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.description,
    required this.permalink,
    required this.sku,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.dateOnSaleFrom,
    required this.dateOnSaleFromGmt,
    required this.dateOnSaleTo,
    required this.dateOnSaleToGmt,
    required this.onSale,
    required this.status,
    required this.purchasable,
    required this.virtual,
    required this.downloadable,
    required this.downloads,
    required this.downloadLimit,
    required this.downloadExpiry,
    required this.taxStatus,
    required this.taxClass,
    required this.manageStock,
    required this.stockQuantity,
    required this.stockStatus,
    required this.backorders,
    required this.backordersAllowed,
    required this.backordered,
    required this.weight,
    required this.dimensions,
    required this.shippingClass,
    required this.shippingClassId,
    required this.image,
    required this.attributes,
    required this.menuOrder,
    required this.metaData,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) => ProductVariation(
    id: json["id"] == null ? 0 : json["id"],
    dateCreated: json["date_created"] == null ? DateTime.now() : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_created_gmt"]),
    dateModified: json["date_modified"] == null ? DateTime.now() : DateTime.parse(json["date_modified"]),
    dateModifiedGmt: json["date_modified_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_modified_gmt"]),
    description: json["description"] == null ? '' : json["description"],
    permalink: json["permalink"] == null ? '' : json["permalink"],
    sku: json["sku"] == null ? '' : json["sku"],
    price: json["price"] == null || json["price"] == '' ? '0' : json["price"],
    regularPrice: json["regular_price"] == null || json["price"] == '' ? '0' : json["regular_price"],
    salePrice: json["sale_price"] == null ? '0' : json["sale_price"],
    dateOnSaleFrom: json["date_on_sale_from"],
    dateOnSaleFromGmt: json["date_on_sale_from_gmt"] == null ?  null : json["date_on_sale_from_gmt"],
    dateOnSaleTo: json["date_on_sale_to"],
    dateOnSaleToGmt: json["date_on_sale_to_gmt"] == null ?  null : json["date_on_sale_to_gmt"],
    onSale: json["on_sale"] == null ? false : json["on_sale"],
    status: json["status"] == null ? '' : json["status"],
    purchasable: json["purchasable"] == null ? false : json["purchasable"],
    virtual: json["virtual"] == null ? false : json["virtual"],
    downloadable: json["downloadable"] == null ? false : json["downloadable"],
    downloads: json["downloads"] == null ? [] : List<dynamic>.from(json["downloads"].map((x) => x)),
    downloadLimit: json["download_limit"] == null ? 0 : json["download_limit"],
    downloadExpiry: json["download_expiry"] == null ? 0 : json["download_expiry"],
    taxStatus: json["tax_status"] == null ? '' : json["tax_status"],
    taxClass: json["tax_class"] == null ? '' : json["tax_class"],
    manageStock: json["manage_stock"] is bool ? json["manage_stock"] : true,
    stockQuantity: json["stock_quantity"],
    stockStatus: json["stock_status"] == null ? '' : json["stock_status"],
    backorders: json["backorders"] == null ? '' : json["backorders"],
    backordersAllowed: json["backorders_allowed"] == null ? false : json["backorders_allowed"],
    backordered: json["backordered"] == null ? false : json["backordered"],
    weight: json["weight"] == null ? '0' : json["weight"],
    dimensions: json["dimensions"] == null ? Dimensions.fromJson({}) : Dimensions.fromJson(json["dimensions"]),
    shippingClass: json["shipping_class"] == null ? '' : json["shipping_class"],
    shippingClassId: json["shipping_class_id"] == null ? 0 : json["shipping_class_id"],
    image: json["image"] == null ? VariationImage.fromJson({}) : VariationImage.fromJson(json["image"]),
    attributes: json["attributes"] == null ? [] : List<VariationAttribute>.from(json["attributes"].map((x) => VariationAttribute.fromJson(x))),
    menuOrder: json["menu_order"] == null ? 0 : json["menu_order"],
    metaData: json["meta_data"] == null ? [] : List<dynamic>.from(json["meta_data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    //"date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    //"date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    //"date_modified": dateModified == null ? null : dateModified.toIso8601String(),
    //"date_modified_gmt": dateModifiedGmt == null ? null : dateModifiedGmt.toIso8601String(),
    "description": description.isEmpty ? null : description,
    "permalink": permalink.isEmpty ? null : permalink,
    "sku": sku.isEmpty ? null : sku,
    "price": _checkPrice(price) == true ? null : price,
    "regular_price": _checkPrice(regularPrice) == true ? null : regularPrice,
    "sale_price": _checkPrice(salePrice) == true ?  null : salePrice,
    "date_on_sale_from": dateOnSaleFrom,
    "date_on_sale_from_gmt": dateOnSaleFromGmt,
    "date_on_sale_to": dateOnSaleTo,
    "date_on_sale_to_gmt": dateOnSaleToGmt,
    "on_sale": onSale == false ? false : onSale,
    "status": status.isEmpty ? null : status,
    "purchasable": purchasable == false ? false : purchasable,
    "virtual": virtual == false ? false : virtual,
    "downloadable": downloadable == false ? false : downloadable,
    //"downloads": downloads == null ? null : List<dynamic>.from(downloads.map((x) => x)),
    "download_limit": downloadLimit == 0 ? 0 : downloadLimit,
    //"download_expiry": downloadExpiry == null ? null : downloadExpiry,
    "tax_status": taxStatus.isEmpty ? null : taxStatus,
    "tax_class": taxClass.isEmpty ? null : taxClass,
    "manage_stock": manageStock == false ? false : manageStock,
    "stock_quantity": stockQuantity,
    "stock_status": stockStatus.isEmpty ? null : stockStatus,
    "backorders": backorders.isEmpty ? null : backorders,
    "backorders_allowed": backordersAllowed == false ? false : backordersAllowed,
    "backordered": backordered == false ? false : backordered,
    "weight": weight.isEmpty ? null : weight,
    //"dimensions": dimensions == null ? null : dimensions.toJson(),
    "shipping_class": shippingClass.isEmpty ? null : shippingClass,
    "shipping_class_id": shippingClassId == 0 ? null : shippingClassId,
    "image": image.toJson(),
    "attributes": attributes.isEmpty ? null : List<dynamic>.from(attributes.map((x) => x.toJson())),
    "menu_order": menuOrder == 0 ? 0 : menuOrder,
    //"meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x)),
    //"_links": links == null ? null : links.toJson(),
  };

  bool _checkPrice(dynamic price) {
    if(price == null) {
      return true;
    } else if(price.isEmpty) {
      return false;
    } else if(double.parse(price.toString()) == 0) {
      return true;
    } else return false;
  }
}

class VariationAttribute {
  int id;
  String name;
  String option;

  VariationAttribute({
    required this.id,
    required this.name,
    required this.option,
  });

  factory VariationAttribute.fromJson(Map<String, dynamic> json) => VariationAttribute(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    option: json["option"] == null ? '' : json["option"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == 0 ? 0 : id,
    "name": name.isEmpty ? null : name,
    "option": option.isEmpty ? null : option,
  };
}

class Dimensions {
  String length;
  String width;
  String height;

  Dimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    length: json["length"] == null ? '' : json["length"],
    width: json["width"] == null ? '' : json["width"],
    height: json["height"] == null ? '' : json["height"],
  );

  Map<String, dynamic> toJson() => {
    "length": length.isEmpty ? null : length,
    "width": width.isEmpty ? null : width,
    "height": height.isEmpty ? null : height,
  };
}

class VariationImage {
  int id;
  String src;
  String name;
  String alt;

  VariationImage({
    required this.id,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory VariationImage.fromJson(Map<String, dynamic> json) => VariationImage(
    id: json["id"] == null ? 0 : json["id"],
    src: json["src"] == null ? '' : json["src"],
    name: json["name"] == null ? '' : json["name"],
    alt: json["alt"] == null ? '' : json["alt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == 0 ? 0 : id,
    "src": src.isEmpty ? null : src,
    "name": name.isEmpty ? null : name,
    "alt": alt.isEmpty ? null : alt,
  };
}
