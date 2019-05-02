import 'dart:convert';
import 'package:intl/intl.dart';

class Links {
  String portfolio;
  String self;
  String html;
  String photos;
  String likes;

  Links({
    this.portfolio = "",
    this.self = "",
    this.html = "",
    this.photos = "",
    this.likes = "",
  });

  Links.fromJson(Map<String, dynamic>  map) :
        portfolio = map['portfolio']  ?? "",
        self = map['self']  ?? "",
        html = map['html']  ?? "",
        photos = map['photos']  ?? "",
        likes = map['likes']  ?? "";

  Map<String, dynamic> toJson() => {
        'portfolio': portfolio,
        'self': self,
        'html': html,
        'photos': photos,
        'likes': likes,
      };

  Links copyWith({
    String portfolio,
    String self,
    String html,
    String photos,
    String likes,
  }) {
    return Links(
      portfolio: portfolio ?? this.portfolio,
      self: self ?? this.self,
      html: html ?? this.html,
      photos: photos ?? this.photos,
      likes: likes ?? this.likes,
    );
  }

}

