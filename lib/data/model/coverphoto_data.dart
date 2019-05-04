import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:photo/data/model/urls_data.dart';
import 'package:photo/data/model/links_data.dart';
import 'package:photo/data/model/user_data.dart';

class CoverPhoto {
  Urls urls;
  String color;
  int width;
  String description;
  Links links;
  String id;
  bool likedByUser;
  User user;
  int height;
  int likes;

  CoverPhoto({
    this.urls,
    this.color = "",
    this.width = 0,
    this.description = "",
    this.links,
    this.id = "",
    this.likedByUser = false,
    this.user,
    this.height = 0,
    this.likes = 0,
  });

  CoverPhoto.fromJson(Map<String, dynamic>  map) :
        urls = map['urls'] == null
            ? null
            : Urls.fromJson(map['urls']),
        color = map['color']  ?? "",
        width = map['width']  ?? 0,
        description = map['description']  ?? "",
        links = map['links'] == null
            ? null
            : Links.fromJson(map['links']),
        id = map['id']  ?? "",
        likedByUser = map['liked_by_user']  ?? false,
        user = map['user'] == null
            ? null
            : User.fromJson(map['user']),
        height = map['height']  ?? 0,
        likes = map['likes']  ?? 0;

  Map<String, dynamic> toJson() => {
        'urls': urls.toJson(),
        'color': color,
        'width': width,
        'description': description,
        'links': links.toJson(),
        'id': id,
        'liked_by_user': likedByUser,
        'user': user.toJson(),
        'height': height,
        'likes': likes,
      };

  CoverPhoto copyWith({
    Urls urls,
    String color,
    int width,
    String description,
    Links links,
    String id,
    bool likedByUser,
    User user,
    int height,
    int likes,
  }) {
    return CoverPhoto(
      urls: urls ?? this.urls,
      color: color ?? this.color,
      width: width ?? this.width,
      description: description ?? this.description,
      links: links ?? this.links,
      id: id ?? this.id,
      likedByUser: likedByUser ?? this.likedByUser,
      user: user ?? this.user,
      height: height ?? this.height,
      likes: likes ?? this.likes,
    );
  }

}

