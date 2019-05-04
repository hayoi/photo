import 'package:flutter/widgets.dart';
import 'package:photo/data/model/page_data.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:redux/redux.dart';
import 'package:photo/redux/photo/photo_actions.dart';
import 'package:photo/redux/photo/photo_state.dart';

final photoReducer = combineReducers<PhotoState>([
  TypedReducer<PhotoState, PhotoStatusAction>(_photoStatus),
  TypedReducer<PhotoState, SyncPhotosAction>(_syncPhotos),
  TypedReducer<PhotoState, SyncCollectionPhotosAction>(_syncCollectionPhotos),
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
    state.photos
        .update(photo.id.toString(), (v) => photo, ifAbsent: () => photo);
  }
  state.page.last = action.page.last;
  state.page.prev = action.page.prev;
  state.page.first = action.page.first;
  state.page.next = action.page.next;
  return state.copyWith(photos: state.photos);
}

PhotoState _syncCollectionPhotos(
    PhotoState state, SyncCollectionPhotosAction action) {
  state.collectionPhotos.update(action.collectionId, (v) {
    v.id = action.collectionId;
    v.page?.last = action.page?.last;
    v.page?.prev = action.page?.prev;
    v.page?.first = action.page?.first;
    v.page?.next = action.page?.next;
    for (var photo in action.page?.data) {
      v.photos
          ?.update(photo.id.toString(), (vl) => photo, ifAbsent: () => photo);
    }
    return v;
  }, ifAbsent: () {
    PhotoOfCollection pc = new PhotoOfCollection();
    pc.id = action.collectionId;
    Page page = Page();
    page.last = action.page?.last;
    page.prev = action.page?.prev;
    page.first = action.page?.first;
    page.next = action.page?.next;
    pc.page = page;
    pc.photos = Map();
    for (var photo in action.page?.data) {
      pc.photos
          ?.update(photo.id.toString(), (v) => photo, ifAbsent: () => photo);
    }
    return pc;
  });
  return state.copyWith(collectionPhotos: state.collectionPhotos);
}

PhotoState _syncPhoto(PhotoState state, SyncPhotoAction action) {
  state.photos.update(action.photo.id.toString(), (u) => action.photo,
      ifAbsent: () => action.photo);
  return state.copyWith(photos: state.photos, photo: action.photo);
}

PhotoState _removePhoto(PhotoState state, RemovePhotoAction action) {
  return state.copyWith(photos: state.photos..remove(action.id.toString()));
}
