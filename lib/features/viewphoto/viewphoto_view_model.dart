import 'package:redux/redux.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/photo/photo_actions.dart';

class ViewPhotoViewModel {
  final List<Photo> photos;

  ViewPhotoViewModel({
    this.photos,
  });

  static ViewPhotoViewModel fromStore(Store<AppState> store, int id) {
    return ViewPhotoViewModel(
      photos: id == 0
          ? store.state.photoState.photos.values.toList() ?? []
          : store.state.photoState.collectionPhotos[id]?.photos?.values
                  ?.toList() ??
              [],
    );
  }
}
