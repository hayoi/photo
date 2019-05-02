import 'package:redux/redux.dart';
import 'package:photo/redux/user/user_actions.dart';
import 'package:photo/redux/user/user_state.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, UserStatusAction>(_userStatus),
  TypedReducer<UserState, SyncUsersAction>(_syncUsers),
  TypedReducer<UserState, SyncUserAction>(_syncUser),
  TypedReducer<UserState, RemoveUserAction>(_removeUser),
]);

UserState _userStatus(UserState state, UserStatusAction action) {
  var status = state.status ?? Map();
  status.update(action.report.actionName, (v) => action.report,
      ifAbsent: () => action.report);
  return state.copyWith(status: status);
}

UserState _syncUsers(UserState state, SyncUsersAction action) {
  for (var user in action.users) {
    state.users.update(user.id.toString(), (v) => user, ifAbsent: () => user);
  }
  state.page.currPage = action.page.currPage;
  state.page.pageSize = action.page.pageSize;
  state.page.totalCount = action.page.totalCount;
  state.page.totalPage = action.page.totalPage;
  return state.copyWith(users: state.users);
}

UserState _syncUser(UserState state, SyncUserAction action) {
  state.users.update(action.user.id.toString(), (u) => action.user,
      ifAbsent: () => action.user);
  return state.copyWith(users: state.users, user: action.user);
}

UserState _syncProfile(UserState state, SyncProfileAction action) {
  return state.copyWith(profile: action.profile);
}

UserState _removeUser(UserState state, RemoveUserAction action) {
  return state.copyWith(users: state.users..remove(action.id.toString()));
}
