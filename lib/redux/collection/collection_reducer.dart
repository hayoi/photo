import 'package:redux/redux.dart';
import 'package:photo/redux/collection/collection_actions.dart';
import 'package:photo/redux/collection/collection_state.dart';

final collectionReducer = combineReducers<CollectionState>([
  TypedReducer<CollectionState, CollectionStatusAction>(_collectionStatus),
  TypedReducer<CollectionState, SyncCollectionsAction>(_syncCollections),
  TypedReducer<CollectionState, SyncCollectionAction>(_syncCollection),
  TypedReducer<CollectionState, RemoveCollectionAction>(_removeCollection),
]);

CollectionState _collectionStatus(CollectionState state, CollectionStatusAction action) {
  var status = state.status ?? Map();
  status.update(action.report.actionName, (v) => action.report,
      ifAbsent: () => action.report);
  return state.copyWith(status: status);
}

CollectionState _syncCollections(CollectionState state, SyncCollectionsAction action) {
  for (var collection in action.collections) {
    state.collections.update(collection.id.toString(), (v) => collection, ifAbsent: () => collection);
  }
  state.page.last = action.page.last;
  state.page.prev = action.page.prev;
  state.page.first = action.page.first;
  state.page.next = action.page.next;
  return state.copyWith(collections: state.collections);
}

CollectionState _syncCollection(CollectionState state, SyncCollectionAction action) {
  state.collections.update(action.collection.id.toString(), (u) => action.collection,
      ifAbsent: () => action.collection);
  return state.copyWith(collections: state.collections, collection: action.collection);
}

CollectionState _removeCollection(CollectionState state, RemoveCollectionAction action) {
  return state.copyWith(collections: state.collections..remove(action.id.toString()));
}
