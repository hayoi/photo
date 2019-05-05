import 'package:photo/data/model/photo_data.dart';
import 'package:photo/redux/photo/photo_actions.dart';
import 'package:redux/redux.dart';
import 'package:photo/data/model/collection_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/collection/collection_actions.dart';

class CollectListViewModel {
  final Map<int, PhotoOfCollection> collectionPhotos;
  final List<Collection> collections;
  final Function(bool) getCollections;
  final ActionReport getCollectionsReport;
  final Function(bool, int) getPhotoOfCollection;
  final ActionReport getPhotoOfCollectionReport;

  CollectListViewModel({
    this.collectionPhotos,
    this.collections,
    this.getCollections,
    this.getCollectionsReport,
    this.getPhotoOfCollection,
    this.getPhotoOfCollectionReport
  });

  static CollectListViewModel fromStore(Store<AppState> store) {
    return CollectListViewModel(
      collectionPhotos: store.state.photoState.collectionPhotos ?? Map(),
      collections:
          store.state.collectionState.collections.values.toList() ?? [],
      getCollections: (isRefresh) {
        store.dispatch(GetCollectionsAction(isRefresh: isRefresh));
      },
      getCollectionsReport:
          store.state.collectionState.status["GetCollectionsAction"],
      getPhotoOfCollection: (isRefresh, id) {
        store.dispatch(GetCollectionPhotosAction(id: id, isRefresh: isRefresh));
      },
      getPhotoOfCollectionReport: store.state.photoState.status["GetCollectionPhotosAction"],
    );
  }
}
