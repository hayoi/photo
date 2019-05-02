import 'dart:convert';
import 'package:intl/intl.dart';

class TagsItem {
  String title;

  TagsItem({
    this.title = "",
  });

  TagsItem.fromJson(Map<String, dynamic>  map) :
        title = map['title']  ?? "";

  Map<String, dynamic> toJson() => {
        'title': title,
      };

  TagsItem copyWith({
    String title,
  }) {
    return TagsItem(
      title: title ?? this.title,
    );
  }

}

