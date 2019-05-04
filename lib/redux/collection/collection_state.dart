import 'package:meta/meta.dart';
import 'package:photo/data/model/collection_data.dart';
import 'package:photo/data/model/page_data.dart';
import 'package:photo/redux/action_report.dart';

class CollectionState {
  final Map<String, Collection> collections;
  final Collection collection;
  final Map<String, ActionReport> status;
  final Page page;

  CollectionState({
    @required this.collections,
    @required this.collection,
    @required this.status,
    @required this.page,
  });

  CollectionState copyWith({
    Map<String, Collection> collections,
    Collection collection,
    Map<String, ActionReport> status,
    Page page,
  }) {
    return CollectionState(
      collections: collections ?? this.collections ?? Map(),
      collection: collection ?? this.collection,
      status: status ?? this.status,
      page: page ?? this.page,
    );
  }
}
