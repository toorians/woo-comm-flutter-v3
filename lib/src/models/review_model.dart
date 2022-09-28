// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

List<ReviewModel> reviewModelFromJson(String str) => List<ReviewModel>.from(json.decode(str).map((x) => ReviewModel.fromJson(x)));

class ReviewModel {
  String id;
  String author;
  String email;
  String content;
  String rating;
  String avatar;
  DateTime  date;

  ReviewModel({
    required this.id,
    required this.author,
    required this.email,
    required this.content,
    required this.rating,
    required this.avatar,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json["id"] == null ? '' : json["id"],
    author: json["author"] == null ? '' : json["author"],
    email: json["email"] == null ? '' : json["email"],
    content: json["content"] == null ? '' : json["content"],
    rating: (json["rating"] == null || json["rating"] == '') ? '0' : json["rating"],
    avatar: json["avatar"] == null ? '' : json["avatar"],
    date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
  );
}