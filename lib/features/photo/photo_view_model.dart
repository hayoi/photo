import 'package:redux/redux.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/photo/photo_actions.dart';

class PhotoViewModel {
  final Photo photo;
  final List<Photo> photos;
  final Function(bool, String) getPhotos;
  final ActionReport getPhotosReport;

  PhotoViewModel({
    this.photo,
    this.photos,
    this.getPhotos,
    this.getPhotosReport,
  });

  static PhotoViewModel fromStore(Store<AppState> store) {
    return PhotoViewModel(
      photo: store.state.photoState.photo,
      photos: store.state.photoState.photos.values.toList() ?? [],
      getPhotos: (isRefresh, orderBy) {
        store.dispatch(GetPhotosAction(isRefresh: isRefresh,orderBy: orderBy));
      },
      getPhotosReport: store.state.photoState.status["GetPhotosAction"],
    );
  }
}
