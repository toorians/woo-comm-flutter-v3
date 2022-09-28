import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'models/blocks_model.dart';

String parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}

showSnackBarError(BuildContext context, String message) {
  final snackBar = SnackBar(
      backgroundColor: Theme.of(context).errorColor,
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.onError),
      ));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showSnackBarSuccess(BuildContext context, String message) {
  final snackBar = SnackBar(
      //backgroundColor: Colors.green,
      content: Text(
        message,
      ));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

dynamic getOrderIdFromUrl(String str) {
  print(str);
  String? orderId;
  if(str.contains('app_checkout_order_id=')) {
    var uri = Uri.dataFromString(str);
    Map<String, String> params = uri.queryParameters;
    orderId = params['app_checkout_order_id']!;
    return orderId;
  } else if(str.contains('order_id=')) {
    var uri = Uri.dataFromString(str);
    Map<String, String> params = uri.queryParameters;
    orderId = params['order_id']!;
    return orderId;
  } else if (str.contains('/order-received/') && str.contains('/?key=wc_order')) {
    int pos1 = str.lastIndexOf("/order-received/");
    int pos2 = str.lastIndexOf("/?key=wc_order");
    orderId = str.substring(pos1 + 16, pos2);
    return orderId;
  } else if (str.contains('/order-pay/') && str.contains('/?key=wc_order')) {
    int pos1 = str.lastIndexOf('/order-pay/');
    int pos2 = str.lastIndexOf('/?key=wc_order');
    orderId = str.substring(pos1 + 11, pos2);
    return orderId;
  } else if (str.contains('/thank-you/') && str.contains('/?key=wc_order')) {
    int pos1 = str.lastIndexOf('/thank-you/');
    int pos2 = str.lastIndexOf('/?key=wc_order');
    orderId = str.substring(pos1 + 11, pos2);
    return orderId;
  } else if (str.contains('/order-received/') && str.contains('/?page_id=')) {
    int pos1 = str.lastIndexOf('/order-received/');
    int pos2 = str.lastIndexOf('/?page_id=');
    orderId = str.substring(pos1 + 16, pos2);
    return orderId;
  }
  if (str.contains('/order-received/') && str.contains('?key=wc_order')) {
    int pos1 = str.lastIndexOf("/order-received/");
    int pos2 = str.lastIndexOf("?key=wc_order");
    orderId = str.substring(pos1 + 16, pos2);
    return orderId;
  } else if (str.contains('/order-pay/') && str.contains('?key=wc_order')) {
    int pos1 = str.lastIndexOf('/order-pay/');
    int pos2 = str.lastIndexOf('?key=wc_order');
    orderId = str.substring(pos1 + 11, pos2);
    return orderId;
  } else if (str.lastIndexOf("/order-pay/") != -1 &&
      str.lastIndexOf("/?key=wc_order") != -1) {
    var pos1 = str.lastIndexOf("/order-pay/");
    var pos2 = str.lastIndexOf("/?key=wc_order");
    orderId = str.substring(pos1 + 11, pos2);
    return orderId;
  } else if(str.contains('order-received=')) {
    var uri = Uri.parse(str);
    orderId = uri.queryParameters['order-received']!;
    return orderId;
  } else {
    return orderId;
  }
}

String getOrderStatusText(String status, LocaleText localeText) {
  switch (status) {
    case "processing":
      return localeText.processing;
    case "completed":
      return localeText.completed;
    case "on-hold":
      return localeText.onHold;
    case "pending":
      return localeText.pending;
    case "refunded":
      return localeText.refunded;
    case "cancelled":
      return localeText.cancelled;
    case "failed":
      return localeText.failed;
    default:
      return status.capitalize();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

