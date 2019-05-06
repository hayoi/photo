import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/features/me/me_view_model.dart';

class MeView extends StatelessWidget {
  MeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MeViewModel>(
      distinct: true,
      converter: (store) => MeViewModel.fromStore(store),
      builder: (_, viewModel) => MeViewContent(
            viewModel: viewModel,
          ),
    );
  }
}

class MeViewContent extends StatefulWidget {
  final MeViewModel viewModel;

  MeViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _MeViewContentState createState() => _MeViewContentState();
}

class _MeViewContentState extends State<MeViewContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(MeViewContent oldWidget) {
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

    widget = RaisedButton(
      child: Text("Settings"),
      onPressed: () => Navigator.of(context).pushNamed("/settings"),
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("MeView"),
      ),
      body: widget,
    );
  }
}
