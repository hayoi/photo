import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo/data/model/photo_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo/trans/translations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/features/viewphoto/viewphoto_view_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewPhotoView extends StatelessWidget {
  final int id; //collection id
  final int pageIndex; //the index of photo in the list

  ViewPhotoView({Key key, this.id, this.pageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewPhotoViewModel>(
      distinct: true,
      converter: (store) => ViewPhotoViewModel.fromStore(store, id),
      builder: (_, viewModel) => ViewPhotoViewContent(
            viewModel: viewModel,
            pageIndex: pageIndex,
          ),
    );
  }
}

class ViewPhotoViewContent extends StatefulWidget {
  final ViewPhotoViewModel viewModel;
  final int pageIndex;

  ViewPhotoViewContent({Key key, this.viewModel, this.pageIndex})
      : super(key: key);

  @override
  _ViewPhotoViewContentState createState() => _ViewPhotoViewContentState();
}

class _ViewPhotoViewContentState extends State<ViewPhotoViewContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _pc;

  @override
  void initState() {
    super.initState();
    _pc = new PageController(initialPage: this.widget.pageIndex ?? 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pc.dispose();
  }

  @override
  void didUpdateWidget(ViewPhotoViewContent oldWidget) {
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

    widget = Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(
              this.widget.viewModel.photos[index].urls.small),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          heroTag: this.widget.viewModel.photos[this.widget.pageIndex ?? 0].id,
        );
      },
      itemCount: this.widget.viewModel.photos.length,
      loadingChild: new CircularProgressIndicator(),
      pageController: _pc,
    ));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(" "),
      ),
      body: widget,
    );
  }
}
