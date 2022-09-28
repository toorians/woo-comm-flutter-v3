// To parse this JSON data, do
//
//     final geoCodeAddress = geoCodeAddressFromJson(jsonString);

import 'dart:convert';

GeoCodeAddress geoCodeAddressFromJson(String str) => GeoCodeAddress.fromJson(json.decode(str));

class GeoCodeAddress {
  GeoCodeAddress({
    required this.status,
    required this.results,
  });

  String status;
  List<Result> results;

  factory GeoCodeAddress.fromJson(Map<String, dynamic> json) => GeoCodeAddress(
    status: json["status"] == null ? '' : json["status"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );
}

class Result {
  Result({
    required this.types,
    required this.formattedAddress,
    required this.addressComponents,
    required this.geometry,
  });

  List<String> types;
  String formattedAddress;
  List<AddressComponent> addressComponents;
  Geometry geometry;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    types: json["types"] == null ? [] : List<String>.from(json["types"].map((x) => x)),
    formattedAddress: json["formatted_address"] == null ? '' : json["formatted_address"],
    addressComponents: json["address_components"] == null ? [] : List<AddressComponent>.from(json["address_components"].map((x) => AddressComponent.fromJson(x))),
    geometry: json["geometry"] == null ? Geometry.fromJson({}) : Geometry.fromJson(json["geometry"]),
  );
}

class AddressComponent {
  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  String longName;
  String shortName;
  List<String> types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    longName: json["long_name"] == null ? '' : json["long_name"],
    shortName: json["short_name"] == null ? '' : json["short_name"],
    types: json["types"] == null ? [] : List<String>.from(json["types"].map((x) => x)),
  );
}

class Geometry {
  Geometry({
    required this.location,
    required this.locationType,
    required this.viewport,
  });

  GeoCodeAddressLocation location;
  String locationType;
  Viewport viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: json["location"] == null ? GeoCodeAddressLocation.fromJson({}) : GeoCodeAddressLocation.fromJson(json["location"]),
    locationType: json["location_type"] == null ? '' : json["location_type"],
    viewport: json["viewport"] == null ? Viewport.fromJson({}) : Viewport.fromJson(json["viewport"]),
  );

}

class GeoCodeAddressLocation {
  GeoCodeAddressLocation({
    required this.lat,
    required this.lng,
  });

  double lat;
  double lng;

  factory GeoCodeAddressLocation.fromJson(Map<String, dynamic> json) => GeoCodeAddressLocation(
    lat: json["lat"] == null ? '0.0' : json["lat"].toDouble(),
    lng: json["lng"] == null ? '0.0' : json["lng"].toDouble(),
  );
}

class Viewport {
  Viewport({
    required this.southwest,
    required this.northeast,
  });

  GeoCodeAddressLocation southwest;
  GeoCodeAddressLocation northeast;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    southwest: json["southwest"] == null ? GeoCodeAddressLocation.fromJson({}) : GeoCodeAddressLocation.fromJson(json["southwest"]),
    northeast: json["northeast"] == null ? GeoCodeAddressLocation.fromJson({}) : GeoCodeAddressLocation.fromJson(json["northeast"]),
  );
}
