// To parse this JSON data, do
//
//     final fcmDetails = fcmDetailsFromJson(jsonString);

import 'dart:convert';

FcmDetails fcmDetailsFromJson(String str) => FcmDetails.fromJson(json.decode(str));

class FcmDetails {
  FcmDetails({
    required this.applicationVersion,
    required this.application,
    required this.scope,
    required this.authorizedEntity,
    required this.platform,
    required this.topics,
  });

  String applicationVersion;
  String application;
  String scope;
  String authorizedEntity;
  String platform;
  List<String> topics;

  factory FcmDetails.fromJson(Map<String, dynamic> json) => FcmDetails(
    applicationVersion: json["applicationVersion"] == null ? '' : json["applicationVersion"],
    application: json["application"] == null ? '' : json["application"],
    scope: json["scope"] == null ? '' : json["scope"],
    authorizedEntity: json["authorizedEntity"] == null ? '' : json["authorizedEntity"],
    platform: json["platform"] == null ? '' : json["platform"],
    topics: json["topics"] == null ? [] : List<String>.from(json["topics"].map((x) => x)),
  );
}
