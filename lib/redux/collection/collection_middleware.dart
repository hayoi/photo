import 'package:redux/redux.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/collection/collection_actions.dart';
import 'package:photo/data/model/collection_data.dart';
import 'package:photo/data/remote/collection_repository.dart';
import 'package:photo/redux/collection/collection_actions.dart';
import 'package:photo/data/model/page_data.dart';

List<Middleware<AppState>> createCollectionMiddleware([
  CollectionRepository _repository = const CollectionRepository(),
]) {
  final getCollection = _createGetCollection(_repository);
  final getCollections = _createGetCollections(_repository);
  final createCollection = _createCreateCollection(_repository);
  final updateCollection = _createUpdateCollection(_repository);
  final deleteCollection = _createDeleteCollection(_repository);

  return [
    TypedMiddleware<AppState, GetCollectionAction>(getCollection),
    TypedMiddleware<AppState, GetCollectionsAction>(getCollections),
    TypedMiddleware<AppState, CreateCollectionAction>(createCollection),
    TypedMiddleware<AppState, UpdateCollectionAction>(updateCollection),
    TypedMiddleware<AppState, DeleteCollectionAction>(deleteCollection),
  ];
}

Middleware<AppState> _createGetCollection(CollectionRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action.id == null) {
      idEmpty(next, action);
    } else {
      running(next, action);
      repository.getCollection(action.id).then((item) {
        next(SyncCollectionAction(collection: item));
        completed(next, action);
      }).catchError((error) {
        catchError(next, action, error);
      });
    }
  };
}

Middleware<AppState> _createGetCollections(CollectionRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    int num = store.state.photoState.page.next;
    if (action.isRefresh) {
      num = 1;
    } else {
      if (store.state.photoState.page.next <= 0) {
        noMoreItem(next, action);
        return;
      }
    }
    repository.getCollectionsList(num, 30).then((page) {
      next(SyncCollectionsAction(page: page, collections: page.data));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
//    repositoryDB
//        .getCollectionsList(
//            "id",
//            store.state.collectionState.page.pageSize,
//            store.state.collectionState.page.pageSize *
//                store.state.collectionState.page.currPage)
//        .then((map) {
//      if (map.isNotEmpty) {
//        var page = Page(currPage: store.state.collectionState.page.currPage + 1);
//        next(SyncCollectionsAction(page: page, collections: map));
//        completed(next, action);
//      }
//    }).catchError((error) {
//      catchError(next, action, error);
//    });
  };
}

Middleware<AppState> _createCreateCollection(CollectionRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.createCollection(action.collection).then((item) {
      next(SyncCollectionAction(collection: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createUpdateCollection(CollectionRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.updateCollection(action.collection).then((item) {
      next(SyncCollectionAction(collection: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createDeleteCollection(CollectionRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.deleteCollection(action.collection.id).then((item) {
      next(RemoveCollectionAction(id: action.collection.id));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

void catchError(NextDispatcher next, action, error) {
  next(CollectionStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "${action.actionName} is error;${error.toString()}")));
}

void completed(NextDispatcher next, action) {
  next(CollectionStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "${action.actionName} is completed")));
}

void noMoreItem(NextDispatcher next, action) {
  next(CollectionStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "no more items")));
}

void running(NextDispatcher next, action) {
  next(CollectionStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.running,
          msg: "${action.actionName} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(CollectionStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "Id is empty")));
}
