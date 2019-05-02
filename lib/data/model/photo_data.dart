import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:photo/data/model/currentusercollectionsitem_data.dart';
import 'package:photo/data/model/tagsitem_data.dart';
import 'package:photo/data/model/urls_data.dart';
import 'package:photo/data/model/location_data.dart';
import 'package:photo/data/model/links_data.dart';
import 'package:photo/data/model/user_data.dart';
import 'package:photo/data/model/exif_data.dart';

class Photo {
  List<CurrentUserCollectionsItem> currentUserCollections;
  String color;
  DateTime createdAt;
  String description;
  bool likedByUser;
  List<TagsItem> tags;
  Urls urls;
  DateTime updatedAt;
  int downloads;
  int width;
  Location location;
  Links links;
  String id;
  User user;
  int height;
  int likes;
  Exif exif;

  Photo({
    this.currentUserCollections,
    this.color = "",
    this.createdAt,
    this.description = "",
    this.likedByUser = false,
    this.tags,
    this.urls,
    this.updatedAt,
    this.downloads = 0,
    this.width = 0,
    this.location,
    this.links,
    this.id = "",
    this.user,
    this.height = 0,
    this.likes = 0,
    this.exif,
  });

  Photo.fromJson(Map<String, dynamic>  map) :
        color = map['color']  ?? "",
        createdAt = map['created_at'] == null ? null
               : DateTime.parse(map["created_at"]),
        description = map['description']  ?? "",
        likedByUser = map['liked_by_user']  ?? false,
        urls = map['urls'] == null
            ? null
            : Urls.fromJson(map['urls']),
        updatedAt = map['updated_at'] == null ? null
               : DateTime.parse(map["updated_at"]),
        downloads = map['downloads']  ?? 0,
        width = map['width']  ?? 0,
        location = map['location'] == null
            ? null
            : Location.fromJson(map['location']),
        links = map['links'] == null
            ? null
            : Links.fromJson(map['links']),
        id = map['id']  ?? "",
        user = map['user'] == null
            ? null
            : User.fromJson(map['user']),
        height = map['height']  ?? 0,
        likes = map['likes']  ?? 0,
        exif = map['exif'] == null
            ? null
            : Exif.fromJson(map['exif']);

  Map<String, dynamic> toJson() => {
        'current_user_collections': currentUserCollections,
        'color': color,
        'created_at': createdAt == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt),
        'description': description,
        'liked_by_user': likedByUser,
        'tags': tags,
        'urls': urls.toJson(),
        'updated_at': updatedAt == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAt),
        'downloads': downloads,
        'width': width,
        'location': location.toJson(),
        'links': links.toJson(),
        'id': id,
        'user': user.toJson(),
        'height': height,
        'likes': likes,
        'exif': exif.toJson(),
      };

  Photo copyWith({
    List<CurrentUserCollectionsItem> currentUserCollections,
    String color,
    DateTime createdAt,
    String description,
    bool likedByUser,
    List<TagsItem> tags,
    Urls urls,
    DateTime updatedAt,
    int downloads,
    int width,
    Location location,
    Links links,
    String id,
    User user,
    int height,
    int likes,
    Exif exif,
  }) {
    return Photo(
      currentUserCollections: currentUserCollections ?? this.currentUserCollections,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      likedByUser: likedByUser ?? this.likedByUser,
      tags: tags ?? this.tags,
      urls: urls ?? this.urls,
      updatedAt: updatedAt ?? this.updatedAt,
      downloads: downloads ?? this.downloads,
      width: width ?? this.width,
      location: location ?? this.location,
      links: links ?? this.links,
      id: id ?? this.id,
      user: user ?? this.user,
      height: height ?? this.height,
      likes: likes ?? this.likes,
      exif: exif ?? this.exif,
    );
  }

}

