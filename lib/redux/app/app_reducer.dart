import 'package:photo/redux/photo/photo_reducer.dart';
import 'package:photo/redux/user/user_reducer.dart';
import 'package:photo/redux/app/app_state.dart';

///register all the Reducer here
///auto add new reducer when using haystack plugin
AppState appReducer(AppState state, dynamic action) {
  return new AppState(
    photoState: photoReducer(state.photoState, action),
    userState: userReducer(state.userState, action),

  );
}
