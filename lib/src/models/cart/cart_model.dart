// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

CartModel cartFromJson(String str) => CartModel.fromJson(json.decode(str));

class CartModel {
  /*List<dynamic> appliedCoupons;
  String taxDisplayCart;
  CartSessionData cartSessionData;
  List<dynamic> couponAppliedCount;
  List<dynamic> couponDiscountTotals;
  List<dynamic> couponDiscountTaxTotals;*/
  List<CartContent> cartContents;
  String cartNonce;
  CartTotals cartTotals;
  //List<dynamic> chosenShipping;
  Points? points;
  //int purchasePoint;
  String currency;
  List<CartFee> cartFees;
  List<Coupon> coupons;

  CartModel({
    /*required this.appliedCoupons,
    required this.taxDisplayCart,
    required this.cartSessionData,
    required this.couponAppliedCount,
    required this.couponDiscountTotals,
    required this.couponDiscountTaxTotals,*/
    required this.cartContents,
    required this.cartNonce,
    required this.cartTotals,
    //required this.chosenShipping,
    required this.points,
    //required this.purchasePoint,
    required this.currency,
    required this.cartFees,
    required this.coupons
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      //appliedCoupons: json["applied_coupons"] == null ? null : new List<dynamic>.from(json["applied_coupons"].map((x) => x)),
      //taxDisplayCart: json["tax_display_cart"] == null ? null : json["tax_display_cart"],
      //cartSessionData: json["cart_session_data"] == null ? null : CartSessionData.fromJson(json["cart_session_data"]),
      //couponAppliedCount: json["coupon_applied_count"] == null ? null : new List<dynamic>.from(json["coupon_applied_count"].map((x) => x)),
      //couponDiscountTotals: json["coupon_discount_totals"] == null ? null : new List<dynamic>.from(json["coupon_discount_totals"].map((x) => x)),
      //couponDiscountTaxTotals: json["coupon_discount_tax_totals"] == null ? null : new List<dynamic>.from(json["coupon_discount_tax_totals"].map((x) => x)),
      cartContents: json["cartContents"] == null ? [] : List<CartContent>.from(json["cartContents"].map((x) => CartContent.fromJson(x))),
      cartNonce: json["cart_nonce"] == null ? '' : json["cart_nonce"],
      cartTotals: json["cart_totals"] == null ? CartTotals.fromJson({}) : CartTotals.fromJson(json["cart_totals"]),
      //chosenShipping: (json["chosen_shipping"] == false || json["chosen_shipping"] == null) ? null : new List<dynamic>.from(json["chosen_shipping"].map((x) => x)),
      points: json["points"] == null ? null : Points.fromJson(json["points"]),
      //purchasePoint: json["purchase_point"] == null ? null : json["purchase_point"],
      currency: json["currency"] == null ? 'USD' : json["currency"],
      cartFees: json["cart_fees"] == null ? [] : List<CartFee>.from(json["cart_fees"].map((x) => CartFee.fromJson(x))),
      coupons: json["coupons"] == null ? [] : List<Coupon>.from(json["coupons"].map((x) => Coupon.fromJson(x))),
    );
  }
}

class CartFee {
  CartFee({
    required this.id,
    required this.name,
    required this.total,
  });

  String id;
  String name;
  String total;

  factory CartFee.fromJson(Map<String, dynamic> json) => CartFee(
    id: json["id"] == null ? '0' : json["id"].toString(),
    name: json["name"] == null ? '' : json["name"],
    total: json["total"] == null ? '0' : json["total"],
  );
}

class Coupon {
  Coupon({
    required this.code,
    required this.amount,
    required this.label
  });

  String code;
  String amount;
  String label;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    code: json["code"] == null ? '0' : json["code"].toString(),
    amount: json["amount"] == null ? '0' : json["amount"],
    label: json["label"] == null ? 'Discount' : json["label"],
  );
}

class LineTaxData {
  List<dynamic> subtotal;
  List<dynamic> total;

  LineTaxData({
    required this.subtotal,
    required this.total,
  });

  factory LineTaxData.fromJson(Map<String, dynamic> json) => new LineTaxData(
    subtotal: json["subtotal"] == null ? [] : List<dynamic>.from(json["subtotal"].map((x) => x)),
    total: json["total"] == null ? [] : List<dynamic>.from(json["total"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "subtotal": subtotal == null ? null : new List<dynamic>.from(subtotal.map((x) => x)),
    "total": total == null ? null : new List<dynamic>.from(total.map((x) => x)),
  };
}

class VariationClass {
  String attributePaColor;
  String attributePaSize;

  VariationClass({
    required this.attributePaColor,
    required this.attributePaSize,
  });

  factory VariationClass.fromJson(Map<String, dynamic> json) => new VariationClass(
    attributePaColor: json["attribute_pa_Color"] == null ? null : json["attribute_pa_Color"],
    attributePaSize: json["attribute_pa_Size"] == null ? null : json["attribute_pa_Size"],
  );

  Map<String, dynamic> toJson() => {
    "attribute_pa_Color": attributePaColor == null ? null : attributePaColor,
    "attribute_pa_Size": attributePaSize == null ? null : attributePaSize,
  };
}

class CartContent {
  List<Addon> addons;
  String key;
  int productId;
  int variationId;
  dynamic variation;
  int quantity;
  //String dataHash;
  //LineTaxData lineTaxData;
  //double lineSubtotal;
  //double lineSubtotalTax;
  //double lineTotal;
  //double lineTax;
  //Data data;
  String name;
  String thumb;
  //String removeUrl;
  double price;
  //double taxPrice;
  //double regularPrice;
  //double salesPrice;
  bool loadingQty;
  String formattedPrice;
  String formattedSalesPrice;
  //int parentId;
  bool managingStock;
  int stockQuantity;
  Booking booking;
  String? cartItemData;

  CartContent({
    required this.addons,
    required this.key,
    required this.productId,
    required this.variationId,
    required this.variation,
    required this.quantity,
    //required this.dataHash,
    //required this.lineTaxData,
    //required this.lineSubtotal,
    //required this.lineSubtotalTax,
    //required this.lineTotal,
    //required this.lineTax,
    //required this.data,
    required this.name,
    required this.thumb,
    //required this.removeUrl,
    required this.price,
    //required this.taxPrice,
    //required this.regularPrice,
    //required this.salesPrice,
    required this.loadingQty,
    required this.formattedPrice,
    required this.formattedSalesPrice,
    //required this.parentId,
    required this.managingStock,
    required this.stockQuantity,
    required this.booking,
    this.cartItemData
  });

  factory CartContent.fromJson(Map<String, dynamic> json) => new CartContent(
    addons: json["addons"] == null ? [] : List<Addon>.from(json["addons"].map((x) => Addon.fromJson(x))),
    key: json["key"] == null ? '' : json["key"],
    productId: json["product_id"] == null ? 0 : json["product_id"],
    variationId: json["variation_id"] == null ? 0 : json["variation_id"],
    variation: json["variation"],
    quantity: json["quantity"] == null ? 0 : json["quantity"] is int ? json["quantity"] : int.parse(json["quantity"]),
    //dataHash: json["data_hash"] == null ? null : json["data_hash"],
    //lineTaxData: json["line_tax_data"] == null ? null : LineTaxData.fromJson(json["line_tax_data"]),
    //lineSubtotal: json["line_subtotal"] == null ? null : json["line_subtotal"].toDouble(),
    //lineSubtotalTax: json["line_subtotal_tax"] == null ? null : json["line_subtotal_tax"].toDouble(),
    //lineTotal: json["line_total"] == null ? null : json["line_total"].toDouble(),
    //lineTax: json["line_tax"] == null ? null : json["line_tax"].toDouble(),
    //data: json["data"] == null ? Data.fromJson({}) : Data.fromJson(json["data"]),
    name: json["name"] == null ? '' : json["name"],
    thumb: (json["thumb"] == null || json["thumb"] == false) ? '' : json["thumb"],
    //removeUrl: json["remove_url"] == null ? null : json["remove_url"],
    price: json["price"] == null ? 0 : json["price"].toDouble(),
    //taxPrice: json["tax_price"] == null ? null : json["tax_price"],
    //regularPrice: json["regular_price"] == null ? null : json["regular_price"].toDouble(),
    //salesPrice: json["sales_price"] == null ? null : json["sales_price"].toDouble(),
    formattedPrice: json["formated_price"] == null ? '' : json["formated_price"],
    formattedSalesPrice: json["formated_sales_price"] == null ? '' : json["formated_sales_price"],
    loadingQty: false,
    //parentId: json["parent_id"] == null ? null : json["parent_id"],
    managingStock: json["managing_stock"] is bool ? json["managing_stock"] : false,
    stockQuantity: json["stock_quantity"] == null ? 1 : json["stock_quantity"],
    booking: json["booking"] == null ? Booking.fromJson({}) : Booking.fromJson(json["booking"]),
    cartItemData: json["cart_item_data"] == null || json["cart_item_data"] == '' ? null : json["cart_item_data"],
  );

}

class Addon {
  Addon({
    required this.name,
    this.value,
    required this.price,
  });

  String name;
  dynamic value;
  double price;

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
    name: json["name"] == null ? null : json["name"],
    value: json["value"] == null ? null : json["value"],
    price: json["price"] == null ? null : json["price"].toDouble(),
  );
}

class Booking {
  Booking({
    required this.date,
    required this.time,
    required this.cost
  });

  String date;
  String time;
  int cost;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    date: json["date"] == null ? '' : json["date"],
    time: json["time"] == null ? '' : json["time"],
    cost: json["_cost"] == null ? 0 : json["_cost"],
  );
}

class CartSessionData {
  int cartContentsTotal;
  int total;
  int subtotal;
  int subtotalExTax;
  int taxTotal;
  List<dynamic> taxes;
  List<dynamic> shippingTaxes;
  int discountCart;
  int discountCartTax;
  int shippingTotal;
  int shippingTaxTotal;
  List<dynamic> couponDiscountAmounts;
  List<dynamic> couponDiscountTaxAmounts;
  int feeTotal;
  List<dynamic> fees;

  CartSessionData({
    required this.cartContentsTotal,
    required this.total,
    required this.subtotal,
    required this.subtotalExTax,
    required this.taxTotal,
    required this.taxes,
    required this.shippingTaxes,
    required this.discountCart,
    required this.discountCartTax,
    required this.shippingTotal,
    required this.shippingTaxTotal,
    required this.couponDiscountAmounts,
    required this.couponDiscountTaxAmounts,
    required this.feeTotal,
    required this.fees,
  });

  factory CartSessionData.fromJson(Map<String, dynamic> json) => new CartSessionData(
    cartContentsTotal: json["cart_contents_total"] == null ? null : json["cart_contents_total"],
    total: json["total"] == null ? null : json["total"],
    subtotal: json["subtotal"] == null ? null : json["subtotal"],
    subtotalExTax: json["subtotal_ex_tax"] == null ? null : json["subtotal_ex_tax"],
    taxTotal: json["tax_total"] == null ? null : json["tax_total"],
    taxes: json["taxes"] == null ? [] : new List<dynamic>.from(json["taxes"].map((x) => x)),
    shippingTaxes: json["shipping_taxes"] == null ? [] : new List<dynamic>.from(json["shipping_taxes"].map((x) => x)),
    discountCart: json["discount_cart"] == null ? null : json["discount_cart"],
    discountCartTax: json["discount_cart_tax"] == null ? null : json["discount_cart_tax"],
    shippingTotal: json["shipping_total"] == null ? null : json["shipping_total"],
    shippingTaxTotal: json["shipping_tax_total"] == null ? null : json["shipping_tax_total"],
    couponDiscountAmounts: json["coupon_discount_amounts"] == null ? [] : new List<dynamic>.from(json["coupon_discount_amounts"].map((x) => x)),
    couponDiscountTaxAmounts: json["coupon_discount_tax_amounts"] == null ? [] : new List<dynamic>.from(json["coupon_discount_tax_amounts"].map((x) => x)),
    feeTotal: json["fee_total"] == null ? null : json["fee_total"],
    fees: json["fees"] == null ? [] : new List<dynamic>.from(json["fees"].map((x) => x)),
  );
}

class CartTotals {
  String subtotal;
  String subtotalTax;
  String shippingTotal;
  //String shippingTax;
  //List<dynamic> shippingTaxes;
  String discountTotal;
  //String discountTax;
  String cartContentsTotal;
  //String cartContentsTax;
  //List<dynamic> cartContentsTaxes;
  String feeTotal;
  //String feeTax;
  //List<dynamic> feeTaxes;
  String total;
  String totalTax;

  CartTotals({
    required this.subtotal,
    required this.subtotalTax,
    required this.shippingTotal,
    //required this.shippingTax,
    //required this.shippingTaxes,
    required this.discountTotal,
    //required this.discountTax,
    required this.cartContentsTotal,
    //required this.cartContentsTax,
    //required this.cartContentsTaxes,
    required this.feeTotal,
    //required this.feeTax,
    //required this.feeTaxes,
    required this.total,
    required this.totalTax,
  });

  factory CartTotals.fromJson(Map<String, dynamic> json) => new CartTotals(
    subtotal: json["subtotal"] == null ? '0' : json["subtotal"],
    subtotalTax: (json["subtotal_tax"] == null || json["subtotal_tax"] == 0) ? '0' : json["subtotal_tax"],
    shippingTotal: (json["shipping_total"] == null || json["shipping_total"] == 0) ? '0' : json["shipping_total"],
    //shippingTax: json["shipping_tax"] == null ? null : json["shipping_tax"],
    //shippingTaxes: json["shipping_taxes"] == null ? null : new List<dynamic>.from(json["shipping_taxes"].map((x) => x)),
    discountTotal: json["discount_total"] == null ? '0' : json["discount_total"].toString(),
    //discountTax: json["discount_tax"] == null ? null : json["discount_tax"],
    cartContentsTotal: (json["cart_contents_total"] == null || json["cart_contents_total"] == 0) ? '0' : json["cart_contents_total"],
    //cartContentsTax: json["cart_contents_tax"] == null ? null : json["cart_contents_tax"],
    //cartContentsTaxes: json["cart_contents_taxes"] == null ? null : new List<dynamic>.from(json["cart_contents_taxes"].map((x) => x)),
    feeTotal: (json["cart_contents_total"] == null || json["cart_contents_total"] == 0) ? '0' : json["fee_total"],
    //feeTax: json["fee_tax"] == null ? null : json["fee_tax"],
    //feeTaxes: json["fee_taxes"] == null ? null : new List<dynamic>.from(json["fee_taxes"].map((x) => x)),
    total: (json["total"] == null || json["total"] == 0) ? '0' : json["total"],
    totalTax: json["total_tax"] == null ? '0' : json["total_tax"].toString(),
  );

}

class Points {
  Points({
    required this.points,
    required this.discountAvailable,
    required this.message,
    required this.pointEarned,
    required this.earnPointsMessage,
  });

  int points;
  double discountAvailable;
  String message;
  double pointEarned;
  String earnPointsMessage;

  factory Points.fromJson(Map<String, dynamic> json) => Points(
    points: json["points"] == null ? 0 : json["points"],
    discountAvailable: json["discount_available"] == null ? 0.0 : double.parse(json["discount_available"].toString()),
    message: json["message"] == null ? '' : json["message"],
    pointEarned: json["points_earned"] == null ? 0 : double.parse(json["points_earned"].toString()),
    earnPointsMessage: json["earn_points_message"] == null ? '' : json["earn_points_message"],
  );
}

class Content {
  List<dynamic> addons;
  String key;
  int productId;
  int variationId;
  dynamic variation;
  int quantity;
  //String dataHash;
  //LineTaxData lineTaxData;
  //int lineSubtotal;
  //int lineSubtotalTax;
  //int lineTotal;
  //int lineTax;
  //Data data;

  Content({
    required this.addons,
    required this.key,
    required this.productId,
    required this.variationId,
    required this.variation,
    required this.quantity,
    //required this.dataHash,
    //required this.lineTaxData,
    //required this.lineSubtotal,
    //required this.lineSubtotalTax,
    //required this.lineTotal,
    //required this.lineTax,
    //required this.data,
  });

  factory Content.fromJson(Map<String, dynamic> json) => new Content(
    addons: json["addons"] == null ? [] : new List<dynamic>.from(json["addons"].map((x) => x)),
    key: json["key"] == null ? '' : json["key"],
    productId: json["product_id"] == null ? 0 : json["product_id"],
    variationId: json["variation_id"] == null ? 0 : json["variation_id"],
    variation: json["variation"],
    quantity: json["quantity"] == null ? 0 : json["quantity"],
    //dataHash: json["data_hash"] == null ? '' : json["data_hash"],
    //lineTaxData: json["line_tax_data"] == null ? LineTaxData.fromJson({}) : LineTaxData.fromJson(json["line_tax_data"]),
    //lineSubtotal: json["line_subtotal"] == null ? 0 : json["line_subtotal"],
    //lineSubtotalTax: json["line_subtotal_tax"] == null ? 0 : json["line_subtotal_tax"],
    //lineTotal: json["line_total"] == null ? 0 : json["line_total"],
    //lineTax: json["line_tax"] == null ? 0 : json["line_tax"],
    //data: json["data"] == null ? Data.fromJson({}) : Data.fromJson(json["data"]),
  );
}

class Destination {
  String country;
  String state;
  String postcode;
  String city;
  String address;
  String address2;

  Destination({
    required this.country,
    required this.state,
    required this.postcode,
    required this.city,
    required this.address,
    required this.address2,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => new Destination(
    country: json["country"] == null ? '' : json["country"],
    state: json["state"] == null ? '' : json["state"],
    postcode: json["postcode"] == null ? '' : json["postcode"],
    city: json["city"] == null ? '' : json["city"],
    address: json["address"] == null ? '' : json["address"],
    address2: json["address_2"] == null ? '' : json["address_2"],
  );
}

class User {
  int id;

  User({
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
    id: json["ID"] == null ? 0 : json["ID"],
  );
}

class ShippingMethod {
  String id;
  String label;
  String cost;
  String methodId;
  List<dynamic> taxes;

  ShippingMethod({
    required this.id,
    required this.label,
    required this.cost,
    required this.methodId,
    required this.taxes,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => new ShippingMethod(
    id: json["id"] == null ? '' : json["id"],
    label: json["label"] == null ? '' : json["label"],
    cost: json["cost"] == null ? '' : json["cost"],
    methodId: json["method_id"] == null ? '' : json["method_id"],
    taxes: json["taxes"] == null ? [] : new List<dynamic>.from(json["taxes"].map((x) => x)),
  );
}
