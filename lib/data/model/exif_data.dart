import 'dart:convert';
import 'package:intl/intl.dart';

class Exif {
  String exposureTime;
  String aperture;
  String focalLength;
  int iso;
  String model;
  String make;

  Exif({
    this.exposureTime = "",
    this.aperture = "",
    this.focalLength = "",
    this.iso = 0,
    this.model = "",
    this.make = "",
  });

  Exif.fromJson(Map<String, dynamic>  map) :
        exposureTime = map['exposure_time']  ?? "",
        aperture = map['aperture']  ?? "",
        focalLength = map['focal_length']  ?? "",
        iso = map['iso']  ?? 0,
        model = map['model']  ?? "",
        make = map['make']  ?? "";

  Map<String, dynamic> toJson() => {
        'exposure_time': exposureTime,
        'aperture': aperture,
        'focal_length': focalLength,
        'iso': iso,
        'model': model,
        'make': make,
      };

  Exif copyWith({
    String exposureTime,
    String aperture,
    String focalLength,
    int iso,
    String model,
    String make,
  }) {
    return Exif(
      exposureTime: exposureTime ?? this.exposureTime,
      aperture: aperture ?? this.aperture,
      focalLength: focalLength ?? this.focalLength,
      iso: iso ?? this.iso,
      model: model ?? this.model,
      make: make ?? this.make,
    );
  }

}

