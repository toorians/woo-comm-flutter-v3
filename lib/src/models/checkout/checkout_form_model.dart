// To parse this JSON data, do
//
//     final checkoutFormModel = checkoutFormModelFromJson(jsonString);

import 'dart:convert';

CheckoutFormModel checkoutFormModelFromJson(String str) => CheckoutFormModel.fromJson(json.decode(str));

class CheckoutFormModel {
  String billingFirstName;
  String billingLastName;
  String billingCompany;
  String billingCountry;
  String billingAddress1;
  String billingAddress2;
  String billingCity;
  String billingState;
  String billingPostcode;
  String billingPhone;
  String billingEmail;
  String shippingFirstName;
  String shippingLastName;
  String shippingCompany;
  String shippingCountry;
  String shippingAddress1;
  String shippingAddress2;
  String shippingCity;
  String shippingState;
  String shippingPostcode;
  List<Country> countries;
  Nonce nonce;
  String checkoutNonce;
  String wpnonce;
  String checkoutLogin;
  String saveAccountDetails;
  bool userLogged;
  //String logoutUrl;
  //int userId;

  CheckoutFormModel({
    required this.billingFirstName,
    required this.billingLastName,
    required this.billingCompany,
    required this.billingCountry,
    required this.billingAddress1,
    required this.billingAddress2,
    required this.billingCity,
    required this.billingState,
    required this.billingPostcode,
    required this.billingPhone,
    required this.billingEmail,
    required this.shippingFirstName,
    required this.shippingLastName,
    required this.shippingCompany,
    required this.shippingCountry,
    required this.shippingAddress1,
    required this.shippingAddress2,
    required this.shippingCity,
    required this.shippingState,
    required this.shippingPostcode,
    required this.countries,
    required this.nonce,
    required this.checkoutNonce,
    required this.wpnonce,
    required this.checkoutLogin,
    required this.saveAccountDetails,
    required this.userLogged,
    //required this.logoutUrl,
    //required this.userId,
  });

  factory CheckoutFormModel.fromJson(Map<String, dynamic> json) => CheckoutFormModel(
    billingFirstName: json["billing_first_name"] == null ? '' : json["billing_first_name"],
    billingLastName: json["billing_last_name"] == null ? '' : json["billing_last_name"],
    billingCompany: json["billing_company"] == null ? '' : json["billing_company"],
    billingCountry: json["billing_country"] == null ? '' : json["billing_country"],
    billingAddress1: json["billing_address_1"] == null ? '' : json["billing_address_1"],
    billingAddress2: json["billing_address_2"] == null ? '' : json["billing_address_2"],
    billingCity: json["billing_city"] == null ? '' : json["billing_city"],
    billingState: json["billing_state"] == null ? '' : json["billing_state"],
    billingPostcode: json["billing_postcode"] == null ? '' : json["billing_postcode"],
    billingPhone: json["billing_phone"] == null ? '' : json["billing_phone"],
    billingEmail: json["billing_email"] == null ? '' : json["billing_email"],
    shippingFirstName: json["shipping_first_name"] == null ? '' : json["shipping_first_name"],
    shippingLastName: json["shipping_last_name"] == null ? '' : json["shipping_last_name"],
    shippingCompany: json["shipping_company"] == null ? '' : json["shipping_company"],
    shippingCountry: json["shipping_country"] == null ? '' : json["shipping_country"],
    shippingAddress1: json["shipping_address_1"] == null ? '' : json["shipping_address_1"],
    shippingAddress2: json["shipping_address_2"] == null ? '' : json["shipping_address_2"],
    shippingCity: json["shipping_city"] == null ? '' : json["shipping_city"],
    shippingState: json["shipping_state"] == null ? '' : json["shipping_state"],
    shippingPostcode: json["shipping_postcode"] == null ? '' : json["shipping_postcode"],
    countries: json["countries"] == null ? [] : List<Country>.from(json["countries"].map((x) => Country.fromJson(x))),
    nonce: json["nonce"] == null ? Nonce.fromJson({}) : Nonce.fromJson(json["nonce"]),
    checkoutNonce: json["checkout_nonce"] == null ? '' : json["checkout_nonce"],
    wpnonce: json["_wpnonce"] == null ? '' : json["_wpnonce"],
    checkoutLogin: json["checkout_login"] == null ? false : json["checkout_login"],
    saveAccountDetails: json["save_account_details"] == null ? '' : json["save_account_details"],
    userLogged: json["user_logged"] == null ? false : json["user_logged"],
  );
}

class Country {
  String label;
  String value;
  List<Region> regions;

  Country({
    required this.label,
    required this.value,
    required this.regions,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    label: json["label"] == null ? '' : json["label"],
    value: json["value"] == null ? '' : json["value"],
    regions: json["regions"] == null ? [] : List<Region>.from(json["regions"].map((x) => Region.fromJson(x))),
  );
}

class Region {
  String label;
  String value;

  Region({
    required this.label,
    required this.value,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    label: json["label"] == null ? '' : json["label"],
    value: json["value"] == null ? '' : json["value"],
  );
}

class Nonce {
  String ajaxUrl;
  String wcAjaxUrl;
  String updateOrderReviewNonce;
  String applyCouponNonce;
  String removeCouponNonce;
  String optionGuestCheckout;
  String checkoutUrl;
  bool debugMode;
  String i18NCheckoutError;

  Nonce({
    required this.ajaxUrl,
    required this.wcAjaxUrl,
    required this.updateOrderReviewNonce,
    required this.applyCouponNonce,
    required this.removeCouponNonce,
    required this.optionGuestCheckout,
    required this.checkoutUrl,
    required this.debugMode,
    required this.i18NCheckoutError,
  });

  factory Nonce.fromJson(Map<String, dynamic> json) => Nonce(
    ajaxUrl: json["ajax_url"] == null ? '' : json["ajax_url"],
    wcAjaxUrl: json["wc_ajax_url"] == null ? '' : json["wc_ajax_url"],
    updateOrderReviewNonce: json["update_order_review_nonce"] == null ? '' : json["update_order_review_nonce"],
    applyCouponNonce: json["apply_coupon_nonce"] == null ? '' : json["apply_coupon_nonce"],
    removeCouponNonce: json["remove_coupon_nonce"] == null ? '' : json["remove_coupon_nonce"],
    optionGuestCheckout: json["option_guest_checkout"] == null ? '' : json["option_guest_checkout"],
    checkoutUrl: json["checkout_url"] == null ? '' : json["checkout_url"],
    debugMode: json["debug_mode"] == null ? false : json["debug_mode"],
    i18NCheckoutError: json["i18n_checkout_error"] == null ? '' : json["i18n_checkout_error"],
  );
}
