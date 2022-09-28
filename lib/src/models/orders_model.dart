// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'customer_model.dart';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  int id;
  int parentId;
  String number;
  String orderKey;
  String createdVia;
  String version;
  String status;
  String currency;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  DateTime dateModified;
  DateTime dateModifiedGmt;
  String discountTotal;
  String discountTax;
  String shippingTotal;
  String shippingTax;
  String cartTax;
  String total;
  String totalTax;
  bool pricesIncludeTax;
  int customerId;
  //String customerIpAddress;
  //String customerUserAgent;
  String customerNote;
  Address billing;
  Address shipping;
  String paymentMethod;
  String paymentMethodTitle;
  String transactionId;
  dynamic datePaid;
  dynamic datePaidGmt;
  dynamic dateCompleted;
  dynamic dateCompletedGmt;
  String cartHash;
  List<MetaDatum> metaData;
  List<LineItem> lineItems;
  List<dynamic> taxLines;
  List<ShippingLine> shippingLines;
  List<FeeLine> feeLines;
  List<dynamic> couponLines;
  List<dynamic> refunds;
  int decimals;
  DeliveryBoy deliveryBoy;
  String deliveryTime;

  Order({
    required this.id,
    required this.parentId,
    required this.number,
    required this.orderKey,
    required this.createdVia,
    required this.version,
    required this.status,
    required this.currency,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.discountTotal,
    required this.discountTax,
    required this.shippingTotal,
    required this.shippingTax,
    required this.cartTax,
    required this.total,
    required this.totalTax,
    required this.pricesIncludeTax,
    required this.customerId,
    required this.customerNote,
    required this.billing,
    required this.shipping,
    required this.paymentMethod,
    required this.paymentMethodTitle,
    required this.transactionId,
    required this.datePaid,
    required this.datePaidGmt,
    required this.dateCompleted,
    required this.dateCompletedGmt,
    required this.cartHash,
    required this.metaData,
    required this.lineItems,
    required this.taxLines,
    required this.shippingLines,
    required this.feeLines,
    required this.couponLines,
    required this.refunds,
    required this.decimals,
    required this.deliveryBoy,
    required this.deliveryTime
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"] == null ? 0 : json["id"],
    parentId: json["parent_id"] == null ? 0 : json["parent_id"],
    number: json["number"] == null ? '' : json["number"],
    orderKey: json["order_key"] == null ? '' : json["order_key"],
    createdVia: json["created_via"] == null ? '' : json["created_via"],
    version: json["version"] == null ? '' : json["version"],
    status: json["status"] == null ? '' : json["status"],
    currency: json["currency"] == null ? 'USD' : json["currency"],
    dateCreated: json["date_created"] == null ? DateTime.now() : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_created_gmt"]),
    dateModified: json["date_modified"] == null ? DateTime.now() : DateTime.parse(json["date_modified"]),
    dateModifiedGmt: json["date_modified_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_modified_gmt"]),
    discountTotal: json["discount_total"] == null ? '' : json["discount_total"],
    discountTax: json["discount_tax"] == null ? '' : json["discount_tax"],
    shippingTotal: json["shipping_total"] == null ? '' : json["shipping_total"],
    shippingTax: json["shipping_tax"] == null ? '' : json["shipping_tax"],
    cartTax: json["cart_tax"] == null ? '' : json["cart_tax"],
    total: json["total"] == null ? '' : json["total"],
    totalTax: json["total_tax"] == null ? '' : json["total_tax"],
    pricesIncludeTax: json["prices_include_tax"] == null ? false : json["prices_include_tax"],
    customerId: json["customer_id"] == null ? 0 : json["customer_id"],
    customerNote: json["customer_note"] == null ? '' : json["customer_note"],
    billing: json["billing"] == null ? Address.fromJson({}) : Address.fromJson(json["billing"]),
    shipping: json["shipping"] == null ? Address.fromJson({}) : Address.fromJson(json["shipping"]),
    paymentMethod: json["payment_method"] == null ? '' : json["payment_method"],
    paymentMethodTitle: json["payment_method_title"] == null ? '' : json["payment_method_title"],
    transactionId: json["transaction_id"] == null ? '' : json["transaction_id"],
    datePaid: json["date_paid"],
    datePaidGmt: json["date_paid_gmt"],
    dateCompleted: json["date_completed"],
    dateCompletedGmt: json["date_completed_gmt"],
    cartHash: json["cart_hash"] == null ? '' : json["cart_hash"],
    metaData: json["meta_data"] == null ? [] : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
    lineItems: json["line_items"] == null ? [] : List<LineItem>.from(json["line_items"].map((x) => LineItem.fromJson(x))),
    taxLines: json["tax_lines"] == null ? [] : List<dynamic>.from(json["tax_lines"].map((x) => x)),
    shippingLines: json["shipping_lines"] == null ? [] : List<ShippingLine>.from(json["shipping_lines"].map((x) => ShippingLine.fromJson(x))),
    feeLines: json["fee_lines"] == null ? [] : List<FeeLine>.from(json["fee_lines"].map((x) => FeeLine.fromJson(x))),
    couponLines: json["coupon_lines"] == null ? [] : List<dynamic>.from(json["coupon_lines"].map((x) => x)),
    refunds: json["refunds"] == null ? [] : List<dynamic>.from(json["refunds"].map((x) => x)),
    decimals: json["decimals"] == null ? 2 : json["decimals"],
    deliveryTime: json["delivery_time"] == null ? '' : json["delivery_time"],
    deliveryBoy: json["delivery_boy"] == null ? DeliveryBoy.fromJson({}) : DeliveryBoy.fromJson(json["delivery_boy"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId,
    "number": number.isEmpty ? null : number,
    "order_key": orderKey.isEmpty ? null : orderKey,
    "status": status.isEmpty ? null : status,
    "discount_total": discountTotal.isEmpty ? null : discountTotal,
    "discount_tax": discountTax.isEmpty ? null : discountTax,
    "shipping_total": shippingTotal.isEmpty ? null : shippingTotal,
    "shipping_tax": shippingTax.isEmpty ? null : shippingTax,
    "cart_tax": cartTax.isEmpty ? null : cartTax,
    "total": total.isEmpty ? null : total,
    "total_tax": totalTax.isEmpty ? null : totalTax,
    "customer_note": customerNote.isEmpty ? null : customerNote,
    "billing": billing.toJson(),
    "shipping": shipping.toJson(),
    "payment_method": paymentMethod.isEmpty ? null : paymentMethod,
    "payment_method_title": paymentMethodTitle.isEmpty ? null : paymentMethodTitle,
    "line_items": lineItems.isEmpty ? null : List<dynamic>.from(lineItems.map((x) => x.toJson())),
    "tax_lines": taxLines.isEmpty ? null : List<dynamic>.from(taxLines.map((x) => x)),
    "shipping_lines": shippingLines.isEmpty ? null : List<dynamic>.from(shippingLines.map((x) => x.toJson())),
    "fee_lines": feeLines.isEmpty ? null : List<dynamic>.from(feeLines.map((x) => x)),
    "coupon_lines": couponLines.isEmpty ? null : List<dynamic>.from(couponLines.map((x) => x)),
    "refunds": refunds.isEmpty ? null : List<dynamic>.from(refunds.map((x) => x)),
  };
}

class FeeLine {
  FeeLine({
    required this.id,
    required this.name,
    required this.amount,
    required this.total,
  });

  int id;
  String name;
  String amount;
  String total;

  factory FeeLine.fromJson(Map<String, dynamic> json) => FeeLine(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    amount: json["amount"] == null ? '' : json["amount"],
    total: json["total"] == null ? '' : json["total"],
  );
}


class DeliveryBoy {
  DeliveryBoy({
    required this.name,
    required this.phone,
  });

  String name;
  String phone;

  factory DeliveryBoy.fromJson(Map<String, dynamic> json) => DeliveryBoy(
    name: json["name"] == null || json["phone"] == false ? '' : json["name"],
    phone: json["phone"] == null || json["phone"] == false ? '' : json["phone"],
  );
}

class LineItem {
  int id;
  String name;
  int productId;
  int variationId;
  int quantity;
  String taxClass;
  String subtotal;
  String subtotalTax;
  String total;
  String totalTax;
  List<dynamic> taxes;
  List<LineItemMetaDatum> metaData;
  String sku;
  double price;

  LineItem({
    required this.id,
    required this.name,
    required this.productId,
    required this.variationId,
    required this.quantity,
    required this.taxClass,
    required this.subtotal,
    required this.subtotalTax,
    required this.total,
    required this.totalTax,
    required this.taxes,
    required this.metaData,
    required this.sku,
    required this.price,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
    id: json["id"] == null ? 0 : json["id"],
    name: json["name"] == null ? '' : json["name"],
    productId: json["product_id"] == null ? 0 : json["product_id"],
    variationId: json["variation_id"] == null ? 0 : json["variation_id"],
    quantity: json["quantity"] == null ? 1 : json["quantity"],
    taxClass: json["tax_class"] == null ? '' : json["tax_class"],
    subtotal: json["subtotal"] == null ? '' : json["subtotal"],
    subtotalTax: json["subtotal_tax"] == null ? '' : json["subtotal_tax"],
    total: json["total"] == null ? '' : json["total"],
    totalTax: json["total_tax"] == null ? '' : json["total_tax"],
    metaData: json["meta_data"] == null ? [] : List<LineItemMetaDatum>.from(json["meta_data"].map((x) => LineItemMetaDatum.fromMap(x))),
    taxes: json["taxes"] == null ? [] : List<dynamic>.from(json["taxes"].map((x) => x)),
    sku: json["sku"] == null ? '' : json["sku"],
    price: json["price"] == null ? 0 : json["price"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id == 0 ? null : id,
    "name": name == null ? null : name,
    "product_id": productId == 0 ? null : productId,
    "variation_id": variationId == 0 ? null : variationId,
    "quantity": quantity == 0 ? 0 : quantity,
    "tax_class": taxClass.isEmpty ? null : taxClass,
    "subtotal": subtotal.isEmpty ? null : subtotal,
    "subtotal_tax": subtotalTax.isEmpty ? null : subtotalTax,
    "total": total.isEmpty ? null : total,
    "total_tax": totalTax.isEmpty ? null : totalTax,
    "taxes": taxes.isEmpty ? null : List<dynamic>.from(taxes.map((x) => x)),
    "meta_data": metaData.isEmpty ? null : List<dynamic>.from(metaData.map((x) => x)),
    "sku": sku.isEmpty ? null : sku,
    "price": price == 0 ? 0 : price,
  };
}


class LineItemMetaDatum {
  LineItemMetaDatum({
    required this.id,
    required this.key,
    required this.value,
  });

  int id;
  String key;
  dynamic value;

  factory LineItemMetaDatum.fromJson(String str) => LineItemMetaDatum.fromMap(json.decode(str));

  factory LineItemMetaDatum.fromMap(Map<String, dynamic> json) => LineItemMetaDatum(
    id: json["id"] == null ? 0 : json["id"],
    key: json["key"] == null ? '' : json["key"],
    value: json["value"] == null ? '' : json["value"],
  );
}

class MetaDatum {
  int id;
  String key;
  String? value;

  MetaDatum({
    required this.id,
    required this.key,
    required this.value,
  });

  factory MetaDatum.fromJson(Map<String, dynamic> json) {
    try {
      return MetaDatum(
        id: json["id"] == null ? 0 : json["id"],
        key: json["key"] == null ? '' : json["key"],
        value: json["value"] == null ? '' : json["value"],
      );
    } catch (e, s) {
      return MetaDatum(
        id: json["id"] == null ? 0 : json["id"],
        key: json["key"] == null ? '' : json["key"],
        value: null,
      );
    }
  }
}

class ShippingLine {
  int id;
  String methodTitle;
  String methodId;
  String instanceId;
  String total;
  String totalTax;
  List<dynamic> taxes;
  List<MetaDatum> metaData;

  ShippingLine({
    required this.id,
    required this.methodTitle,
    required this.methodId,
    required this.instanceId,
    required this.total,
    required this.totalTax,
    required this.taxes,
    required this.metaData,
  });

  factory ShippingLine.fromJson(Map<String, dynamic> json) => ShippingLine(
    id: json["id"] == null ? 0 : json["id"],
    methodTitle: json["method_title"] == null ? '' : json["method_title"],
    methodId: json["method_id"] == null ? '' : json["method_id"],
    instanceId: json["instance_id"] == null ? '' : json["instance_id"],
    total: json["total"] == null ? '' : json["total"],
    totalTax: json["total_tax"] == null ? '' : json["total_tax"],
    taxes: json["taxes"] == null ? [] : List<dynamic>.from(json["taxes"].map((x) => x)),
    metaData: json["meta_data"] == null ? [] : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == 0 ? 0 : id,
    "method_title": methodTitle.isEmpty ? null : methodTitle,
    "method_id": methodId.isEmpty ? null : methodId,
    "instance_id": instanceId.isEmpty ? null : instanceId,
    "total": total.isEmpty ? null : total,
    "total_tax": totalTax.isEmpty ? null : totalTax,
    "taxes": taxes.isEmpty ? null : List<dynamic>.from(taxes.map((x) => x)),
  };
}

StatusModel statusModelFromJson(String str) => StatusModel.fromJson(json.decode(str));

class StatusModel {
  StatusModel({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
    status: json["status"] == null ? false : json["status"],
    message: json["message"] != null ? json["message"] : json["data"] != null ? json["data"] : '',
  );
}
