import 'package:redux/redux.dart';
import 'package:photo/data/model/user_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/user/user_actions.dart';

class HomeViewModel {
  final User user;

  HomeViewModel({
    this.user,
  });

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel(
      user: store.state.userState.user,
    );
  }
}
