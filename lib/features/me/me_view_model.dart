import 'package:redux/redux.dart';
import 'package:photo/data/model/user_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/user/user_actions.dart';

class MeViewModel {
  final User user;
  final Function() getUser;
  final ActionReport getUserReport;

  MeViewModel({
    this.user,
    this.getUser,
    this.getUserReport,
  });

  static MeViewModel fromStore(Store<AppState> store) {
    return MeViewModel(
      user: store.state.userState.user,
      getUser: () {
        store.dispatch(GetUserAction());
      },
      getUserReport: store.state.userState.status["GetUserAction"],
    );
  }
}
