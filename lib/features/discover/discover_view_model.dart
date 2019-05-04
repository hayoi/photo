import 'package:redux/redux.dart';
import 'package:photo/data/model/collection_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/collection/collection_actions.dart';

class DiscoverViewModel {
  final Collection collection;
  final List<Collection> collections;
  final Function(bool) getCollections;
  final ActionReport getCollectionsReport;
  final Function(Collection) createCollection;
  final ActionReport createCollectionReport;
  final Function(Collection) updateCollection;
  final ActionReport updateCollectionReport;
  final Function(Collection) deleteCollection;
  final ActionReport deleteCollectionReport;

  DiscoverViewModel({
    this.collection,
    this.collections,
    this.getCollections,
    this.getCollectionsReport,
    this.createCollection,
    this.createCollectionReport,
    this.updateCollection,
    this.updateCollectionReport,
    this.deleteCollection,
    this.deleteCollectionReport,
  });

  static DiscoverViewModel fromStore(Store<AppState> store) {
    return DiscoverViewModel(
      collection: store.state.collectionState.collection,
      collections: store.state.collectionState.collections.values.toList() ?? [],
      getCollections: (isRefresh) {
        store.dispatch(GetCollectionsAction(isRefresh: isRefresh));
      },
      getCollectionsReport: store.state.collectionState.status["GetCollectionsAction"],
      createCollection: (collection) {
        store.dispatch(CreateCollectionAction(collection: collection));
      },
      createCollectionReport: store.state.collectionState.status["CreateCollectionAction"],
      updateCollection: (collection) {
        store.dispatch(UpdateCollectionAction(collection: collection));
      },
      updateCollectionReport: store.state.collectionState.status["UpdateCollectionAction"],
      deleteCollection: (collection) {
        store.dispatch(DeleteCollectionAction(collection: collection));
      },
      deleteCollectionReport: store.state.collectionState.status["DeleteCollectionAction"],
    );
  }
}
