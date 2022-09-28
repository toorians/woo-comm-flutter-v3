// To parse this JSON data, do
//
//     final coupon = couponFromJson(jsonString);

import 'dart:convert';

List<CouponModel> couponFromJson(String str) => List<CouponModel>.from(json.decode(str).map((x) => CouponModel.fromJson(x)));

class CouponModel {
  CouponModel({
    required this.id,
    required this.code,
    required this.amount,
    required this.discountType,
    required this.description,
    required this.dateExpires,
    required this.dateExpiresGmt,
    //required this.usageCount,
    //required this.individualUse,
    //required this.productIds,
    //required this.excludedProductIds,
    //required this.usageLimit,
    //required this.usageLimitPerUser,
    //required this.limitUsageToXItems,
    //required this.freeShipping,
    //required this.productCategories,
    //required this.excludedProductCategories,
    //required this.excludeSaleItems,
    //required this.minimumAmount,
    //required this.maximumAmount,
  });

  int id;
  String code;
  String amount;
  String discountType;
  String description;
  DateTime? dateExpires;
  DateTime? dateExpiresGmt;
  //int usageCount;
  //bool individualUse;
  //List<dynamic> productIds;
  //List<dynamic> excludedProductIds;
  //dynamic usageLimit;
  //dynamic usageLimitPerUser;
  //dynamic limitUsageToXItems;
  //bool freeShipping;
  //List<dynamic> productCategories;
  //List<dynamic> excludedProductCategories;
  //bool excludeSaleItems;
  //String minimumAmount;
  //String maximumAmount;

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
    id: json["id"] == null ? 0 : json["id"],
    code: json["code"] == null ? '' : json["code"],
    amount: json["amount"] == null ? '' : json["amount"],
    discountType: json["discount_type"] == null ? '' : json["discount_type"],
    description: json["description"] == null ? '' : json["description"],
    dateExpires: json["date_expires"] == null ? null : DateTime.parse(json["date_expires"]),
    dateExpiresGmt: json["date_expires_gmt"] == null ? null : DateTime.parse(json["date_expires_gmt"]),
    //usageCount: json["usage_count"] == null ? 1 : json["usage_count"],
    //individualUse: json["individual_use"] == null ? true : json["individual_use"],
    //usageLimit: json["usage_limit"],
    //usageLimitPerUser: json["usage_limit_per_user"],
    //limitUsageToXItems: json["limit_usage_to_x_items"],
    //freeShipping: json["free_shipping"] == null ? null : json["free_shipping"],
    //minimumAmount: json["minimum_amount"] == null ? null : json["minimum_amount"],
    //maximumAmount: json["maximum_amount"] == null ? null : json["maximum_amount"],
  );
}
