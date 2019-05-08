import 'package:redux/redux.dart';
import 'package:photo/data/model/user_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/user/user_actions.dart';

class MeViewModel {
  final User profile;
  final Function() getMe;
  final ActionReport getProfileReport;

  MeViewModel({
    this.profile,
    this.getMe,
    this.getProfileReport,
  });

  static MeViewModel fromStore(Store<AppState> store) {
    return MeViewModel(
      profile: store.state.userState.profile,
      getMe: () {
        store.dispatch(GetMeAction());
      },
      getProfileReport: store.state.userState.status["GetMeAction"],
    );
  }
}
