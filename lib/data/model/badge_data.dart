import 'dart:convert';
import 'package:intl/intl.dart';

class Badge {
  String link;
  String title;
  String slug;
  bool primary;

  Badge({
    this.link = "",
    this.title = "",
    this.slug = "",
    this.primary = false,
  });

  Badge.fromJson(Map<String, dynamic>  map) :
        link = map['link']  ?? "",
        title = map['title']  ?? "",
        slug = map['slug']  ?? "",
        primary = map['primary']  ?? false;

  Map<String, dynamic> toJson() => {
        'link': link,
        'title': title,
        'slug': slug,
        'primary': primary,
      };

  Badge copyWith({
    String link,
    String title,
    String slug,
    bool primary,
  }) {
    return Badge(
      link: link ?? this.link,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      primary: primary ?? this.primary,
    );
  }

}

