import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:photo/data/model/position_data.dart';

class Location {
  String country;
  String city;
  Position position;

  Location({
    this.country = "",
    this.city = "",
    this.position,
  });

  Location.fromJson(Map<String, dynamic>  map) :
        country = map['country']  ?? "",
        city = map['city']  ?? "",
        position = map['position'] == null
            ? null
            : Position.fromJson(map['position']);

  Map<String, dynamic> toJson() => {
        'country': country,
        'city': city,
        'position': position.toJson(),
      };

  Location copyWith({
    String country,
    String city,
    Position position,
  }) {
    return Location(
      country: country ?? this.country,
      city: city ?? this.city,
      position: position ?? this.position,
    );
  }

}

