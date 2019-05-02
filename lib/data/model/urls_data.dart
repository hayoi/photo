import 'dart:convert';
import 'package:intl/intl.dart';

class Urls {
  String small;
  String thumb;
  String raw;
  String regular;
  String full;

  Urls({
    this.small = "",
    this.thumb = "",
    this.raw = "",
    this.regular = "",
    this.full = "",
  });

  Urls.fromJson(Map<String, dynamic>  map) :
        small = map['small']  ?? "",
        thumb = map['thumb']  ?? "",
        raw = map['raw']  ?? "",
        regular = map['regular']  ?? "",
        full = map['full']  ?? "";

  Map<String, dynamic> toJson() => {
        'small': small,
        'thumb': thumb,
        'raw': raw,
        'regular': regular,
        'full': full,
      };

  Urls copyWith({
    String small,
    String thumb,
    String raw,
    String regular,
    String full,
  }) {
    return Urls(
      small: small ?? this.small,
      thumb: thumb ?? this.thumb,
      raw: raw ?? this.raw,
      regular: regular ?? this.regular,
      full: full ?? this.full,
    );
  }

}

