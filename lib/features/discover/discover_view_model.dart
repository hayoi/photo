import 'package:redux/redux.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/photo/photo_actions.dart';

class DiscoverViewModel {
  final Photo photo;
  final List<Photo> photos;
  final Function(bool) getPhotos;
  final ActionReport getPhotosReport;

  DiscoverViewModel({
    this.photo,
    this.photos,
    this.getPhotos,
    this.getPhotosReport,
  });

  static DiscoverViewModel fromStore(Store<AppState> store) {
    return DiscoverViewModel(
      photo: store.state.photoState.photo,
      photos: store.state.photoState.photos.values.toList() ?? [],
      getPhotos: (isRefresh) {
        store.dispatch(GetPhotosAction(isRefresh: isRefresh));
      },
      getPhotosReport: store.state.photoState.status["GetPhotosAction"],
    );
  }
}
