import 'package:meta/meta.dart';
import 'package:photo/data/model/collection_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/data/model/page_data.dart';

class GetCollectionsAction {
  final String actionName = "GetCollectionsAction";
  final bool isRefresh;

  GetCollectionsAction({this.isRefresh});
}

class GetCollectionAction {
  final String actionName = "GetCollectionAction";
  final int id;

  GetCollectionAction({@required this.id});
}

class CollectionStatusAction {
  final String actionName = "CollectionStatusAction";
  final ActionReport report;

  CollectionStatusAction({@required this.report});
}

class SyncCollectionsAction {
  final String actionName = "SyncCollectionsAction";
  final Page page;
  final List<Collection> collections;

  SyncCollectionsAction({this.page, this.collections});
}

class SyncCollectionAction {
  final String actionName = "SyncCollectionAction";
  final Collection collection;

  SyncCollectionAction({@required this.collection});
}

class CreateCollectionAction {
  final String actionName = "CreateCollectionAction";
  final Collection collection;

  CreateCollectionAction({@required this.collection});
}

class UpdateCollectionAction {
  final String actionName = "UpdateCollectionAction";
  final Collection collection;

  UpdateCollectionAction({@required this.collection});
}

class DeleteCollectionAction {
  final String actionName = "DeleteCollectionAction";
  final Collection collection;

  DeleteCollectionAction({@required this.collection});
}

class RemoveCollectionAction {
  final String actionName = "RemoveCollectionAction";
  final int id;

  RemoveCollectionAction({@required this.id});
}

