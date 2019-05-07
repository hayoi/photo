import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:photo/features/viewphoto/viewphoto_view.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/features/collection/collection_view_model.dart';
import 'package:photo/redux/action_report.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CollectionView extends StatelessWidget {
  final int collection;

  CollectionView({Key key, this.collection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CollectionViewModel>(
      distinct: true,
      converter: (store) => CollectionViewModel.fromStore(store, collection),
      builder: (_, viewModel) => CollectionViewContent(
            viewModel: viewModel,
            collection: collection,
          ),
    );
  }
}

class CollectionViewContent extends StatefulWidget {
  final int collection;
  final CollectionViewModel viewModel;

  CollectionViewContent({Key key, this.viewModel, this.collection})
      : super(key: key);

  @override
  _CollectionViewContentState createState() => _CollectionViewContentState();
}

class _CollectionViewContentState extends State<CollectionViewContent> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TrackingScrollController _scrollController = TrackingScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (this.widget.viewModel.photos.length == 0) {
      this.widget.viewModel.getPhotoOfCollection(true);
    }
  }

  @override
  void didUpdateWidget(CollectionViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {});
  }

  void showError(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var widget;

    widget = NotificationListener(
        onNotification: _onNotification,
        child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: new StaggeredGridView.countBuilder(
              controller: _scrollController,
              crossAxisCount: 2,
              itemCount: this.widget.viewModel.photos.length + 1,
              itemBuilder: (_, int index) => _createItem(context, index),
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
            )));
    return Scaffold(
      key: _scaffoldKey,
      body: widget,
    );
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (_scrollController.mostRecentlyUpdatedPosition.maxScrollExtent >
              _scrollController.offset &&
          _scrollController.mostRecentlyUpdatedPosition.maxScrollExtent -
                  _scrollController.offset <=
              50) {
        // load more
        if (this.widget.viewModel.getPhotoOfCollectionReport?.status ==
                ActionStatus.complete ||
            this.widget.viewModel.getPhotoOfCollectionReport?.status ==
                ActionStatus.error) {
          // have next page
          _loadMoreData();
          setState(() {});
        } else {}
      }
    }

    return true;
  }

  Future<Null> _loadMoreData() {
    widget.viewModel.getPhotoOfCollection(false);
    return null;
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState.show();
    widget.viewModel.getPhotoOfCollection(true);
    return null;
  }

  _createItem(BuildContext context, int index) {
    if (index < this.widget.viewModel.photos?.length) {
      return Container(
          padding: EdgeInsets.all(2.0),
          child: Stack(
            children: <Widget>[
              Hero(
                tag: this.widget.viewModel.photos[index].id,
                child: InkWell(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPhotoView(
                              id: this.widget.collection, pageIndex: index),
                        ),
                      ),
                  child: new CachedNetworkImage(
                    imageUrl: this.widget.viewModel.photos[index].urls.small,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor))));
    }

    return Container(
      height: 44.0,
      child: Center(
        child: _getLoadMoreWidget(),
      ),
    );
  }

  Widget _getLoadMoreWidget() {
    if (this.widget.viewModel.getPhotoOfCollectionReport?.status ==
        ActionStatus.running) {
      return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: CircularProgressIndicator());
    } else {
      return SizedBox();
    }
  }
}

class _PhotoListItem extends Column {
  _PhotoListItem({Photo photo, GestureTapCallback onTap});
}
