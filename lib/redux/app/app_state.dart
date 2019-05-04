import 'package:photo/redux/collection/collection_state.dart';
import 'package:photo/redux/photo/photo_state.dart';
import 'package:photo/redux/user/user_state.dart';
import 'package:meta/meta.dart';
import 'package:photo/data/model/page_data.dart';

/// manage all state of this project
/// auto add new state when using haystack plugin
/// configure the initialize of state
class AppState {
  final CollectionState collectionState;
  final PhotoState photoState;
  final UserState userState;

  AppState({
    @required this.collectionState,
    @required this.photoState,
    @required this.userState,

  });

  factory AppState.initial() {
    return AppState(
        collectionState: CollectionState(
            collection: null,
            collections: Map(),
            status: Map(),
            page: Page(),),
        photoState: PhotoState(
            photo: null,
            photos: Map(),
            status: Map(),
            collectionPhotos: Map(),
            page: Page(),),
        userState: UserState(
            user: null,
            users: Map(),
            status: Map(),
            page: Page(),),

    );
  }
}
