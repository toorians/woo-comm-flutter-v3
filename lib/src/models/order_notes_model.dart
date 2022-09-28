// To parse this JSON data, do
//
//     final orderNote = orderNoteFromJson(jsonString);

import 'dart:convert';

List<OrderNote> orderNoteFromJson(String str) => List<OrderNote>.from(json.decode(str).map((x) => OrderNote.fromJson(x)));

class OrderNote {
  OrderNote({
    required this.id,
    required this.author,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.note,
    required this.customerNote,
  });

  int id;
  String author;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  String note;
  bool customerNote;

  factory OrderNote.fromJson(Map<String, dynamic> json) => OrderNote(
    id: json["id"] == null ? 0 : json["id"],
    author: json["author"] == null ? '' : json["author"],
    dateCreated: json["date_created"] == null ? DateTime.now() : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_created_gmt"]),
    note: json["note"] == null ? '' : json["note"],
    customerNote: json["customer_note"] == null ? false : json["customer_note"],
  );
}

