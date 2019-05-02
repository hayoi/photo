import 'package:meta/meta.dart';
import 'package:photo/data/model/user_data.dart';
import 'package:photo/data/model/page_data.dart';
import 'package:photo/redux/action_report.dart';

class UserState {
  final User profile;
  final Map<String, User> users;
  final User user;
  final Map<String, ActionReport> status;
  final Page page;

  UserState({
    @required this.profile,
    @required this.users,
    @required this.user,
    @required this.status,
    @required this.page,
  });

  UserState copyWith({
    User profile,
    Map<String, User> users,
    User user,
    Map<String, ActionReport> status,
    Page page,
  }) {
    return UserState(
      profile: profile ?? this.profile,
      users: users ?? this.users ?? Map(),
      user: user ?? this.user,
      status: status ?? this.status,
      page: page ?? this.page,
    );
  }
}
