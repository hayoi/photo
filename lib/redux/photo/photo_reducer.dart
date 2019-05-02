import 'package:redux/redux.dart';
import 'package:photo/redux/photo/photo_actions.dart';
import 'package:photo/redux/photo/photo_state.dart';

final photoReducer = combineReducers<PhotoState>([
  TypedReducer<PhotoState, PhotoStatusAction>(_photoStatus),
  TypedReducer<PhotoState, SyncPhotosAction>(_syncPhotos),
  TypedReducer<PhotoState, SyncPhotoAction>(_syncPhoto),
  TypedReducer<PhotoState, RemovePhotoAction>(_removePhoto),
]);

PhotoState _photoStatus(PhotoState state, PhotoStatusAction action) {
  var status = state.status ?? Map();
  status.update(action.report.actionName, (v) => action.report,
      ifAbsent: () => action.report);
  return state.copyWith(status: status);
}

PhotoState _syncPhotos(PhotoState state, SyncPhotosAction action) {
  for (var photo in action.photos) {
    state.photos.update(photo.id.toString(), (v) => photo, ifAbsent: () => photo);
  }
  state.page.currPage = action.page.currPage;
  state.page.pageSize = action.page.pageSize;
  state.page.totalCount = action.page.totalCount;
  state.page.totalPage = action.page.totalPage;
  return state.copyWith(photos: state.photos);
}

PhotoState _syncPhoto(PhotoState state, SyncPhotoAction action) {
  state.photos.update(action.photo.id.toString(), (u) => action.photo,
      ifAbsent: () => action.photo);
  return state.copyWith(photos: state.photos, photo: action.photo);
}

PhotoState _removePhoto(PhotoState state, RemovePhotoAction action) {
  return state.copyWith(photos: state.photos..remove(action.id.toString()));
}
