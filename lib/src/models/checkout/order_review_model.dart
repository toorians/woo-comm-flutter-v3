// To parse this JSON data, do
//
//     final orderReviewModel = orderReviewModelFromJson(jsonString);

import 'dart:convert';

import 'package:app/src/functions.dart';

OrderReviewModel orderReviewModelFromJson(String str) => OrderReviewModel.fromJson(json.decode(str));

class OrderReviewModel {
  String result;
  /*String messages;
  String reload;
  Cart cart;
  Checkout checkout;*/
  Totals totals;
  double balance;
  String balanceFormatted;
  Totals totalsUnformatted;
  String? csrfToken;
  //List<dynamic> chosenShipping;
  List<Shipping> shipping;
  List<WooPaymentMethod> paymentMethods;

  OrderReviewModel({
    required this.result,
    /*required this.messages,
    required this.reload,
    required this.cart,
    required this.checkout,*/
    required this.totals,
    required this.balance,
    required this.balanceFormatted,
    //required this.chosenShipping,
    required this.shipping,
    required this.paymentMethods,
    required this.totalsUnformatted,
    this.csrfToken
  });

  factory OrderReviewModel.fromJson(Map<String, dynamic> json) => new OrderReviewModel(
    result: json["result"] == null ? '' : json["result"],
    //messages: json["messages"] == null ? null : json["messages"],
    //reload: json["reload"] == null ? null : json["reload"],
    //cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
    //checkout: json["checkout"] == null ? null : Checkout.fromJson(json["checkout"]),
    balance: json["balance"] == null ? 0.0 : json["balance"].toDouble(),
    balanceFormatted: json["balanceFormatted"] == null ? '' : json["balanceFormatted"],
    totals: json["totals"] == null ? Totals.fromJson({}) : Totals.fromJson(json["totals"]),
    totalsUnformatted: json["totalsUnformatted"] == null ? Totals.fromJson({}) : Totals.fromJson(json["totalsUnformatted"]),
    //chosenShipping: json["chosen_shipping"] == null ? null : new List<dynamic>.from(json["chosen_shipping"].map((x) => x)),
    csrfToken: json["csrf_token"] == null ? null : json["csrf_token"],
    shipping: json["shipping"] == null ? [] : new List<Shipping>.from(json["shipping"].map((x) => Shipping.fromJson(x))),
    paymentMethods: json["paymentMethods"] == null ? [] : new List<WooPaymentMethod>.from(json["paymentMethods"].map((x) => WooPaymentMethod.fromJson(x))),
  );
}

class Cart {
  //CartContents cartContents;
  List<dynamic> appliedCoupons;
  String taxDisplayCart;
  CartSessionData cartSessionData;
  List<dynamic> couponAppliedCount;
  List<dynamic> couponDiscountTotals;
  List<dynamic> couponDiscountTaxTotals;

  Cart({
    //required this.cartContents,
    required this.appliedCoupons,
    required this.taxDisplayCart,
    required this.cartSessionData,
    required this.couponAppliedCount,
    required this.couponDiscountTotals,
    required this.couponDiscountTaxTotals,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => new Cart(
    //cartContents: json["cart_contents"] == null ? CartContents.fromJson({}) : CartContents.fromJson(json["cart_contents"]),
    appliedCoupons: json["applied_coupons"] == null ? [] : new List<dynamic>.from(json["applied_coupons"].map((x) => x)),
    taxDisplayCart: json["tax_display_cart"] == null ? '' : json["tax_display_cart"],
    cartSessionData: json["cart_session_data"] == null ? CartSessionData.fromJson({}) : CartSessionData.fromJson(json["cart_session_data"]),
    couponAppliedCount: json["coupon_applied_count"] == null ? [] : new List<dynamic>.from(json["coupon_applied_count"].map((x) => x)),
    couponDiscountTotals: json["coupon_discount_totals"] == null ? [] : new List<dynamic>.from(json["coupon_discount_totals"].map((x) => x)),
    couponDiscountTaxTotals: json["coupon_discount_tax_totals"] == null ? [] : new List<dynamic>.from(json["coupon_discount_tax_totals"].map((x) => x)),
  );
}

/*class CartContents {
  The8Da153B3917424A1Cf24A9Cd1D7B4E9D the8Da153B3917424A1Cf24A9Cd1D7B4E9D;
  E610F941894B4A6488Cc1E06655862Ee e610F941894B4A6488Cc1E06655862Ee;

  CartContents({
    required this.the8Da153B3917424A1Cf24A9Cd1D7B4E9D,
    required this.e610F941894B4A6488Cc1E06655862Ee,
  });

  factory CartContents.fromJson(Map<String, dynamic> json) => new CartContents(
    the8Da153B3917424A1Cf24A9Cd1D7B4E9D: json["8da153b3917424a1cf24a9cd1d7b4e9d"] == null ? null : The8Da153B3917424A1Cf24A9Cd1D7B4E9D.fromJson(json["8da153b3917424a1cf24a9cd1d7b4e9d"]),
    e610F941894B4A6488Cc1E06655862Ee: json["e610f941894b4a6488cc1e06655862ee"] == null ? null : E610F941894B4A6488Cc1E06655862Ee.fromJson(json["e610f941894b4a6488cc1e06655862ee"]),
  );

  Map<String, dynamic> toJson() => {
    "8da153b3917424a1cf24a9cd1d7b4e9d": the8Da153B3917424A1Cf24A9Cd1D7B4E9D == null ? null : the8Da153B3917424A1Cf24A9Cd1D7B4E9D.toJson(),
    "e610f941894b4a6488cc1e06655862ee": e610F941894B4A6488Cc1E06655862Ee == null ? null : e610F941894B4A6488Cc1E06655862Ee.toJson(),
  };
}*/

class E610F941894B4A6488Cc1E06655862Ee {
  List<dynamic> addons;
  String key;
  int productId;
  int variationId;
  VariationClass variation;
  int quantity;
  //String dataHash;
  //LineTaxData lineTaxData;
  //int lineSubtotal;
  //int lineSubtotalTax;
  //int lineTotal;
  //int lineTax;
  //Checkout data;
  String name;

  E610F941894B4A6488Cc1E06655862Ee({
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
  });

  factory E610F941894B4A6488Cc1E06655862Ee.fromJson(Map<String, dynamic> json) => new E610F941894B4A6488Cc1E06655862Ee(
    addons: json["addons"] == null ? [] : new List<dynamic>.from(json["addons"].map((x) => x)),
    key: json["key"] == null ? '' : json["key"],
    productId: json["product_id"] == null ? 0 : json["product_id"],
    variationId: json["variation_id"] == null ? 0 : json["variation_id"],
    variation: json["variation"] == null ? VariationClass.fromJson({}) : VariationClass.fromJson(json["variation"]),
    quantity: json["quantity"] == null ? 0 : json["quantity"],
    //dataHash: json["data_hash"] == null ? null : json["data_hash"],
    //lineTaxData: json["line_tax_data"] == null ? LineTaxData.fromJson({}) : LineTaxData.fromJson(json["line_tax_data"]),
    //lineSubtotal: json["line_subtotal"] == null ? null : json["line_subtotal"],
    //lineSubtotalTax: json["line_subtotal_tax"] == null ? null : json["line_subtotal_tax"],
    //lineTotal: json["line_total"] == null ? null : json["line_total"],
    //lineTax: json["line_tax"] == null ? null : json["line_tax"],
    //data: json["data"] == null ? Checkout.fromJson({}) : Checkout.fromJson(json["data"]),
    name: json["name"] == null ? '' : json["name"],
  );
}

class Checkout {
  Checkout();

  factory Checkout.fromJson(Map<String, dynamic> json) => new Checkout(
  );

  Map<String, dynamic> toJson() => {
  };
}

class LineTaxData {
  List<dynamic> subtotal;
  List<dynamic> total;

  LineTaxData({
    required this.subtotal,
    required this.total,
  });

  factory LineTaxData.fromJson(Map<String, dynamic> json) => new LineTaxData(
    subtotal: json["subtotal"] == null ? [] : new List<dynamic>.from(json["subtotal"].map((x) => x)),
    total: json["total"] == null ? [] : new List<dynamic>.from(json["total"].map((x) => x)),
  );
}

class VariationClass {
  String attributePaColor;
  String attributePaSize;

  VariationClass({
    required this.attributePaColor,
    required this.attributePaSize,
  });

  factory VariationClass.fromJson(Map<String, dynamic> json) => new VariationClass(
    attributePaColor: json["attribute_pa_Color"] == null ? '' : json["attribute_pa_Color"],
    attributePaSize: json["attribute_pa_Size"] == null ? '' : json["attribute_pa_Size"],
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
    cartContentsTotal: json["cart_contents_total"] == null ? 0 : json["cart_contents_total"],
    total: json["total"] == null ? 0 : json["total"],
    subtotal: json["subtotal"] == null ? 0 : json["subtotal"],
    subtotalExTax: json["subtotal_ex_tax"] == null ? 0 : json["subtotal_ex_tax"],
    taxTotal: json["tax_total"] == null ? 0 : json["tax_total"],
    taxes: json["taxes"] == null ? [] : new List<dynamic>.from(json["taxes"].map((x) => x)),
    shippingTaxes: json["shipping_taxes"] == null ? [] : new List<dynamic>.from(json["shipping_taxes"].map((x) => x)),
    discountCart: json["discount_cart"] == null ? 0 : json["discount_cart"],
    discountCartTax: json["discount_cart_tax"] == null ? 0 : json["discount_cart_tax"],
    shippingTotal: json["shipping_total"] == null ? 0 : json["shipping_total"],
    shippingTaxTotal: json["shipping_tax_total"] == null ? 0 : json["shipping_tax_total"],
    couponDiscountAmounts: json["coupon_discount_amounts"] == null ? [] : new List<dynamic>.from(json["coupon_discount_amounts"].map((x) => x)),
    couponDiscountTaxAmounts: json["coupon_discount_tax_amounts"] == null ? [] : new List<dynamic>.from(json["coupon_discount_tax_amounts"].map((x) => x)),
    feeTotal: json["fee_total"] == null ? 0 : json["fee_total"],
    fees: json["fees"] == null ? [] : new List<dynamic>.from(json["fees"].map((x) => x)),
  );
}

class WooPaymentMethod {
  dynamic orderButtonText;
  String enabled;
  String title;
  String description;
  bool chosen;
  String methodTitle;
  String methodDescription;
  bool hasFields;
  dynamic countries;
  dynamic availability;
  String icon;
  //List<dynamic> supports;
  int maxAmount;
  String viewTransactionUrl;
  String newMethodLabel;
  String pluginId;
  String id;
  Settings settings;
  //FormFields formFields;
  String instructions;
  String payStackPublicKey;
  String publicKey;
  String secretKey;
  String? paymentPage;

  WooPaymentMethod({
    required this.orderButtonText,
    required this.enabled,
    required this.title,
    required this.description,
    required this.chosen,
    required this.methodTitle,
    required this.methodDescription,
    required this.hasFields,
    required this.countries,
    required this.availability,
    required this.icon,
    //required this.supports,
    required this.maxAmount,
    required this.viewTransactionUrl,
    required this.newMethodLabel,
    required this.pluginId,
    required this.id,
    required this.settings,
    //required this.formFields,
    required this.instructions,
    required this.payStackPublicKey,
    required this.publicKey,
    required this.secretKey,
    this.paymentPage
  });

  factory WooPaymentMethod.fromJson(Map<String, dynamic> json) => new WooPaymentMethod(
    orderButtonText: json["order_button_text"],
    enabled: json["enabled"] == null ? true : json["enabled"],
    title: json["title"] == null ? '' : json["title"],
    description: json["description"] != null ? json["description"] : json["method_description"] == null ? '' : json["method_description"],
    chosen: json["chosen"] == null ? false : json["chosen"],
    methodTitle: json["method_title"] == null ? '' : json["method_title"],
    methodDescription: json["method_description"] == null ? '' : json["method_description"],
    hasFields: json["has_fields"] == null ? false : json["has_fields"],
    countries: json["countries"],
    availability: json["availability"],
    icon: (json["icon"] == null || json["icon"] == false) ? '' : json["icon"],
    //supports: json["supports"] == null ? [] : new List<String>.from(json["supports"].map((x) => x)),
    maxAmount: json["max_amount"] == null ? 0 : json["max_amount"],
    viewTransactionUrl: json["view_transaction_url"] == null ? '' : json["view_transaction_url"],
    newMethodLabel: json["new_method_label"] == null ? '' : json["new_method_label"],
    pluginId: json["plugin_id"] == null ? '' : json["plugin_id"],
    id: json["id"] == null ? '' : json["id"],
    settings: !(json["settings"] is Map<String, dynamic>) ? Settings.fromJson({}) : Settings.fromJson(json["settings"]),
    //formFields: json["form_fields"] == null ? null : FormFields.fromJson(json["form_fields"]),
    instructions: json["instructions"] == null ? '' : json["instructions"],
    payStackPublicKey: json["public_key"] == null ? '' : json["public_key"],
    publicKey: json["publishable_key"] == null ? '' : json["publishable_key"],
    secretKey: json["secret_key"] == null ? '' : json["secret_key"],
    paymentPage: json["payment_page"] == null ? null : json["payment_page"],
  );
}

class FormFields {
  Enabled enabled;
  Description title;
  Description description;
  Description instructions;

  FormFields({
    required this.enabled,
    required this.title,
    required this.description,
    required this.instructions,
  });

  factory FormFields.fromJson(Map<String, dynamic> json) => new FormFields(
    enabled: json["enabled"] == null ? Enabled.fromJson({}) : Enabled.fromJson(json["enabled"]),
    title: json["title"] == null ? Description.fromJson({}) : Description.fromJson(json["title"]),
    description: json["description"] == null ? Description.fromJson({}) : Description.fromJson(json["description"]),
    instructions: json["instructions"] == null ? Description.fromJson({}) : Description.fromJson(json["instructions"]),
  );
}

class Description {
  String title;
  String type;
  String description;
  String descriptionDefault;
  //bool descTip;

  Description({
    required this.title,
    required this.type,
    required this.description,
    required this.descriptionDefault,
    //required this.descTip,
  });

  factory Description.fromJson(Map<String, dynamic> json) => new Description(
    title: json["title"] == null ? '' : json["title"],
    type: json["type"] == null ? '' : json["type"],
    description: json["description"] == null ? '' : json["description"],
    descriptionDefault: json["default"] == null ? '' : json["default"],
    //descTip: json["desc_tip"] == null ? null : json["desc_tip"],
  );
}

class Enabled {
  String title;
  String type;
  String label;
  String enabledDefault;

  Enabled({
    required this.title,
    required this.type,
    required this.label,
    required this.enabledDefault,
  });

  factory Enabled.fromJson(Map<String, dynamic> json) => new Enabled(
    title: json["title"] == null ? '' : json["title"],
    type: json["type"] == null ? '' : json["type"],
    label: json["label"] == null ? '' : json["label"],
    enabledDefault: json["default"] == null ? '' : json["default"],
  );
}

class Settings {
  String enabled;
  String title;
  String description;
  String instructions;
  String keyId;


  Settings({
    required this.enabled,
    required this.title,
    required this.description,
    required this.instructions,
    required this.keyId
  });

  factory Settings.fromJson(Map<String, dynamic> json) => new Settings(
    enabled: json["enabled"] == null ? '' : json["enabled"],
    title: json["title"] == null ? '' : json["title"],
    description: json["description"] == null ? '' : json["description"],
    instructions: json["instructions"] == null ? '' : json["instructions"],
    keyId: json["key_id"] == null ? '' : json["key_id"],
  );
}

class Shipping {
  Package package;
  bool showPackageDetails;
  bool showShippingCalculator;
  String packageDetails;
  String packageName;
  String index;
  String chosenMethod;
  //String chosenMethodId;
  List<ShippingMethod> shippingMethods;

  Shipping({
    required this.package,
    required this.showPackageDetails,
    required this.showShippingCalculator,
    required this.packageDetails,
    required this.packageName,
    required this.index,
    required this.chosenMethod,
    required this.shippingMethods,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) => new Shipping(
    package: json["package"] == null ? Package.fromJson({}) : Package.fromJson(json["package"]),
    showPackageDetails: json["show_package_details"] == null ? false : json["show_package_details"],
    showShippingCalculator: json["show_shipping_calculator"] == null ? false : json["show_shipping_calculator"],
    packageDetails: json["package_details"] == null ? '' : json["package_details"],
    packageName: json["package_name"] == null ? '' : json["package_name"],
    index: json["index"] == null ? '0' : json["index"].toString(),
    chosenMethod: (json["chosen_method"] == null || json["chosen_method"] == false ) ? '' : json["chosen_method"].toString(),
    shippingMethods: json["shippingMethods"] == null ? [] : new List<ShippingMethod>.from(json["shippingMethods"].map((x) => ShippingMethod.fromJson(x))),
  );
}

class Package {
  //List<Content> contents;
  double contentsCost;
  List<dynamic> appliedCoupons;
  User user;
  Destination destination;
  String vendorId;

  Package({
    //required this.contents,
    required this.contentsCost,
    required this.appliedCoupons,
    required this.user,
    required this.destination,
    required this.vendorId
  });

  factory Package.fromJson(Map<String, dynamic> json) => new Package(
    //contents: json["contents"] == null ? null : new List<Content>.from(json["contents"].map((x) => Content.fromJson(x))),
    contentsCost: isNumeric(json["contents_cost"].toString()) ? double.parse(json["contents_cost"].toString()) : 0,
    appliedCoupons: json["applied_coupons"] == null ? [] : new List<dynamic>.from(json["applied_coupons"].map((x) => x)),
    user: json["user"] == null ? User.fromJson({}) : User.fromJson(json["user"]),
    vendorId: json["vendor_id"] == null ? '0' : json["vendor_id"].toString(),
    destination: json["destination"] == null ? Destination.fromJson({}) : Destination.fromJson(json["destination"]),
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
  //Checkout data;

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
    //dataHash: json["data_hash"] == null ? null : json["data_hash"],
    //lineTaxData: json["line_tax_data"] == null ? LineTaxData.fromJson({}) : LineTaxData.fromJson(json["line_tax_data"]),
    //lineSubtotal: json["line_subtotal"] == null ? 0 : json["line_subtotal"],
    //lineSubtotalTax: json["line_subtotal_tax"] == null ? 0 : json["line_subtotal_tax"],
    //lineTotal: json["line_total"] == null ? 0 : json["line_total"],
    //lineTax: json["line_tax"] == null ? 0 : json["line_tax"],
    //data: json["data"] == null ? Checkout.fromJson({}) : Checkout.fromJson(json["data"]),
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
  //List<dynamic> taxes;

  ShippingMethod({
    required this.id,
    required this.label,
    required this.cost,
    required this.methodId,
    //required this.taxes,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => new ShippingMethod(
    id: json["id"] == null ? '' : json["id"],
    label: json["label"] == null ? '' : json["label"],
    cost: json["cost"] == null ? '0' : json["cost"].toString(),
    methodId: json["method_id"] == null ? '' : json["method_id"],
    //taxes: json["taxes"] == null ? null : new List<dynamic>.from(json["taxes"].map((x) => x)),
  );
}

class Totals {
  String subtotal;
  String subtotalTax;
  String shippingTotal;
  String shippingTax;
  //List<dynamic> shippingTaxes;
  String discountTotal;
  String discountTax;
  String cartContentsTotal;
  //String cartContentsTax;
  //List<dynamic> cartContentsTaxes;
  String feeTotal;
  String feeTax;
  //List<dynamic> feeTaxes;
  String total;
  String totalTax;

  Totals({
    required this.subtotal,
    required this.subtotalTax,
    required this.shippingTotal,
    required this.shippingTax,
    //required this.shippingTaxes,
    required this.discountTotal,
    required this.discountTax,
    required this.cartContentsTotal,
    //required this.cartContentsTax,
    //required this.cartContentsTaxes,
    required this.feeTotal,
    required this.feeTax,
    //required this.feeTaxes,
    required this.total,
    required this.totalTax,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => new Totals(
    subtotal: json["subtotal"] == null ? '0' : json["subtotal"].toString(),
    subtotalTax: json["subtotal_tax"] == null ? '0' : json["subtotal_tax"].toString(),
    shippingTotal: json["shipping_total"] == null ? '0' : json["shipping_total"].toString(),
    shippingTax: json["shipping_tax"] == null ? '0' : json["shipping_tax"].toString(),
    //shippingTaxes: json["shipping_taxes"] == null ? null : new List<dynamic>.from(json["shipping_taxes"].map((x) => x)),
    discountTotal: json["discount_total"] == null ? '0' : json["discount_total"].toString(),
    discountTax: json["discount_tax"] == null ? '0' : json["discount_tax"].toString(),
    cartContentsTotal: json["cart_contents_total"] == null ? '0' : json["cart_contents_total"].toString(),
    //cartContentsTax: json["cart_contents_tax"] == null ? null : json["cart_contents_tax"].toDouble(),
    //cartContentsTaxes: json["cart_contents_taxes"] == null ? null : new List<dynamic>.from(json["cart_contents_taxes"].map((x) => x)),
    feeTotal: json["fee_total"] == null ? '0' : json["fee_total"].toString(),
    feeTax: json["fee_tax"] == null ? '0' : json["fee_tax"].toString(),
    //feeTaxes: json["fee_taxes"] == null ? null : new List<dynamic>.from(json["fee_taxes"].map((x) => x)),
    total: json["total"] == null ? '0' : json["total"].toString(),
    totalTax: json["total_tax"] == null ? '0' : json["total_tax"].toString(),
  );
}
