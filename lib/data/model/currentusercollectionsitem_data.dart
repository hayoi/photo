import 'dart:convert';
import 'package:intl/intl.dart';

class CurrentUserCollectionsItem {
  String coverPhoto;
  DateTime updatedAt;
  bool curated;
  int id;
  String title;
  DateTime publishedAt;
  String user;

  CurrentUserCollectionsItem({
    this.coverPhoto,
    this.updatedAt,
    this.curated = false,
    this.id = 0,
    this.title = "",
    this.publishedAt,
    this.user,
  });

  CurrentUserCollectionsItem.fromJson(Map<String, dynamic>  map) :
        coverPhoto = map['cover_photo']  ?? null,
        updatedAt = map['updated_at'] == null ? null
               : DateTime.parse(map["updated_at"]),
        curated = map['curated']  ?? false,
        id = map['id']  ?? 0,
        title = map['title']  ?? "",
        publishedAt = map['published_at'] == null ? null
               : DateTime.parse(map["published_at"]),
        user = map['user']  ?? null;

  Map<String, dynamic> toJson() => {
        'cover_photo': coverPhoto,
        'updated_at': updatedAt == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAt),
        'curated': curated,
        'id': id,
        'title': title,
        'published_at': publishedAt == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(publishedAt),
        'user': user,
      };

  CurrentUserCollectionsItem copyWith({
    String coverPhoto,
    DateTime updatedAt,
    bool curated,
    int id,
    String title,
    DateTime publishedAt,
    String user,
  }) {
    return CurrentUserCollectionsItem(
      coverPhoto: coverPhoto ?? this.coverPhoto,
      updatedAt: updatedAt ?? this.updatedAt,
      curated: curated ?? this.curated,
      id: id ?? this.id,
      title: title ?? this.title,
      publishedAt: publishedAt ?? this.publishedAt,
      user: user ?? this.user,
    );
  }

}

