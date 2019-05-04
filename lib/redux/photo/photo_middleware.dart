import 'package:redux/redux.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/photo/photo_actions.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:photo/data/remote/photo_repository.dart';
import 'package:photo/redux/photo/photo_actions.dart';
import 'package:photo/data/model/page_data.dart';

List<Middleware<AppState>> createPhotoMiddleware([
  PhotoRepository _repository = const PhotoRepository(),
]) {
  final getPhoto = _createGetPhoto(_repository);
  final getPhotos = _createGetPhotos(_repository);
  final getCollectionPhotos = _createGetCollectionPhotos(_repository);
  final createPhoto = _createCreatePhoto(_repository);
  final updatePhoto = _createUpdatePhoto(_repository);
  final deletePhoto = _createDeletePhoto(_repository);

  return [
    TypedMiddleware<AppState, GetPhotoAction>(getPhoto),
    TypedMiddleware<AppState, GetPhotosAction>(getPhotos),
    TypedMiddleware<AppState, GetCollectionPhotosAction>(getCollectionPhotos),
    TypedMiddleware<AppState, CreatePhotoAction>(createPhoto),
    TypedMiddleware<AppState, UpdatePhotoAction>(updatePhoto),
    TypedMiddleware<AppState, DeletePhotoAction>(deletePhoto),
  ];
}

Middleware<AppState> _createGetPhoto(PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action.id == null) {
      idEmpty(next, action);
    } else {
      running(next, action);
      repository.getPhoto(action.id).then((item) {
        next(SyncPhotoAction(photo: item));
        completed(next, action);
      }).catchError((error) {
        catchError(next, action, error);
      });
    }
  };
}

Middleware<AppState> _createGetPhotos(PhotoRepository repository) {
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
    repository.getPhotosList(action.orderBy, num, 10).then((page) {
      next(SyncPhotosAction(page: page, photos: page.data));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
//    repositoryDB
//        .getPhotosList(
//            "id",
//            store.state.photoState.page.pageSize,
//            store.state.photoState.page.pageSize *
//                store.state.photoState.page.currPage)
//        .then((map) {
//      if (map.isNotEmpty) {
//        var page = Page(currPage: store.state.photoState.page.currPage + 1);
//        next(SyncPhotosAction(page: page, photos: map));
//        completed(next, action);
//      }
//    }).catchError((error) {
//      catchError(next, action, error);
//    });
  };
}

Middleware<AppState> _createGetCollectionPhotos(PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    int num =
        store.state.photoState.collectionPhotos[action.id]?.page?.next ?? 1;
    if (action.isRefresh) {
      num = 1;
    } else {
      if (store.state.photoState.collectionPhotos[action.id] != null &&
          store.state.photoState.collectionPhotos[action.id].page.next <= 0) {
        noMoreItem(next, action);
        return;
      }
    }
    repository.getCollectionPhotos(action.id, num, 10).then((page) {
      next(SyncCollectionPhotosAction(collectionId: action.id, page: page));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createCreatePhoto(PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.createPhoto(action.photo).then((item) {
      next(SyncPhotoAction(photo: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createUpdatePhoto(PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.updatePhoto(action.photo).then((item) {
      next(SyncPhotoAction(photo: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createDeletePhoto(PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.deletePhoto(action.photo.id).then((item) {
      next(RemovePhotoAction(id: action.photo.id));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

void catchError(NextDispatcher next, action, error) {
  next(PhotoStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "${action.actionName} is error;${error.toString()}")));
}

void completed(NextDispatcher next, action) {
  next(PhotoStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "${action.actionName} is completed")));
}

void noMoreItem(NextDispatcher next, action) {
  next(PhotoStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "no more items")));
}

void running(NextDispatcher next, action) {
  next(PhotoStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.running,
          msg: "${action.actionName} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(PhotoStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "Id is empty")));
}
