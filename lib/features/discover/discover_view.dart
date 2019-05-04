import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo/data/model/collection_data.dart';
import 'package:photo/data/model/choice_data.dart';
import 'package:photo/features/collection/collection_view.dart';
import 'package:photo/features/photo/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo/trans/translations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/features/discover/discover_view_model.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/utils/progress_dialog.dart';
import 'package:photo/features/widget/swipe_list_item.dart';

class DiscoverView extends StatelessWidget {
  DiscoverView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DiscoverViewModel>(
      distinct: true,
      converter: (store) => DiscoverViewModel.fromStore(store),
      builder: (_, viewModel) => DiscoverViewContent(
            viewModel: viewModel,
          ),
    );
  }
}

class DiscoverViewContent extends StatefulWidget {
  final DiscoverViewModel viewModel;

  DiscoverViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _DiscoverViewContentState createState() => _DiscoverViewContentState();
}

class _DiscoverViewContentState extends State<DiscoverViewContent>
    with SingleTickerProviderStateMixin {
  final _SearchDemoSearchDelegate _delegate = _SearchDemoSearchDelegate();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//  TabController _controller;
  var cpr;
  var upr;
  var dpr;

  @override
  void initState() {
    super.initState();
//    _controller = TabController(
//        vsync: this, length: this.widget.viewModel.collections.length + 1);
    if (this.widget.viewModel.collections.length == 0) {
      this.widget.viewModel.getCollections(true);
    }
  }

  @override
  void dispose() {
//    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DiscoverViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
      if (this.widget.viewModel.createCollectionReport?.status ==
          ActionStatus.running) {
        if (cpr == null) {
          cpr = new ProgressDialog(context);
        }
        cpr.setMessage("Creating...");
        cpr.show();
      } else {
        if (cpr != null && cpr.isShowing()) {
          cpr.hide();
          cpr = null;
        }
      }

      if (this.widget.viewModel.updateCollectionReport?.status ==
          ActionStatus.running) {
        if (upr == null) {
          upr = new ProgressDialog(context);
        }
        upr.setMessage("Updating...");
        upr.show();
      } else {
        if (upr != null && upr.isShowing()) {
          upr.hide();
          upr = null;
        }
      }

      if (this.widget.viewModel.deleteCollectionReport?.status ==
          ActionStatus.running) {
        if (dpr == null) {
          dpr = new ProgressDialog(context);
        }
        dpr.setMessage("Deleting...");
        dpr.show();
      } else {
        if (dpr != null && dpr.isShowing()) {
          dpr.hide();
          dpr = null;
        }
      }
    });
  }

  void showError(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  List<Widget> getTabPPage() {
    List<Widget> list = [];
    for (var c in this.widget.viewModel.collections) {
      list.add(CollectionView(
        collection: c.id,
      ));
    }

    return list;
  }

  List<Tab> getTab() {
    List<Tab> list = [];
    for (var c in this.widget.viewModel.collections) {
      list.add(Tab(icon: Text(c.title ?? "")));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    var widget;

    widget = TabBarView(
//      controller: _controller,
      children: [
        PhotoView(orderBy: "latest"),
      ]..addAll(getTabPPage()),
    );
    return DefaultTabController(
      length: this.widget.viewModel.collections.length + 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
//            controller: _controller,
            isScrollable: true,
            tabs: [
              Tab(icon: Text("latest")),
            ]..addAll(getTab()),
          ),
          title: Text("Discover"),
          actions: _buildActionButton(),
        ),
        body: widget,
      ),
    );
  }

  List<Widget> _buildActionButton() {
    return <Widget>[
      IconButton(
        icon: Icon(choices[0].icon),
        onPressed: () async {
          final int selected = await showSearch<int>(
            context: context,
            delegate: _delegate,
          );
          if (selected != null) {
            setState(() {
              showError("you select $selected");
            });
          }
        },
      ),
    ];
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {});
  }
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Search', icon: Icons.search),
];

class _SearchDemoSearchDelegate extends SearchDelegate<int> {
  final List<int> _data =
      List<int>.generate(100001, (int i) => i).reversed.toList();
  final List<int> _history = <int>[42607, 85604, 66374, 44, 174];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<int> suggestions = query.isEmpty
        ? _history
        : _data.where((int i) => '$i'.startsWith(query));

    return _SuggestionList(
      query: query,
      suggestions: suggestions.map((int i) => '$i').toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final int searched = int.tryParse(query);
    if (searched == null || !_data.contains(searched)) {
      return Center(
        child: Text(
          '"$query"\n is not a valid integer between 0 and 100,000.\nTry again.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      children: <Widget>[
        _ResultCard(
          title: 'This integer',
          integer: searched,
          searchDelegate: this,
        ),
        _ResultCard(
          title: 'Next integer',
          integer: searched + 1,
          searchDelegate: this,
        ),
        _ResultCard(
          title: 'Previous integer',
          integer: searched - 1,
          searchDelegate: this,
        ),
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
    ];
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({this.integer, this.title, this.searchDelegate});

  final int integer;
  final String title;
  final SearchDelegate<int> searchDelegate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        searchDelegate.close(context, integer);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(title),
              Text(
                '$integer',
                style: theme.textTheme.headline.copyWith(fontSize: 72.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style:
                  theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
