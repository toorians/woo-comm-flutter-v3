// To parse this JSON data, do
//
//     final downloadsModel = downloadsModelFromJson(jsonString);

import 'dart:convert';

List<DownloadsModel> downloadsModelFromJson(String str) => List<DownloadsModel>.from(json.decode(str).map((x) => DownloadsModel.fromJson(x)));

class DownloadsModel {
  DownloadsModel({
    required this.downloadUrl,
    required this.downloadId,
    required this.productId,
    required this.productName,
    required this.productUrl,
    required this.downloadName,
    required this.orderId,
    required this.orderKey,
    required this.downloadsRemaining,
    required this.accessExpires,
    required this.file,
  });

  String downloadUrl;
  String downloadId;
  int productId;
  String productName;
  String productUrl;
  String downloadName;
  int orderId;
  String orderKey;
  String downloadsRemaining;
  DateTime accessExpires;
  FileClass file;

  factory DownloadsModel.fromJson(Map<String, dynamic> json) => DownloadsModel(
    downloadUrl: json["download_url"] == null ? '' : json["download_url"],
    downloadId: json["download_id"] == null ? '' : json["download_id"],
    productId: json["product_id"] == null ? 0 : json["product_id"],
    productName: json["product_name"] == null ? '' : json["product_name"],
    productUrl: json["product_url"] == null ? '' : json["product_url"],
    downloadName: json["download_name"] == null ? '' : json["download_name"],
    orderId: json["order_id"] == null ? 0 : json["order_id"],
    orderKey: json["order_key"] == null ? '' : json["order_key"],
    downloadsRemaining: json["downloads_remaining"] == null ? '' : json["downloads_remaining"],
    accessExpires: json["access_expires"] == null ? DateTime.now() : DateTime.parse(json["access_expires"]),
    file: json["file"] == null ? FileClass.fromJson({}) : FileClass.fromJson(json["file"]),
  );
}

class FileClass {
  FileClass({
    required this.name,
    required this.file,
  });

  String name;
  String file;

  factory FileClass.fromJson(Map<String, dynamic> json) => FileClass(
    name: json["name"] == null ? '' : json["name"],
    file: json["file"] == null ? '' : json["file"],
  );
}
