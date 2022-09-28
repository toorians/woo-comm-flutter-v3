import 'dart:convert';

List<WalletModel> walletModelFromJson(String str) => List<WalletModel>.from(json.decode(str).map((x) => WalletModel.fromJson(x)));

class WalletModel {
  WalletModel({
    required this.transactionId,
    required this.blogId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.balance,
    required this.currency,
    required this.details,
    required this.deleted,
    required this.date,
  });

  String transactionId;
  String blogId;
  String userId;
  String type;
  String amount;
  String balance;
  String currency;
  String details;
  String deleted;
  DateTime date;

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    transactionId: json["transaction_id"] == null ? '' : json["transaction_id"],
    blogId: json["blog_id"] == null ? '' : json["blog_id"],
    userId: json["user_id"] == null ? '' : json["user_id"],
    type: json["type"] == null ? '' : json["type"],
    amount: json["amount"] == null ? '0' : json["amount"],
    balance: json["balance"] == null ? '0' : json["balance"],
    currency: json["currency"] == null ? 'USD' : json["currency"],
    details: json["details"] == null ? '' : json["details"],
    deleted: json["deleted"] == null ? '' : json["deleted"],
    date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
  );
}
