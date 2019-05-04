import 'package:meta/meta.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:photo/data/model/page_data.dart';
import 'package:photo/redux/action_report.dart';

class PhotoState {
  final Map<String, Photo> photos;
  final Photo photo;
  final Map<String, ActionReport> status;
  final Page page;
  final Map<int, PhotoOfCollection> collectionPhotos;

  PhotoState({
    @required this.photos,
    @required this.photo,
    @required this.status,
    @required this.page,
    @required this.collectionPhotos
  });

  PhotoState copyWith({
    Map<String, Photo> photos,
    Photo photo,
    Map<String, ActionReport> status,
    Page page,
    Map<int, PhotoOfCollection> collectionPhotos,
  }) {
    return PhotoState(
      photos: photos ?? this.photos ?? Map(),
      photo: photo ?? this.photo,
      status: status ?? this.status,
      page: page ?? this.page,
      collectionPhotos: collectionPhotos??this.collectionPhotos,
    );
  }
}
