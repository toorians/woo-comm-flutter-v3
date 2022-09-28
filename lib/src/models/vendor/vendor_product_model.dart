import 'dart:convert';

class VendorProductsModel {
  final List<VendorProduct> products;

  VendorProductsModel({
    required this.products,
  });

  factory VendorProductsModel.fromJson(List<dynamic> parsedJson) {

    List<VendorProduct> products = [];
    products = parsedJson.map((i)=>VendorProduct.fromJson(i)).toList();

    return new VendorProductsModel(products : products);
  }

}
// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

List<VendorProduct> productFromJson(String str) => List<VendorProduct>.from(json.decode(str).map((x) => VendorProduct.fromJson(x)));

String productToJson(List<VendorProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VendorProduct {
  int id;
  String name;
  String slug;
  String permalink;
  String type;
  String status;
  bool featured;
  String catalogVisibility;
  String description;
  String shortDescription;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  dynamic dateOnSaleFrom;
  dynamic? dateOnSaleFromGmt;
  dynamic dateOnSaleTo;
  dynamic? dateOnSaleToGmt;
  String priceHtml;
  bool onSale;
  bool purchasable;
  int totalSales;
  bool virtual;
  bool downloadable;
  List<dynamic> downloads;
  int downloadLimit;
  int downloadExpiry;
  String externalUrl;
  String buttonText;
  String taxStatus;
  String taxClass;
  bool manageStock;
  int stockQuantity;
  String stockStatus;
  String backOrders;
  bool backordersAllowed;
  bool backordered;
  bool soldIndividually;
  String weight;
  Dimensions dimensions;
  bool shippingRequired;
  bool shippingTaxable;
  String shippingClass;
  int shippingClassId;
  bool reviewsAllowed;
  String averageRating;
  int ratingCount;
  List<int> relatedIds;
  List<dynamic> upsellIds;
  List<dynamic> crossSellIds;
  int parentId;
  String purchaseNote;
  List<ProductCategory> categories;
  List<dynamic> tags;
  List<ProductImage> images;
  List<Attribute> attributes;
  List<DefaultAttribute> defaultAttributes;
  List<dynamic> variations;
  List<dynamic> groupedProducts;
  int menuOrder;
  List<dynamic> metaData;
  int decimals;
  String? vendor;

  VendorProduct({
    required this.id,
    required this.name,
    required this.slug,
    required this.permalink,
    required this.type,
    required this.status,
    required this.featured,
    required this.catalogVisibility,
    required this.description,
    required this.shortDescription,
    required this.sku,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.dateOnSaleFrom,
    this.dateOnSaleFromGmt,
    required this.dateOnSaleTo,
    this.dateOnSaleToGmt,
    required this.priceHtml,
    required this.onSale,
    required this.purchasable,
    required this.totalSales,
    required this.virtual,
    required this.downloadable,
    required this.downloads,
    required this.downloadLimit,
    required this.downloadExpiry,
    required this.externalUrl,
    required this.buttonText,
    required this.taxStatus,
    required this.taxClass,
    required this.manageStock,
    required this.stockQuantity,
    required this.stockStatus,
    required this.backOrders,
    required this.backordersAllowed,
    required this.backordered,
    required this.soldIndividually,
    required this.weight,
    required this.dimensions,
    required this.shippingRequired,
    required this.shippingTaxable,
    required this.shippingClass,
    required this.shippingClassId,
    required this.reviewsAllowed,
    required this.averageRating,
    required this.ratingCount,
    required this.relatedIds,
    required this.upsellIds,
    required this.crossSellIds,
    required this.parentId,
    required this.purchaseNote,
    required this.categories,
    required this.tags,
    required this.images,
    required this.attributes,
    required this.defaultAttributes,
    required this.variations,
    required this.groupedProducts,
    required this.menuOrder,
    required this.metaData,
    required this.decimals,
    required this.vendor
  });

  factory VendorProduct.fromJson(Map<String, dynamic> json) => VendorProduct(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? '' : json["slug"],
    permalink: json["permalink"] == null ? '' : json["permalink"],
    type: json["type"] == null ? '' : json["type"],
    status: json["status"] == null ? '' : json["status"],
    featured: json["featured"] == null ? false : json["featured"],
    catalogVisibility: json["catalog_visibility"] == null ? '' : json["catalog_visibility"],
    description: json["description"] == null ? '' : json["description"],
    shortDescription: json["short_description"] == null ? '' : json["short_description"],
    sku: json["sku"] == null ? '' : json["sku"],
    price: (json["sale_price"] != null && json["sale_price"] != '') ? json["sale_price"] : json["price"] == null || json["price"] == '' ? '0' : json["price"],
    regularPrice: json["regular_price"] == null  || json["regular_price"] == '' ? '0' : json["regular_price"],
    salePrice: json["sale_price"] == null  || json["sale_price"] == '' ? '0' : json["sale_price"],
    dateOnSaleFrom: json["date_on_sale_from"],
    dateOnSaleFromGmt: json["date_on_sale_from_gmt"] == null ?  null : json["date_on_sale_from_gmt"],
    dateOnSaleTo: json["date_on_sale_to"],
    dateOnSaleToGmt: json["date_on_sale_to_gmt"] == null ?  null : json["date_on_sale_to_gmt"],
    priceHtml: json["price_html"] == null ? '' : json["price_html"],
    onSale: json["on_sale"] == null ? false : json["on_sale"],
    purchasable: json["purchasable"] == null ? false : json["purchasable"],
    totalSales: json["total_sales"] == null ? 0 : int.parse(json["total_sales"].toString()),
    virtual: json["virtual"] == null ? false : json["virtual"],
    downloadable: json["downloadable"] == null ? false : json["downloadable"],
    downloads: json["downloads"] == null ? [] : List<dynamic>.from(json["downloads"].map((x) => x)),
    downloadLimit: json["download_limit"] == null ? 0 : json["download_limit"],
    downloadExpiry: json["download_expiry"] == null ? 0 : json["download_expiry"],
    externalUrl: json["external_url"] == null ? '' : json["external_url"],
    buttonText: json["button_text"] == null ? '' : json["button_text"],
    taxStatus: json["tax_status"] == null ? '' : json["tax_status"],
    taxClass: json["tax_class"] == null ? '' : json["tax_class"],
    manageStock: json["manage_stock"] == null ? false : json["manage_stock"],
    stockQuantity: json["stock_quantity"] == null ? 0 : json["stock_quantity"],
    stockStatus: json["stock_status"] == null ? '' : json["stock_status"],
    backOrders: json["backorders"] == null ? '' : json["backorders"],
    backordersAllowed: json["backorders_allowed"] == null ? false : json["backorders_allowed"],
    backordered: json["backordered"] == null ? false : json["backordered"],
    soldIndividually: json["sold_individually"] == null ? false : json["sold_individually"],
    weight: json["weight"] == null ? '0' : json["weight"],
    dimensions: json["dimensions"] == null ? Dimensions.fromJson({}) : Dimensions.fromJson(json["dimensions"]),
    shippingRequired: json["shipping_required"] == null ? false : json["shipping_required"],
    shippingTaxable: json["shipping_taxable"] == null ? false : json["shipping_taxable"],
    shippingClass: json["shipping_class"] == null ? '' : json["shipping_class"],
    shippingClassId: json["shipping_class_id"] == null ? 0 : json["shipping_class_id"],
    reviewsAllowed: json["reviews_allowed"] == null ? false : json["reviews_allowed"],
    averageRating: json["average_rating"] == null ? '0' : json["average_rating"],
    ratingCount: json["rating_count"] == null ? 0 : json["rating_count"],
    relatedIds: json["related_ids"] == null ? [] : List<int>.from(json["related_ids"].map((x) => x)),
    upsellIds: json["upsell_ids"] == null ? [] : List<dynamic>.from(json["upsell_ids"].map((x) => x)),
    crossSellIds: json["cross_sell_ids"] == null ? [] : List<dynamic>.from(json["cross_sell_ids"].map((x) => x)),
    parentId: json["parent_id"] == null ? 0 : json["parent_id"],
    purchaseNote: json["purchase_note"] == null ? '' : json["purchase_note"],
    categories: json["categories"] == null ? [] : List<ProductCategory>.from(json["categories"].map((x) => ProductCategory.fromJson(x))),
    tags: json["tags"] == null ? [] : List<dynamic>.from(json["tags"].map((x) => x)),
    images: json["images"] == null ? [] : List<ProductImage>.from(json["images"].map((x) => ProductImage.fromJson(x))),
    attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
    defaultAttributes: json["default_attributes"] == null ? [] : List<DefaultAttribute>.from(json["default_attributes"].map((x) => DefaultAttribute.fromJson(x))),
    variations: json["variations"] == null ? [] : List<dynamic>.from(json["variations"].map((x) => x)),
    groupedProducts: json["grouped_products"] == null ? [] : List<dynamic>.from(json["grouped_products"].map((x) => x)),
    menuOrder: json["menu_order"] == null ? 0 : json["menu_order"],
    metaData: json["meta_data"] == null ? [] : List<dynamic>.from(json["meta_data"].map((x) => x)),
    decimals: json["decimals"] == null ? 0 : json["decimals"],
    vendor: json["vendor"].toString()
  );

  Map<String, dynamic> toJson() => {
    "id": id == 0 ? null : id,
    "name": name.isEmpty ? null : name,
    "slug": slug.isEmpty ? null : slug,
    "permalink": permalink.isEmpty ? null : permalink,
    "type": type.isEmpty ? null : type,
    "status": status.isEmpty ? null : status,
    "featured": featured == false ? null : featured,
    "catalog_visibility": catalogVisibility.isEmpty ? null : catalogVisibility,
    "description": description.isEmpty ? null : description,
    "short_description": shortDescription.isEmpty ? null : shortDescription,
    "sku": sku.isEmpty ? null : sku,
    "regular_price": _checkPrice(regularPrice) == true ? null : regularPrice,
    "sale_price": _checkPrice(salePrice) == true ? null : salePrice,
    "date_on_sale_from": dateOnSaleFrom,
    "date_on_sale_from_gmt": dateOnSaleFromGmt,
    "date_on_sale_to": dateOnSaleTo,
    "date_on_sale_to_gmt": dateOnSaleToGmt,
    "price_html": priceHtml.isEmpty ? null : priceHtml,
    "on_sale": onSale == false ? null : onSale,
    "purchasable": purchasable == false ? null : purchasable,
    "total_sales": totalSales == 0 ? null : totalSales,
    "virtual": virtual == false ? null : virtual,
    "downloadable": downloadable == false ? null : downloadable,
    "downloads": downloads.isEmpty ? null : List<dynamic>.from(downloads.map((x) => x)),
    "download_limit": downloadLimit == 0 ? null : downloadLimit,
    "external_url": externalUrl.isEmpty ? null : externalUrl,
    "button_text": buttonText.isEmpty ? null : buttonText,
    "tax_status": taxStatus.isEmpty ? null : taxStatus,
    "tax_class": taxClass.isEmpty ? null : taxClass,
    "manage_stock": manageStock == false ? null : manageStock,
    "stock_quantity": stockQuantity == 0 ? null : stockQuantity,
    "stock_status": stockStatus.isEmpty ? null : stockStatus,
    "backorders": backOrders.isEmpty ? null : backOrders,
    "backorders_allowed": backordersAllowed == false ? null : backordersAllowed,
    "backordered": backordered == false ? null : backordered,
    "sold_individually": soldIndividually == false ? null : soldIndividually,
    "weight": weight.isEmpty ? null : weight,
    "dimensions": dimensions.toJson(),
    "shipping_required": shippingRequired == false ? null : shippingRequired,
    "shipping_taxable": shippingTaxable == false ? null : shippingTaxable,
    "shipping_class": shippingClass.isEmpty ? null : shippingClass,
    "shipping_class_id": shippingClassId == 0 ? null : shippingClassId,
    "reviews_allowed": reviewsAllowed == false ? null : reviewsAllowed,
    "average_rating": averageRating.isEmpty ? null : averageRating,
    "rating_count": ratingCount == 0 ? null : ratingCount,
    "related_ids": relatedIds.isEmpty ? null : List<dynamic>.from(relatedIds.map((x) => x)),
    "upsell_ids": upsellIds.isEmpty ? null : List<dynamic>.from(upsellIds.map((x) => x)),
    "cross_sell_ids": crossSellIds.isEmpty ? null : List<dynamic>.from(crossSellIds.map((x) => x)),
    "parent_id": parentId == 0 ? null : parentId,
    "purchase_note": purchaseNote.isEmpty ? null : purchaseNote,
    "categories": categories.isEmpty ? null : List<dynamic>.from(categories.map((x) => x.toJson())),
    "tags": tags.isEmpty ? null : List<dynamic>.from(tags.map((x) => x)),
    "images": images.isEmpty ? null : List<dynamic>.from(images.map((x) => x.toJson())),
    "attributes": attributes.isEmpty ? null : List<dynamic>.from(attributes.map((x) => x.toJson())),
    "default_attributes": defaultAttributes.isEmpty ? null : List<dynamic>.from(defaultAttributes.map((x) => x.toJson())),
    "variations": variations.isEmpty ? null : List<dynamic>.from(variations.map((x) => x)),
    "grouped_products": groupedProducts.isEmpty ? null : List<dynamic>.from(groupedProducts.map((x) => x)),
    "menu_order": menuOrder == 0 ? null : menuOrder,
    "meta_data": metaData.isEmpty ? null : List<dynamic>.from(metaData.map((x) => x)),
    "vendor": vendor == null ? null : vendor,
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
    this.position = 0,
    this.visible = true,
    required this.variation,
    required this.options,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    position: json["position"] == null ? 0 : json["position"],
    visible: json["visible"] == null ? true : json["visible"],
    variation: json["variation"] == null ? false : json["variation"],
    options: json["options"] == null ? [] : List<String>.from(json["options"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == 0 ? 0 : id,
    "name": name.isEmpty ? null : name,
    "position": position == 0 ? null : position,
    "visible": visible == false ? false : visible,
    "variation": variation == false ? false : variation,
    "options": options.isEmpty ? null : List<dynamic>.from(options.map((x) => x)),
  };
}

class ProductCategory {
  int id;
  String name;
  String slug;

  ProductCategory({
    required this.id,
    required this.name,
    this.slug = '',
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    id: json["id"] == 0 ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    slug: json["slug"] == null ? '' : json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == 0 ? 0 : id,
    "name": name.isEmpty ? null : name,
    "slug": slug.isEmpty ? null : slug,
  };
}

class DefaultAttribute {
  int id;
  String name;
  String option;

  DefaultAttribute({
    required this.id,
    required this.name,
    required this.option,
  });

  factory DefaultAttribute.fromJson(Map<String, dynamic> json) => DefaultAttribute(
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

class ProductImage {
  String src;

  ProductImage({
    required this.src,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    src: json["src"] == null ? null : json["src"],
  );

  Map<String, dynamic> toJson() => {
    "src": src,
  };
}
