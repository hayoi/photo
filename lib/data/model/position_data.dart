import 'dart:convert';
import 'package:intl/intl.dart';

class Position {
  double latitude;
  double longitude;

  Position({
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  Position.fromJson(Map<String, dynamic>  map) :
        latitude = map['latitude']  ?? 0.0,
        longitude = map['longitude']  ?? 0.0;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  Position copyWith({
    double latitude,
    double longitude,
  }) {
    return Position(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

}

