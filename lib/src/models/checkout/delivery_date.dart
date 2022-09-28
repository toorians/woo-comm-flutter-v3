

// To parse this JSON data, do
//
//     final deliveryTime = deliveryTimeFromJson(jsonString);

import 'dart:convert';

DeliveryTime deliveryTimeFromJson(String str) => DeliveryTime.fromJson(json.decode(str));

class DeliveryTime {
  DeliveryTime({
    required this.success,
    required this.reservation,
    required this.html,
    required this.slots,
  });

  bool success;
  bool reservation;
  String html;
  List<Slot> slots;

  factory DeliveryTime.fromJson(Map<String, dynamic> json) => DeliveryTime(
    success: json["success"] == null ? false : json["success"],
    reservation: json["reservation"] == null ? false : json["reservation"],
    html: json["html"] == null ? '' : json["html"],
    slots: json["slots"] == null ? [] : List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
  );
}

class Slot {
  Slot({
    required this.timefrom,
    required this.timeto,
    required this.cutoff,
    required this.lockout,
    required this.shippingMethods,
    required this.fee,
    required this.days,
    required this.id,
    required this.timeId,
    required this.formatted,
    required this.formattedWithFee,
    required this.value,
    required this.slotId,
  });

  Time timefrom;
  Time timeto;
  String cutoff;
  String lockout;
  List<String> shippingMethods;
  Fee fee;
  List<String> days;
  int id;
  String timeId;
  String formatted;
  String formattedWithFee;
  String value;
  String slotId;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    timefrom: json["timefrom"] == null ? Time.fromJson({}) : Time.fromJson(json["timefrom"]),
    timeto: json["timeto"] == null ? Time.fromJson({}) : Time.fromJson(json["timeto"]),
    cutoff: json["cutoff"] == null ? '' : json["cutoff"],
    lockout: json["lockout"] == null ? '' : json["lockout"].toString(),
    shippingMethods: json["shipping_methods"] == null ? [] : List<String>.from(json["shipping_methods"].map((x) => x)),
    fee: json["fee"] == null ? Fee.fromJson({}) : Fee.fromJson(json["fee"]),
    days: json["days"] == null ? [] : List<String>.from(json["days"].map((x) => x)),
    id: json["id"] == null ? 0 : json["id"],
    timeId: json["time_id"] == null ? '' : json["time_id"],
    formatted: json["formatted"] == null ? '' : json["formatted"],
    formattedWithFee: json["formatted_with_fee"] == null ? '' : json["formatted_with_fee"],
    value: json["value"] == null ? '' : json["value"],
    slotId: json["slot_id"] == null ? '' : json["slot_id"],
  );
}

class Fee {
  Fee({
    required this.value,
    required this.formatted,
  });

  String value;
  String formatted;

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
    value: json["value"] == null ? '' : json["value"],
    formatted: json["formatted"] == null ? '' : json["formatted"],
  );
}

class Time {
  Time({
    required this.time,
    required this.stripped,
  });

  String time;
  String stripped;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    time: json["time"] == null ? '' : json["time"],
    stripped: json["stripped"] == null ? '' : json["stripped"],
  );
}

DeliveryDate deliveryDateFromJson(String str) => DeliveryDate.fromJson(json.decode(str));

class DeliveryDate {
  DeliveryDate({
    required this.success,
    required this.bookableDates,
  });

  bool success;
  List<String> bookableDates;

  factory DeliveryDate.fromJson(Map<String, dynamic> json) => DeliveryDate(
    success: json["success"] == null ? false : json["success"],
    bookableDates: json["bookable_dates"] == null ? [] : List<String>.from(json["bookable_dates"].map((x) => x)),
  );
}

