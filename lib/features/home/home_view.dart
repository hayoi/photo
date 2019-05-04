import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo/data/model/user_data.dart';
import 'package:photo/features/discover/discover_view.dart';
import 'package:photo/features/follow/follow_view.dart';
import 'package:photo/features/me/me_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo/trans/translations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/features/home/home_view_model.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/utils/progress_dialog.dart';

class HomeView extends StatelessWidget {
  HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      distinct: true,
      converter: (store) => HomeViewModel.fromStore(store),
      builder: (_, viewModel) => HomeViewContent(
            viewModel: viewModel,
          ),
    );
  }
}

class HomeViewContent extends StatefulWidget {
  final HomeViewModel viewModel;

  HomeViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _HomeViewContentState createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<HomeViewContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController;
  int page = 0;
  List pages = ["Discover", "Follow", "Me"];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: this.page);
  }

  @override
  void didUpdateWidget(HomeViewContent oldWidget) {
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

    widget = PageView(
      children: <Widget>[DiscoverView(), FollowView(), MeView()],
      controller: pageController,
      onPageChanged: onPageChanged,
    );
    return Scaffold(
        key: _scaffoldKey,
        body: widget,
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(pages[0]),
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text(pages[1]),
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              title: Text(pages[2]),
              backgroundColor: Colors.blue)
        ], onTap: onTap, currentIndex: page));
  }

  void onTap(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this.page = page;
    });
  }
}
