import 'dart:async';
import 'package:dio/dio.dart';
import 'package:photo/data/model/collection_data.dart';
import 'package:photo/data/model/page_data.dart';
import 'package:photo/data/network_common.dart';

class CollectionRepository {
  const CollectionRepository();

  Future<Page> getCollectionsList(int page, int limit) {
    return new NetworkCommon().dio.get("collections/featured",
        queryParameters: {"page": page, "per_page": limit}).then((d) {
      var results = new NetworkCommon().decodeResp(d);
      Page page = new NetworkCommon().decodePage(d);
      page.data = results
          .map<Collection>((item) => new Collection.fromJson(item))
          .toList();
      return page;
    });
  }

  Future<Collection> createCollection(Collection collection) {
    var dio = new NetworkCommon().dio;
    dio.options.headers.putIfAbsent("Accept", () {
      return "application/json";
    });
    return dio.post("collection/", data: collection).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new Collection.fromJson(results);
    });
  }

  Future<Collection> updateCollection(Collection collection) {
    var dio = new NetworkCommon().dio;
    dio.options.headers.putIfAbsent("Accept", () {
      return "application/json";
    });
    return dio.put("collection/", data: collection).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new Collection.fromJson(results);
    });
  }

  Future<int> deleteCollection(int id) {
    return new NetworkCommon()
        .dio
        .delete("collection/", queryParameters: {"id": id}).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return 0;
    });
  }

  Future<Collection> getCollection(int id) {
    return new NetworkCommon()
        .dio
        .get("collection/", queryParameters: {"id": id}).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new Collection.fromJson(results);
    });
  }
}
