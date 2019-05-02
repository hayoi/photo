import 'package:redux/redux.dart';
import 'package:photo/data/model/user_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/user/user_actions.dart';

class FollowViewModel {
  final User user;
  final List<User> users;
  final Function(bool) getUsers;
  final ActionReport getUsersReport;
  final Function(User) deleteUser;
  final ActionReport deleteUserReport;

  FollowViewModel({
    this.user,
    this.users,
    this.getUsers,
    this.getUsersReport,
    this.deleteUser,
    this.deleteUserReport,
  });

  static FollowViewModel fromStore(Store<AppState> store) {
    return FollowViewModel(
      user: store.state.userState.user,
      users: store.state.userState.users.values.toList() ?? [],
      getUsers: (isRefresh) {
        store.dispatch(GetUsersAction(isRefresh: isRefresh));
      },
      getUsersReport: store.state.userState.status["GetUsersAction"],
      deleteUser: (user) {
        store.dispatch(DeleteUserAction(user: user));
      },
      deleteUserReport: store.state.userState.status["DeleteUserAction"],
    );
  }
}
