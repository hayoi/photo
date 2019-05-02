import 'package:meta/meta.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:photo/data/model/page_data.dart';
import 'package:photo/redux/action_report.dart';

class PhotoState {
  final Map<String, Photo> photos;
  final Photo photo;
  final Map<String, ActionReport> status;
  final Page page;

  PhotoState({
    @required this.photos,
    @required this.photo,
    @required this.status,
    @required this.page,
  });

  PhotoState copyWith({
    Map<String, Photo> photos,
    Photo photo,
    Map<String, ActionReport> status,
    Page page,
  }) {
    return PhotoState(
      photos: photos ?? this.photos ?? Map(),
      photo: photo ?? this.photo,
      status: status ?? this.status,
      page: page ?? this.page,
    );
  }
}
