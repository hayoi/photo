import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:photo/data/model/coverphoto_data.dart';
import 'package:photo/data/model/links_data.dart';
import 'package:photo/data/model/user_data.dart';

class Collection {
  bool private;
  CoverPhoto coverPhoto;
  DateTime updatedAt;
  int totalPhotos;
  bool curated;
  String shareKey;
  String description;
  Links links;
  int id;
  String title;
  DateTime publishedAt;
  User user;

  Collection({
    this.private = false,
    this.coverPhoto,
    this.updatedAt,
    this.totalPhotos = 0,
    this.curated = false,
    this.shareKey = "",
    this.description = "",
    this.links,
    this.id = 0,
    this.title = "",
    this.publishedAt,
    this.user,
  });

  Collection.fromJson(Map<String, dynamic>  map) :
        private = map['private']  ?? false,
        coverPhoto = map['cover_photo'] == null
            ? null
            : CoverPhoto.fromJson(map['cover_photo']),
        updatedAt = map['updated_at'] == null ? null
               : DateTime.parse(map["updated_at"]),
        totalPhotos = map['total_photos']  ?? 0,
        curated = map['curated']  ?? false,
        shareKey = map['share_key']  ?? "",
        description = map['description']  ?? "",
        links = map['links'] == null
            ? null
            : Links.fromJson(map['links']),
        id = map['id']  ?? 0,
        title = map['title']  ?? "",
        publishedAt = map['published_at'] == null ? null
               : DateTime.parse(map["published_at"]),
        user = map['user'] == null
            ? null
            : User.fromJson(map['user']);

  Map<String, dynamic> toJson() => {
        'private': private,
        'cover_photo': coverPhoto.toJson(),
        'updated_at': updatedAt == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAt),
        'total_photos': totalPhotos,
        'curated': curated,
        'share_key': shareKey,
        'description': description,
        'links': links.toJson(),
        'id': id,
        'title': title,
        'published_at': publishedAt == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(publishedAt),
        'user': user.toJson(),
      };

  Collection copyWith({
    bool private,
    CoverPhoto coverPhoto,
    DateTime updatedAt,
    int totalPhotos,
    bool curated,
    String shareKey,
    String description,
    Links links,
    int id,
    String title,
    DateTime publishedAt,
    User user,
  }) {
    return Collection(
      private: private ?? this.private,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      updatedAt: updatedAt ?? this.updatedAt,
      totalPhotos: totalPhotos ?? this.totalPhotos,
      curated: curated ?? this.curated,
      shareKey: shareKey ?? this.shareKey,
      description: description ?? this.description,
      links: links ?? this.links,
      id: id ?? this.id,
      title: title ?? this.title,
      publishedAt: publishedAt ?? this.publishedAt,
      user: user ?? this.user,
    );
  }

}