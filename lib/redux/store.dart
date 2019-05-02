import 'package:photo/redux/photo/photo_middleware.dart';
import 'package:photo/redux/user/user_middleware.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/app/app_reducer.dart';

Future<Store<AppState>> createStore() async {
  return Store(
    appReducer,
    initialState: AppState.initial(),
    middleware: []
      ..addAll(createPhotoMiddleware())
      ..addAll(createUserMiddleware())
      ..addAll([
        LoggingMiddleware<dynamic>.printer(level: Level.ALL),
      ]),
  );
}
