import 'package:redux/redux.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/redux/user/user_actions.dart';
import 'package:photo/data/model/user_data.dart';
import 'package:photo/data/remote/user_repository.dart';
import 'package:photo/redux/user/user_actions.dart';
import 'package:photo/data/model/page_data.dart';

List<Middleware<AppState>> createUserMiddleware([
  UserRepository _repository = const UserRepository(),
]) {
  final login = _createLogin(_repository);
  final getMe = _createGetMe(_repository);
  final getUser = _createGetUser(_repository);
  final getUsers = _createGetUsers(_repository);
  final createUser = _createCreateUser(_repository);
  final updateUser = _createUpdateUser(_repository);
  final deleteUser = _createDeleteUser(_repository);

  return [
    TypedMiddleware<AppState, UserLoginAction>(login),
    TypedMiddleware<AppState, GetMeAction>(getMe),
    TypedMiddleware<AppState, GetUserAction>(getUser),
    TypedMiddleware<AppState, GetUsersAction>(getUsers),
    TypedMiddleware<AppState, CreateUserAction>(createUser),
    TypedMiddleware<AppState, UpdateUserAction>(updateUser),
    TypedMiddleware<AppState, DeleteUserAction>(deleteUser),
  ];
}

Middleware<AppState> _createLogin(
    UserRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.login(action.l).then((item) {
      next(SyncUserAction(user: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createGetMe(
    UserRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
      running(next, action);
      repository.getMe().then((item) {
        next(SyncProfileAction(profile: item));
        completed(next, action);
      }).catchError((error) {
        catchError(next, action, error);
      });
  };
}

Middleware<AppState> _createGetUser(
    UserRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action.id == null) {
      idEmpty(next, action);
    } else {
      running(next, action);
      repository.getUser(action.id).then((item) {
        next(SyncUserAction(user: item));
        completed(next, action);
      }).catchError((error) {
        catchError(next, action, error);
      });
    }
  };
}

Middleware<AppState> _createGetUsers(
    UserRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    if (action.isRefresh) {
      store.state.userState.page.last = 1;
      store.state.userState.users.clear();
    } else {
      var p = ++store.state.userState.page.last;
      if (p > ++store.state.userState.page.next) {
        noMoreItem(next, action);
        return;
      }
    }
    repository
        .getUsersList(
            "sorting",
            store.state.userState.page.last,
            store.state.userState.page.prev)
        .then((map) {
      if (map.isNotEmpty) {
        var page = Page(
            last: map["currPage"],
            next: map["totalPage"],
            first: map["totalCount"]);
        var l = map["list"] ?? List();
        List<User> list =
            l.map<User>((item) => new User.fromJson(item)).toList();
        next(SyncUsersAction(page: page, users: list));
      }
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
//    repositoryDB
//        .getUsersList(
//            "id",
//            store.state.userState.page.pageSize,
//            store.state.userState.page.pageSize *
//                store.state.userState.page.currPage)
//        .then((map) {
//      if (map.isNotEmpty) {
//        var page = Page(currPage: store.state.userState.page.currPage + 1);
//        next(SyncUsersAction(page: page, users: map));
//        completed(next, action);
//      }
//    }).catchError((error) {
//      catchError(next, action, error);
//    });
  };
}

Middleware<AppState> _createCreateUser(
    UserRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.createUser(action.user).then((item) {
      next(SyncUserAction(user: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createUpdateUser(
    UserRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.updateUser(action.user).then((item) {
      next(SyncUserAction(user: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createDeleteUser(
    UserRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.deleteUser(action.user.id).then((item) {
      next(RemoveUserAction(id: action.user.id));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

void catchError(NextDispatcher next, action, error) {
  next(UserStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "${action.actionName} is error;${error.toString()}")));
}

void completed(NextDispatcher next, action) {
  next(UserStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "${action.actionName} is completed")));
}

void noMoreItem(NextDispatcher next, action) {
  next(UserStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "no more items")));
}

void running(NextDispatcher next, action) {
  next(UserStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.running,
          msg: "${action.actionName} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(UserStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "Id is empty")));
}
