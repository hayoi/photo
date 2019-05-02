import 'package:meta/meta.dart';
import 'package:photo/data/model/user_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/data/model/page_data.dart';

class GetUsersAction {
  final String actionName = "GetUsersAction";
  final bool isRefresh;

  GetUsersAction({this.isRefresh});
}

class GetUserAction {
  final String actionName = "GetUserAction";
  final String id;

  GetUserAction({@required this.id});
}

class UserStatusAction {
  final String actionName = "UserStatusAction";
  final ActionReport report;

  UserStatusAction({@required this.report});
}

class SyncUsersAction {
  final String actionName = "SyncUsersAction";
  final Page page;
  final List<User> users;

  SyncUsersAction({this.page, this.users});
}

class SyncUserAction {
  final String actionName = "SyncUserAction";
  final User user;

  SyncUserAction({@required this.user});
}

class SyncProfileAction {
  final String actionName = "SyncProfileAction";
  final User profile;

  SyncProfileAction({@required this.profile});
}

class CreateUserAction {
  final String actionName = "CreateUserAction";
  final User user;

  CreateUserAction({@required this.user});
}

class UpdateUserAction {
  final String actionName = "UpdateUserAction";
  final User user;

  UpdateUserAction({@required this.user});
}

class DeleteUserAction {
  final String actionName = "DeleteUserAction";
  final User user;

  DeleteUserAction({@required this.user});
}

class RemoveUserAction {
  final String actionName = "RemoveUserAction";
  final String id;

  RemoveUserAction({@required this.id});
}

class UserLoginAction {
  final String actionName = "UserLoginAction";
  final Login l;

  UserLoginAction({@required this.l});
}
