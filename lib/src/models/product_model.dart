// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:app/src/functions.dart';

import 'addons_model.dart';

List<Product> productModelFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

class Product {
  int id;
  String name;
  String type;
  //String status;
  //bool featured;
  //String catalogVisibility;
  String description;
  String shortDescription;
  String permalink;
  String? sku;
  double price;
  double regularPrice;
  double salePrice;
  //DateTime dateOnSaleFromGmt;
  DateTime dateOnSaleToGmt;
  bool onSale;
  //bool purchasable;
  int totalSales;
  //bool virtual;
  //bool downloadable;
  //String externalUrl;
  //String buttonText;
  //bool manageStock;
  //int stockQuantity;
  String stockStatus;
  //String backorders;
  //bool backordersAllowed;
  //bool backordered;
  //bool soldIndividually;
  String weight;
  //Dimensions dimensions;
  //bool shippingRequired;
  //bool shippingTaxable;
  //String shippingClass;
  //bool reviewsAllowed;
  String averageRating;
  int ratingCount;
  //List<int> relatedIds;
  //List<int> upsellIds;
  //List<int> crossSellIds;
  //int parentId;
  //String purchaseNote;
  //List<int> categories;
  List<String> tags;
  List<Mage> images;
  List<Attribute> attributes;
  //List<dynamic> groupedProducts;
  //int menuOrder;
  //List<MetaDatum> metaData;
  //String storeName;
  List<AvailableVariation> availableVariations;
  List<VariationOption> variationOptions;
  //String variationId;
  String? formattedPrice;
  String? formattedSalesPrice;
  Vendor vendor;
  List<Product> children;
  Booking booking;
  List<AddonsModel> addons;
  String? variationId;
  String addToCartUrl;

  Product({
    required this.id,
    required this.name,
    required this.type,
    //required this.status,
    //required this.featured,
    //required this.catalogVisibility,
    required this.description,
    required this.shortDescription,
    required this.permalink,
    this.sku,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    //required this.dateOnSaleFromGmt,
    required this.dateOnSaleToGmt,
    required this.onSale,
    //required this.purchasable,
    required this.totalSales,
    //required this.virtual,
    //required this.downloadable,
    //required this.externalUrl,
    //required this.buttonText,
    //required this.manageStock,
    //required this.stockQuantity,
    required this.stockStatus,
    required this.weight,
/*    required this.backorders,
    required this.backordersAllowed,
    required this.backordered,
    required this.soldIndividually,

    required this.dimensions,*/
    //required this.shippingRequired,
    //required this.shippingTaxable,
    //required this.shippingClass,
    //required this.reviewsAllowed,
    required this.averageRating,
    required this.ratingCount,
    //required this.relatedIds,
    //required this.upsellIds,
    //required this.crossSellIds,
    //required this.parentId,
    //required this.purchaseNote,
    //required this.categories,
    required this.tags,
    required this.images,
    required this.attributes,
    //required this.groupedProducts,
    //required this.menuOrder,
    //required this.metaData,
    //required this.storeName,
    required this.availableVariations,
    required this.variationOptions,
    //required this.variationId,
    this.formattedPrice,
    this.formattedSalesPrice,
    required this.vendor,
    required this.children,
    required this.booking,
    required this.addons,
    this.variationId,
    required this.addToCartUrl
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    type: json["type"] == null ? '' : json["type"],
    //status: json["status"] == null ? null : json["status"],
    //featured: json["featured"] == null ? null : json["featured"],
    //catalogVisibility: json["catalog_visibility"] == null ? null : json["catalog_visibility"],
    description: json["description"] == null ? '' : json["description"],
    shortDescription: json["short_description"] == null ? '' : json["short_description"],
    permalink: json["permalink"] == null ? '' : json["permalink"],
    sku: json["sku"] == null ? null : json["sku"],
    formattedPrice: json["formated_price"] == null ? '' : json["formated_price"],
    formattedSalesPrice: json["formated_sales_price"] == null ? null : json["formated_sales_price"],
    price: json["price"] == null ? 0 : json["price"].toDouble(),
    regularPrice: json["regular_price"] == null ? 0 : json["regular_price"].toDouble(),
    salePrice: json["sale_price"] == null ? 0 : json["sale_price"].toDouble(),
    //dateOnSaleFromGmt: json["date_on_sale_from_gmt"] == null ? null : DateTime.parse(json["date_on_sale_from_gmt"]),
    dateOnSaleToGmt: json["date_on_sale_to_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_on_sale_to_gmt"]),
    onSale: json["on_sale"] == null ? false : json["on_sale"],
    //purchasable: json["purchasable"] == null ? null : json["purchasable"],
    totalSales: json["total_sales"] == null ? 0 : json["total_sales"],
    stockStatus: json["stock_status"] == null ? 'instock' : json["stock_status"],
    averageRating: json["average_rating"] == null ? '0' : json["average_rating"],
    ratingCount: json["rating_count"] == null ? 0 : json["rating_count"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"].map((x) => x)),
    images: json["images"] == null ? [] : List<Mage>.from(json["images"].map((x) => Mage.fromJson(x))),
    attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
    availableVariations: json["availableVariations"] == null ? [] : List<AvailableVariation>.from(json["availableVariations"].map((x) => AvailableVariation.fromJson(x))),
    variationOptions: json["variationOptions"] == null ? [] : List<VariationOption>.from(json["variationOptions"].map((x) => VariationOption.fromJson(x))),
    variationId: null,
    vendor: json["vendor"] == null ? Vendor.fromJson({}) : Vendor.fromJson(json["vendor"]),
    children: json['children'] == null ? [] : List<Product>.from(json["children"].map((x) => Product.fromJson(x))),
    addons: json["addons"] == null ? [] : List<AddonsModel>.from(json["addons"].map((x) => AddonsModel.fromJson(x))),
    booking: json["booking"] == null ? Booking.fromJson({}) : Booking.fromJson(json["booking"]),
    addToCartUrl: json["add_to_cart_url"] == null ? '' : json["add_to_cart_url"],
    weight: json["weight"] == null ? '' : json["weight"],
    /*virtual: json["virtual"] == null ? null : json["virtual"],
    downloadable: json["downloadable"] == null ? null : json["downloadable"],
    externalUrl: json["external_url"] == null ? null : json["external_url"],
    buttonText: json["button_text"] == null ? null : json["button_text"],
    manageStock: json["manage_stock"] == null ? null : json["manage_stock"],
    stockQuantity: json["stock_quantity"] == null ? null : json["stock_quantity"],

    backorders: json["backorders"] == null ? null : json["backorders"],
    backordersAllowed: json["backorders_allowed"] == null ? null : json["backorders_allowed"],
    backordered: json["backordered"] == null ? null : json["backordered"],
    soldIndividually: json["sold_individually"] == null ? null : json["sold_individually"],

    dimensions: json["dimensions"] == null ? Dimensions.fromJson({}) : Dimensions.fromJson(json["dimensions"]),
    //shippingRequired: json["shipping_required"] == null ? null : json["shipping_required"],
    //shippingTaxable: json["shipping_taxable"] == null ? null : json["shipping_taxable"],
    //shippingClass: json["shipping_class"] == null ? null : json["shipping_class"],
    reviewsAllowed: json["reviews_allowed"] == null ? null : json["reviews_allowed"],
    relatedIds: json["related_ids"] == null ? [] : List<int>.from(json["related_ids"].map((x) => x)),
    upsellIds: json["upsell_ids"] == null ? [] : List<int>.from(json["upsell_ids"].map((x) => x)),
    crossSellIds: json["cross_sell_ids"] == null ? [] : List<int>.from(json["cross_sell_ids"].map((x) => x)),
    //parentId: json["parent_id"] == null ? null : json["parent_id"],
    purchaseNote: json["purchase_note"] == null ? null : json["purchase_note"],
    categories: json["categories"] == null ? [] :  List<int>.from(json["categories"].map((x) => x)),
    groupedProducts: json["grouped_products"] == null ? [] : List<dynamic>.from(json["grouped_products"].map((x) => x)),
    //menuOrder: json["menu_order"] == null ? null : json["menu_order"],
    metaData: json["meta_data"] == null ? [] : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),*/
    //storeName: json["store_name"] == null ? null : json["store_name"],

  );
}

class Booking {
  Booking({
    required this.slots,
    required this.duration,
    required this.durationUnit,
    required this.durationType,
    this.minDuration,
    this.maxDuration,
    this.qty,
    required this.hasPersons,
    required this.minPersons,
    required this.maxPersons,
  });

  List<int> slots;
  int duration;
  DurationUnit? durationUnit;
  DurationType? durationType;
  int? minDuration;
  int? maxDuration;
  int? qty;
  bool hasPersons;
  int minPersons;
  int maxPersons;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    slots: json["slots"] == null ? [] : List<int>.from(json["slots"].map((x) => x)),
    duration: json["duration"] == null ? 0 : json["duration"],
    durationUnit: json["duration_unit"] == null ? null : durationUnitValues.map[json["duration_unit"]],
    durationType: json["duration_type"] == null ? null : durationTypeValues.map[json["duration_type"]],
    minDuration: json["min_duration"] == null ? null : json["min_duration"],
    maxDuration: json["max_duration"] == null ? null : json["max_duration"],
    qty: json["qty"] == null ? null : json["qty"],
    hasPersons: json["has_persons"] == true ? true : false,
    minPersons: json["min_persons"] == null ? 1 : json["min_persons"],
    maxPersons: json["max_persons"] == null ? 10 : json["max_persons"],
  );
}

enum DurationType { FIXED }

final durationTypeValues = EnumValues({
  "fixed": DurationType.FIXED
});

enum DurationUnit { HOUR, DAY }

final durationUnitValues = EnumValues({
  "day": DurationUnit.DAY,
  "hour": DurationUnit.HOUR
});


class Vendor {
  String id;
  String name;
  String icon;
  String? banner;
  String? phone;
  String? UID;

  Vendor({
    required this.id,
    required this.name,
    required this.icon,
    required this.phone,
    this.banner,
    this.UID
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
    id: isNumeric(json["id"].toString()) ? json["id"].toString() : '0',
    name: json["name"] == null ? '' : json["name"],
    icon: json["icon"] == null || json["icon"] == false ? '' : json["icon"],
    banner: json["banner"] == null || json["banner"] == false ? '' : json["banner"],
    phone: json["phone"] == null ? '' : json["phone"],
    UID: json["UID"] == null ? null : json["UID"],
  );
}

class Attribute {
  int id;
  String name;
  int position;
  bool visible;
  bool variation;
  List<String> options;

  Attribute({
    required this.id,
    required this.name,
    required this.position,
    required this.visible,
    required this.variation,
    required this.options,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    position: json["position"] == null ? 0 : json["position"],
    visible: json["visible"] == null ? false : json["visible"],
    variation: json["variation"] == null ? false : json["variation"],
    options: json["options"] == null ? [] : List<String>.from(json["options"].map((x) => x)),
  );
}

class ProductCategory {
  int id;
  String name;
  String slug;

  ProductCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? '' : json["slug"],
  );
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
}

class Mage {
  int id;
  String src;
  String name;
  String alt;

  Mage({
    required this.id,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory Mage.fromJson(Map<String, dynamic> json) => Mage(
    id: json["id"] == null ? 0 : json["id"],
    src: json["src"] == null ? '' : json["src"],
    name: json["name"] == null ? '' : json["name"],
    alt: json["alt"] == null ? '' : json["alt"],
  );
}

class MetaDatum {
  int id;
  String key;
  dynamic value;

  MetaDatum({
    required this.id,
    required this.key,
    required this.value,
  });

  factory MetaDatum.fromJson(Map<String, dynamic> json) => MetaDatum(
    id: json["id"] == null ? 0 : json["id"],
    key: json["key"] == null ? '' : json["key"],
    value: json["value"],
  );
}

class AvailableVariation {
  //String availabilityHtml;
  bool backordersAllowed;
  Dimensions dimensions;
  //String dimensionsHtml;
  double? displayPrice;
  double? displayRegularPrice;
  AvailableVariationImage image;
  //String imageId;
  //bool isDownloadable;
  bool isInStock;
  bool isPurchasable;
/*  String isSoldIndividually;
  bool isVirtual;
  int maxQty;
  int minQty;
  String priceHtml;*/
  String sku;
  String variationDescription;
  int variationId;
  /*bool variationIsActive;
  bool variationIsVisible;
  String weight;
  String weightHtml;*/
  List<Option> option;
  String? formattedPrice;
  String? formattedSalesPrice;

  AvailableVariation({
    //required this.availabilityHtml,
    required this.backordersAllowed,
    required this.dimensions,
    //required this.dimensionsHtml,
    required this.displayPrice,
    required this.displayRegularPrice,
    required this.image,
    //required this.imageId,
    //required this.isDownloadable,
    required this.isInStock,
    required this.isPurchasable,
    /*required this.isSoldIndividually,
    required this.isVirtual,
    required this.maxQty,
    required this.minQty,
    required this.priceHtml,*/
    required this.sku,
    required this.variationDescription,
    required this.variationId,
    /*required this.variationIsActive,
    required this.variationIsVisible,
    required this.weight,
    required this.weightHtml,*/
    required this.option,
    required this.formattedPrice,
    required this.formattedSalesPrice
  });

  factory AvailableVariation.fromJson(Map<String, dynamic> json) {
    return AvailableVariation(
    //availabilityHtml: json["availability_html"] == null ? null : json["availability_html"],
    backordersAllowed: json["backorders_allowed"] == null ? false : json["backorders_allowed"],
    dimensions: json["dimensions"] == null ? Dimensions.fromJson({}) : Dimensions.fromJson(json["dimensions"]),
    //dimensionsHtml: json["dimensions_html"] == null ? null : json["dimensions_html"],
    displayPrice: json["display_price"] == null ? 0 : json["display_price"].toDouble(),
    displayRegularPrice: json["display_regular_price"] == null ? 0 : json["display_regular_price"].toDouble(),
    image: json['image'] is Map<String, dynamic> ? AvailableVariationImage.fromJson(json["image"]) : AvailableVariationImage.fromJson({}),
    //imageId: json["image_id"] == null ? null : json["image_id"],
    //isDownloadable: json["is_downloadable"] == null ? null : json["is_downloadable"],
    isInStock: json["is_in_stock"] == null ? false : json["is_in_stock"],
    isPurchasable: json["is_purchasable"] == null ? false : json["is_purchasable"],
    //isSoldIndividually: json["is_sold_individually"] == null ? null : json["is_sold_individually"],
    //isVirtual: json["is_virtual"] == null ? null : json["is_virtual"],
    //maxQty: (json["max_qty"] == null || json["max_qty"] == '') ? null : json["max_qty"],
    //minQty: json["min_qty"] == null ? null : json["min_qty"],
    //priceHtml: json["price_html"] == null ? null : json["price_html"],
    sku: json["sku"] == null ? '' : json["sku"],
    variationDescription: json["variation_description"] == null ? '' : json["variation_description"],
    variationId: json["variation_id"] == null ? 0 : json["variation_id"],
    //variationIsActive: json["variation_is_active"] == null ? null : json["variation_is_active"],
    //variationIsVisible: json["variation_is_visible"] == null ? null : json["variation_is_visible"],
    //weight: json["weight"] == null ? null : json["weight"],
    //weightHtml: json["weight_html"] == null ? null : json["weight_html"],
    option: json["option"] == null ? [] : List<Option>.from(json["option"].map((x) => Option.fromJson(x))),
    formattedPrice: json["formated_price"] == null ? null : json["formated_price"],
    formattedSalesPrice: json["formated_sales_price"] == null ? null : json["formated_sales_price"],
  );
  }
}

class Option {
  String key;
  String value;
  String slug;

  Option({
    required this.key,
    required this.value,
    required this.slug
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    key: json["key"] == null ? '' : json["key"],
    value: json["value"] == null ? '' : json["value"],
    slug: json["slug"] == null ? '' : json["slug"],
  );
}

class AvailableVariationImage {
  String title;
  //String caption;
  String url;
  //String alt;
  String src;
  //String srcset;
  //String sizes;
  String fullSrc;
  //int fullSrcW;
  //int fullSrcH;
  String galleryThumbnailSrc;
  //int galleryThumbnailSrcW;
  //int galleryThumbnailSrcH;
  String thumbSrc;
  /*int thumbSrcW;
  int thumbSrcH;
  int srcW;
  int srcH;*/

  AvailableVariationImage({
    required this.title,
    //required this.caption,
    required this.url,
    //required this.alt,
    required this.src,
    //required this.srcset,
    //required this.sizes,
    required this.fullSrc,
    //required this.fullSrcW,
    //required this.fullSrcH,
    required this.galleryThumbnailSrc,
    //required this.galleryThumbnailSrcW,
    //required this.galleryThumbnailSrcH,
    required this.thumbSrc,
    /*required this.thumbSrcW,
    required this.thumbSrcH,
    required this.srcW,
    required this.srcH,*/
  });

  factory AvailableVariationImage.fromJson(Map<String, dynamic> json) => AvailableVariationImage(
    title: json["title"] == null ? '' : json["title"],
    //caption: json["caption"] == null ? null : json["caption"],
    url: json["url"] == null ? '' : json["url"],
    //alt: json["alt"] == null ? null : json["alt"],
    src: json["src"] == null ? '' : json["src"],
    //srcset: json["srcset"] == null ? null : json["srcset"],
    //sizes: json["sizes"] == null ? null : json["sizes"],
    fullSrc: json["full_src"] == null ? '' : json["full_src"],
    //fullSrcW: json["full_src_w"] == null ? null : json["full_src_w"],
    //fullSrcH: json["full_src_h"] == null ? null : json["full_src_h"],
    galleryThumbnailSrc: json["gallery_thumbnail_src"] == null ? '' : json["gallery_thumbnail_src"],
    //galleryThumbnailSrcW: json["gallery_thumbnail_src_w"] == null ? null : json["gallery_thumbnail_src_w"],
    //galleryThumbnailSrcH: json["gallery_thumbnail_src_h"] == null ? null : json["gallery_thumbnail_src_h"],
    thumbSrc: json["thumb_src"] == null ? '' : json["thumb_src"],
    //thumbSrcW: json["thumb_src_w"] == null ? null : json["thumb_src_w"],
    //thumbSrcH: json["thumb_src_h"] == null ? null : json["thumb_src_h"],
    //srcW: json["src_w"] == null ? null : json["src_w"],
    //srcH: json["src_h"] == null ? null : json["src_h"],
  );
}

class VariationOption {
  String name;
  //List<String> options;
  List<OptionList> optionList;
  String attribute;
  String? selected;
  String? attributeType;

  VariationOption({
    required this.name,
    //required this.options,
    required this.optionList,
    required this.attribute,
    this.selected,
    this.attributeType
  });

  factory VariationOption.fromJson(Map<String, dynamic> json) => VariationOption(
    name: json["name"] == null ? '' : json["name"],
    //options: json["options"] == null ? [] : List<String>.from(json["options"].map((x) => x)),
    optionList: json["option_list"] == null ? [] : List<OptionList>.from(json["option_list"].map((x) => OptionList.fromJson(x))),
    attribute: json["attribute"] == null ? false : json["attribute"],
    selected: null,
    attributeType: json["attribute_type"] == null ? null : json["attribute_type"],
  );
}

class OptionList {
  OptionList({
    required this.name,
    required this.slug,
    this.color,
    this.image,
  });

  String name;
  String slug;
  String? color;
  String? image;

  factory OptionList.fromJson(Map<String, dynamic> json) => OptionList(
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? '' : json["slug"],
    color: json["color"] == null ? null : json["color"],
    image: json["image"] == null ?  null : json["image"],
  );
}

