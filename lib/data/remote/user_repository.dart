import 'dart:async';
import 'package:dio/dio.dart';
import 'package:photo/data/model/user_data.dart';
import 'package:photo/data/network_common.dart';

class UserRepository {
  const UserRepository();

  Future<Map> getUsersList(String sorting, int page, int limit) {
    return new NetworkCommon().dio.get("user/", queryParameters: {
      "sorting": sorting,
      "page": page,
      "limit": limit
    }).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return results;
    });
  }

  Future<User> createUser(User user) {
    var dio = new NetworkCommon().dio;
    dio.options.headers.putIfAbsent("Accept", () {
      return "application/json";
    });
    return dio.post("user/", data: user).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new User.fromJson(results);
    });
  }

  Future<User> updateUser(User user) {
    var dio = new NetworkCommon().dio;
    dio.options.headers.putIfAbsent("Accept", () {
      return "application/json";
    });
    return dio.put("user/", data: user).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new User.fromJson(results);
    });
  }

  Future<int> deleteUser(String id) {
    return new NetworkCommon().dio.delete("user/", queryParameters: {"id": id}).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return 0;
    });
  }
  Future<User> getMe() {
    return new NetworkCommon().dio.get("me").then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new User.fromJson(results);
    });
  }
  Future<User> getUser(String id) {
    return new NetworkCommon().dio.get("user/", queryParameters: {"id": id}).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new User.fromJson(results);
    });
  }

  Future<User> login(Login login) {
    var dio = new NetworkCommon().dio;
    dio.options.headers.putIfAbsent("Accept", () {
      return "application/json";
    });
    return dio.post("login/", data: login.toJson()).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new User.fromJson(results["user"]);
    });
  }
}
