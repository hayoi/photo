import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:photo/data/model/badge_data.dart';
import 'package:photo/data/model/links_data.dart';
import 'package:photo/data/model/profileimage_data.dart';

class User {
  int totalPhotos;
  bool followedByUser;
  String twitterUsername;
  String lastName;
  String bio;
  int totalLikes;
  String portfolioUrl;
  Badge badge;
  ProfileImage profileImage;
  DateTime updatedAt;
  int followingCount;
  int downloads;
  int followersCount;
  String name;
  String location;
  int totalCollections;
  Links links;
  String id;
  String firstName;
  String instagramUsername;
  String username;

  User({
    this.totalPhotos = 0,
    this.followedByUser = false,
    this.twitterUsername = "",
    this.lastName = "",
    this.bio = "",
    this.totalLikes = 0,
    this.portfolioUrl,
    this.badge,
    this.profileImage,
    this.updatedAt,
    this.followingCount = 0,
    this.downloads = 0,
    this.followersCount = 0,
    this.name = "",
    this.location = "",
    this.totalCollections = 0,
    this.links,
    this.id = "",
    this.firstName = "",
    this.instagramUsername = "",
    this.username = "",
  });

  User.fromJson(Map<String, dynamic>  map) :
        totalPhotos = map['total_photos']  ?? 0,
        followedByUser = map['followed_by_user']  ?? false,
        twitterUsername = map['twitter_username']  ?? "",
        lastName = map['last_name']  ?? "",
        bio = map['bio']  ?? "",
        totalLikes = map['total_likes']  ?? 0,
        portfolioUrl = map['portfolio_url']  ?? null,
        badge = map['badge'] == null
            ? null
            : Badge.fromJson(map['badge']),
        profileImage = map['profile_image'] == null
            ? null
            : ProfileImage.fromJson(map['profile_image']),
        updatedAt = map['updated_at'] == null ? null
               : DateTime.parse(map["updated_at"]),
        followingCount = map['following_count']  ?? 0,
        downloads = map['downloads']  ?? 0,
        followersCount = map['followers_count']  ?? 0,
        name = map['name']  ?? "",
        location = map['location']  ?? "",
        totalCollections = map['total_collections']  ?? 0,
        links = map['links'] == null
            ? null
            : Links.fromJson(map['links']),
        id = map['id']  ?? "",
        firstName = map['first_name']  ?? "",
        instagramUsername = map['instagram_username']  ?? "",
        username = map['username']  ?? "";

  Map<String, dynamic> toJson() => {
        'total_photos': totalPhotos,
        'followed_by_user': followedByUser,
        'twitter_username': twitterUsername,
        'last_name': lastName,
        'bio': bio,
        'total_likes': totalLikes,
        'portfolio_url': portfolioUrl,
        'badge': badge.toJson(),
        'profile_image': profileImage.toJson(),
        'updated_at': updatedAt == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAt),
        'following_count': followingCount,
        'downloads': downloads,
        'followers_count': followersCount,
        'name': name,
        'location': location,
        'total_collections': totalCollections,
        'links': links.toJson(),
        'id': id,
        'first_name': firstName,
        'instagram_username': instagramUsername,
        'username': username,
      };

  User copyWith({
    int totalPhotos,
    bool followedByUser,
    String twitterUsername,
    String lastName,
    String bio,
    int totalLikes,
    String portfolioUrl,
    Badge badge,
    ProfileImage profileImage,
    DateTime updatedAt,
    int followingCount,
    int downloads,
    int followersCount,
    String name,
    String location,
    int totalCollections,
    Links links,
    String id,
    String firstName,
    String instagramUsername,
    String username,
  }) {
    return User(
      totalPhotos: totalPhotos ?? this.totalPhotos,
      followedByUser: followedByUser ?? this.followedByUser,
      twitterUsername: twitterUsername ?? this.twitterUsername,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      totalLikes: totalLikes ?? this.totalLikes,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      badge: badge ?? this.badge,
      profileImage: profileImage ?? this.profileImage,
      updatedAt: updatedAt ?? this.updatedAt,
      followingCount: followingCount ?? this.followingCount,
      downloads: downloads ?? this.downloads,
      followersCount: followersCount ?? this.followersCount,
      name: name ?? this.name,
      location: location ?? this.location,
      totalCollections: totalCollections ?? this.totalCollections,
      links: links ?? this.links,
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      instagramUsername: instagramUsername ?? this.instagramUsername,
      username: username ?? this.username,
    );
  }

}

class Login {
  String name;
  String password;

  Login(this.name, this.password);

  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
      };
}
