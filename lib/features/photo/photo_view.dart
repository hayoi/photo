import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:photo/features/viewphoto/viewphoto_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo/trans/translations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/features/photo/photo_view_model.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/utils/progress_dialog.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PhotoView extends StatelessWidget {
  final String orderBy;

  PhotoView({Key key, this.orderBy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PhotoViewModel>(
      distinct: true,
      converter: (store) => PhotoViewModel.fromStore(store),
      builder: (_, viewModel) => PhotoViewContent(
            viewModel: viewModel,
            orderBy: orderBy,
          ),
    );
  }
}

class PhotoViewContent extends StatefulWidget {
  final PhotoViewModel viewModel;
  final String orderBy;

  PhotoViewContent({Key key, this.viewModel, this.orderBy}) : super(key: key);

  @override
  _PhotoViewContentState createState() => _PhotoViewContentState();
}

class _PhotoViewContentState extends State<PhotoViewContent> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TrackingScrollController _scrollController = TrackingScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (this.widget.viewModel.photos.length == 0) {
      this.widget.viewModel.getPhotos(true, this.widget.orderBy);
    }
  }

  @override
  void didUpdateWidget(PhotoViewContent oldWidget) {
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
              itemCount: this.widget.viewModel.photos.length,
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
        if (this.widget.viewModel.getPhotosReport?.status ==
                ActionStatus.complete ||
            this.widget.viewModel.getPhotosReport?.status ==
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
    widget.viewModel.getPhotos(false, this.widget.orderBy);
    return null;
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState.show();
    widget.viewModel.getPhotos(true, this.widget.orderBy);
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
                          builder: (context) =>
                              ViewPhotoView(id: 0, pageIndex: index),
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
    if (this.widget.viewModel.getPhotosReport?.status == ActionStatus.running) {
      return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: CircularProgressIndicator());
    } else {
      return SizedBox();
    }
  }
}

class _PhotoListItem extends ListTile {
  _PhotoListItem({Photo photo, GestureTapCallback onTap})
      : super(
            title: Text("Title"),
            subtitle: Text("Subtitle"),
            leading: CircleAvatar(child: Text("T")),
            onTap: onTap);
}
