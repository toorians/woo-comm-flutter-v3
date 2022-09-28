// To parse this JSON data, do
//
//     final vendorReviews = vendorReviewsFromJson(jsonString);

import 'dart:convert';

List<VendorReviews> vendorReviewsFromJson(String str) => List<VendorReviews>.from(json.decode(str).map((x) => VendorReviews.fromJson(x)));

class VendorReviews {
  String id;
  String vendorId;
  String authorId;
  String authorName;
  String authorEmail;
  String reviewTitle;
  String reviewDescription;
  String reviewRating;
  String approved;
  DateTime created;

  VendorReviews({
    required this.id,
    required this.vendorId,
    required this.authorId,
    required this.authorName,
    required this.authorEmail,
    required this.reviewTitle,
    required this.reviewDescription,
    required this.reviewRating,
    required this.approved,
    required this.created,
  });

  factory VendorReviews.fromJson(Map<String, dynamic> json) => VendorReviews(
    id: json["ID"] == null ? '' : json["ID"],
    vendorId: json["vendor_id"] == null ? '' : json["vendor_id"],
    authorId: json["author_id"] == null ? '' : json["author_id"],
    authorName: json["author_name"] == null ? '' : json["author_name"],
    authorEmail: json["author_email"] == null ? '' : json["author_email"],
    reviewTitle: json["review_title"] == null ? '' : json["review_title"],
    reviewDescription: json["review_description"] == null ? '' : json["review_description"],
    reviewRating: json["review_rating"] == null ? '' : json["review_rating"],
    approved: json["approved"] == null ? '' : json["approved"],
    created: json["created"] == null ? DateTime.now() : DateTime.parse(json["created"]),
  );
}
