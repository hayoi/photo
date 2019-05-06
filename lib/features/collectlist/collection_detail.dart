import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo/features/collection/collection_view.dart';

class CollectionDetailView extends StatelessWidget {
  final int collectionId;

  const CollectionDetailView({Key key, this.collectionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("CollectionDetailView"),
        ),
        body: CollectionView(collection: collectionId));
  }
}
