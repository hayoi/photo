import 'package:meta/meta.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/data/model/page_data.dart';

class GetPhotosAction {
  final String actionName = "GetPhotosAction";
  final bool isRefresh;
  final String orderBy;

  GetPhotosAction({this.orderBy, this.isRefresh});
}

class GetCollectionPhotosAction {
  final String actionName = "GetCollectionPhotosAction";
  final bool isRefresh;
  final int id;

  GetCollectionPhotosAction({this.id, this.isRefresh});
}
class SyncCollectionPhotosAction {
  final String actionName = "SyncCollectionPhotosAction";
  final Page page;
  final int collectionId;

  SyncCollectionPhotosAction({this.collectionId, this.page});
}

class GetPhotoAction {
  final String actionName = "GetPhotoAction";
  final String id;

  GetPhotoAction({@required this.id});
}

class PhotoStatusAction {
  final String actionName = "PhotoStatusAction";
  final ActionReport report;

  PhotoStatusAction({@required this.report});
}

class SyncPhotosAction {
  final String actionName = "SyncPhotosAction";
  final Page page;
  final List<Photo> photos;

  SyncPhotosAction({this.page, this.photos});
}

class SyncPhotoAction {
  final String actionName = "SyncPhotoAction";
  final Photo photo;

  SyncPhotoAction({@required this.photo});
}

class CreatePhotoAction {
  final String actionName = "CreatePhotoAction";
  final Photo photo;

  CreatePhotoAction({@required this.photo});
}

class UpdatePhotoAction {
  final String actionName = "UpdatePhotoAction";
  final Photo photo;

  UpdatePhotoAction({@required this.photo});
}

class DeletePhotoAction {
  final String actionName = "DeletePhotoAction";
  final Photo photo;

  DeletePhotoAction({@required this.photo});
}

class RemovePhotoAction {
  final String actionName = "RemovePhotoAction";
  final String id;

  RemovePhotoAction({@required this.id});
}

