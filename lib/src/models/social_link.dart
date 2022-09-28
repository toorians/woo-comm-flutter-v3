// To parse this JSON data, do
//
//     final socialLink = socialLinkFromJson(jsonString);

// ignore: unused_import
import 'package:meta/meta.dart';
import 'dart:convert';

SocialLink socialLinkFromJson(String str) => SocialLink.fromJson(json.decode(str));

class SocialLink {
  SocialLink({
    required this.facebook,
    required this.twitter,
    required this.linkedIn,
    required this.instagram,
    required this.bottomText,
    required this.whatsapp,
  });

  String facebook;
  String twitter;
  String linkedIn;
  String instagram;
  String bottomText;
  String whatsapp;

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
    facebook: json["facebook"] == null ? '' : json["facebook"],
    twitter: json["twitter"] == null ? '' : json["twitter"],
    linkedIn: json["linkedIn"] == null ? '' : json["linkedIn"],
    instagram: json["instagram"] == null ? '' : json["instagram"],
    bottomText: json["bottomText"] == null ? '' : json["bottomText"],
    whatsapp: json["whatsapp"] == null ? '' : json["whatsapp"],
  );
}
