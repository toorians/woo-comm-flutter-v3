// To parse this JSON data, do
//
//     final checkoutData = checkoutDataFromJson(jsonString);

import 'dart:convert';

CheckoutFormData checkoutDataFromJson(String str) => CheckoutFormData.fromJson(json.decode(str));

class CheckoutFormData {
  CheckoutFormData({
    required this.fieldgroups,
    required this.data,
  });

  Fieldgroups fieldgroups;
  FieldData data;

  factory CheckoutFormData.fromJson(Map<String, dynamic> json) => CheckoutFormData(
    fieldgroups: json["fieldgroups"] == null ? Fieldgroups.fromJson({}) : Fieldgroups.fromJson(json["fieldgroups"]),
    data: json["data"] == null ? FieldData.fromJson({}) : FieldData.fromJson(json["data"]),
  );
}

class FieldData {
  FieldData({
    required this.nonce,
    required this.checkoutNonce,
    required this.wpnonce,
    required this.checkoutLogin,
    required this.saveAccountDetails,
    required this.stripeConfirmPi,
    required this.userLogged,
  });

  Nonce nonce;
  String checkoutNonce;
  String wpnonce;
  String checkoutLogin;
  String saveAccountDetails;
  String stripeConfirmPi;
  bool userLogged;

  factory FieldData.fromJson(Map<String, dynamic> json) => FieldData(
    nonce: json["nonce"] == null ? Nonce.fromJson({}) : Nonce.fromJson(json["nonce"]),
    checkoutNonce: json["checkout_nonce"] == null ? '' : json["checkout_nonce"],
    wpnonce: json["_wpnonce"] == null ? '' : json["_wpnonce"],
    checkoutLogin: json["checkout_login"] == null ? '' : json["checkout_login"],
    saveAccountDetails: json["save_account_details"] == null ? '' : json["save_account_details"],
    stripeConfirmPi: json["stripe_confirm_pi"] == null ? '' : json["stripe_confirm_pi"],
    userLogged: json["user_logged"] == null ? false : json["user_logged"],
  );
}

class Nonce {
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

  String ajaxUrl;
  String wcAjaxUrl;
  String updateOrderReviewNonce;
  String applyCouponNonce;
  String removeCouponNonce;
  String optionGuestCheckout;
  String checkoutUrl;
  bool debugMode;
  String i18NCheckoutError;

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

class Fieldgroups {
  Fieldgroups({
    required this.billing,
    required this.shipping,
    required this.account,
    required this.order,
  });

  List<Ing> billing;
  List<Ing> shipping;
  List<Account> account;
  List<OrderField> order;

  factory Fieldgroups.fromJson(Map<String, dynamic> json) => Fieldgroups(
    billing: json["billing"] == null ? [] : List<Ing>.from(json["billing"].map((x) => Ing.fromJson(x))),
    shipping: json["shipping"] == null ? [] : List<Ing>.from(json["shipping"].map((x) => Ing.fromJson(x))),
    account: json["account"] == null ? [] : List<Account>.from(json["account"].map((x) => Account.fromJson(x))),
    order: json["order"] == null ? [] : List<OrderField>.from(json["order"].map((x) => OrderField.fromJson(x))),
  );
}

class Account {
  Account({
    required this.type,
    required this.label,
    required this.id,
    required this.required,
    required this.placeholder,
    required this.value,
    required this.key,
    required this.accountClass,
  });

  String type;
  String label;
  String id;
  bool required;
  String placeholder;
  dynamic value;
  String key;
  List<String> accountClass;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    type: json["type"] == null ? '' : json["type"],
    label: json["label"] == null ? '' : json["label"],
    id: json["id"] == null ? '' : json["id"],
    required: json["required"] == null ? false : json["required"],
    placeholder: json["placeholder"] == null ? '' : json["placeholder"],
    value: json["value"],
    key: json["key"] == null ? '' : json["key"],
    accountClass: json["class"] == null ? [] : List<String>.from(json["class"].map((x) => x)),
  );
}

class Ing {
  Ing({
    required this.label,
    required this.required,
    //required this.ingClass,
    //required this.autocomplete,
    //required this.priority,
    this.value,
    required this.key,
    required this.type,
    required this.dotappOptions,
    required this.placeholder,
    //required this.labelClass,
    //required this.validate,
    //required this.countryField,
    //required this.country,
    //required this.clear,
  });

  String label;
  bool required;
  //List<Class> ingClass;
  //String autocomplete;
  //int priority;
  String? value;
  String key;
  String type;
  List<DotappOption> dotappOptions;
  String placeholder;
  //List<String> labelClass;
  //List<String> validate;
  //String countryField;
  //String country;
  //bool clear;

  factory Ing.fromJson(Map<String, dynamic> json) => Ing(
    label: json["label"] == null ? '' : json["label"],
    required: json["required"] is bool ? json["required"] : false,
    //ingClass: json["class"] == null ? null : List<Class>.from(json["class"].map((x) => classValues.map[x])),
    //autocomplete: json["autocomplete"] == null ? null : json["autocomplete"],
    //priority: json["priority"] == null ? null : json["priority"],
    value: json["value"] == null ? '' : json["value"],
    key: json["key"] == null ? null : json["key"],
    type: json["type"] == null ? '' : json["type"],
    dotappOptions: json["dotapp_options"] == null ? [] : List<DotappOption>.from(json["dotapp_options"].map((x) => DotappOption.fromJson(x))),
    placeholder: json["placeholder"] == null ? '' : json["placeholder"],
    //labelClass: json["label_class"] == null ? null : List<String>.from(json["label_class"].map((x) => x)),
    //validate: json["validate"] == null ? null : List<String>.from(json["validate"].map((x) => x)),
    //countryField: json["country_field"] == null ? null : json["country_field"],
    //country: json["country"] == null ? null : json["country"],
    //clear: json["clear"] == null ? null : json["clear"],
  );
}

class DotappOption {
  DotappOption({
    required this.label,
    required this.value,
    required this.regions,
    required this.key
  });

  String label;
  String value;
  String key;
  List<Region> regions;

  factory DotappOption.fromJson(Map<String, dynamic> json) => DotappOption(
    key: json["key"] == null ? '' : json["key"].toString(),
    label: json["label"] == null ? '' : json["label"],
    value: json["value"] == null ? '' : json["value"],
    regions: json["regions"] == null ? [] : List<Region>.from(json["regions"].map((x) => Region.fromJson(x))),
  );
}

class Region {
  Region({
    required this.label,
    required this.value,
  });

  String label;
  String value;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    label: json["label"] == null ? '' : json["label"],
    value: json["value"] == null ? '' : json["value"],
  );
}

enum Class { FORM_ROW_FIRST, FORM_ROW_LAST, FORM_ROW_WIDE, ADDRESS_FIELD, UPDATE_TOTALS_ON_CHANGE, WCFM_CUSTOM_HIDE }

final classValues = EnumValues({
  "address-field": Class.ADDRESS_FIELD,
  "form-row-first": Class.FORM_ROW_FIRST,
  "form-row-last": Class.FORM_ROW_LAST,
  "form-row-wide": Class.FORM_ROW_WIDE,
  "update_totals_on_change": Class.UPDATE_TOTALS_ON_CHANGE,
  "wcfm_custom_hide": Class.WCFM_CUSTOM_HIDE
});

class OrderField {
  OrderField({
    required this.type,
    required this.orderClass,
    required this.label,
    required this.placeholder,
    required this.value,
    required this.key,
  });

  String type;
  List<String> orderClass;
  String label;
  String placeholder;
  dynamic value;
  String key;

  factory OrderField.fromJson(Map<String, dynamic> json) => OrderField(
    type: json["type"] == null ? '' : json["type"],
    orderClass: json["class"] == null ? [] : List<String>.from(json["class"].map((x) => x)),
    label: json["label"] == null ? '' : json["label"],
    placeholder: json["placeholder"] == null ? '' : json["placeholder"],
    value: json["value"],
    key: json["key"] == null ? '' : json["key"],
  );
}

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
