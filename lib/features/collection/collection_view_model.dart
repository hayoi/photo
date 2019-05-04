import 'package:redux/redux.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/photo/photo_actions.dart';

class CollectionViewModel {
  final List<Photo> photos;
  final Function(bool) getPhotoOfCollection;
  final ActionReport getPhotoOfCollectionReport;

  CollectionViewModel({
    this.photos,
    this.getPhotoOfCollection,
    this.getPhotoOfCollectionReport
  });

  static CollectionViewModel fromStore(Store<AppState> store, int id) {
    return CollectionViewModel(
      photos: store.state.photoState.collectionPhotos[id]?.photos?.values
          ?.toList() ?? [],
      getPhotoOfCollection: (isRefresh) {
        store.dispatch(GetCollectionPhotosAction(id: id, isRefresh: isRefresh));
      },
      getPhotoOfCollectionReport: store.state.photoState.status["GetCollectionPhotosAction"],
    );
  }
}
