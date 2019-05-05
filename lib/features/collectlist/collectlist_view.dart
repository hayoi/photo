import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo/data/model/collection_data.dart';
import 'package:photo/data/model/choice_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo/trans/translations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:photo/redux/app/app_state.dart';
import 'package:photo/features/collectlist/collectlist_view_model.dart';
import 'package:photo/redux/action_report.dart';
import 'package:photo/utils/progress_dialog.dart';

class CollectListView extends StatelessWidget {
  CollectListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CollectListViewModel>(
      distinct: true,
      converter: (store) => CollectListViewModel.fromStore(store),
      builder: (_, viewModel) => CollectListViewContent(
            viewModel: viewModel,
          ),
    );
  }
}

class CollectListViewContent extends StatefulWidget {
  final CollectListViewModel viewModel;

  CollectListViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _CollectListViewContentState createState() => _CollectListViewContentState();
}

class _CollectListViewContentState extends State<CollectListViewContent> {
  final _SearchDemoSearchDelegate _delegate = _SearchDemoSearchDelegate();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TrackingScrollController _scrollController = TrackingScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (this.widget.viewModel.collections.length == 0) {
      this.widget.viewModel.getCollections(true);
    }
  }

  int collectionIndex = -1;

  @override
  void didUpdateWidget(CollectListViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
      if (this.widget.viewModel.getCollectionsReport.status ==
          ActionStatus.complete) {
        if (this.widget.viewModel.collectionPhotos.length > 0) {
          int id = this.widget.viewModel.collectionPhotos[0].id;
          if (this.widget.viewModel.collectionPhotos[id].photos.length == 0) {
            collectionIndex = 0;
            this.widget.viewModel.getPhotoOfCollection(true, id);
          }
        }
      }
      if (this.widget.viewModel.getPhotoOfCollectionReport.status ==
          ActionStatus.complete) {}
    });
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
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: this.widget.viewModel.collections.length + 1,
            itemBuilder: (_, int index) => _createItem(context, index),
          ),
        ));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("CollectListView"),
        actions: _buildActionButton(),
      ),
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
        if (this.widget.viewModel.getCollectionsReport?.status ==
                ActionStatus.complete ||
            this.widget.viewModel.getCollectionsReport?.status ==
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
    widget.viewModel.getCollections(false);
    return null;
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState.show();
    widget.viewModel.getCollections(true);
    return null;
  }

  _createItem(BuildContext context, int index) {
    if (index < this.widget.viewModel.collections?.length) {
      var photo = this
          .widget
          .viewModel
          .collectionPhotos[this.widget.viewModel.collections[index]?.id ?? 0];
      return Container(
          child: _CollectionListItem(
            url1: photo?.photos[0]?.urls?.thumb,
            url2: photo?.photos[1].urls.thumb,
            url3: photo?.photos[2].urls.thumb,
            collection: this.widget.viewModel.collections[index],
            onTap: () {
              //Navigator.push(
              //  context,
              //  MaterialPageRoute(
              //    builder: (context) =>
              //        ViewCollection(collection: this.widget.viewModel.collections[index]),
              //  ),
              //);
            },
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
    if (this.widget.viewModel.getCollectionsReport?.status ==
        ActionStatus.running) {
      return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: CircularProgressIndicator());
    } else {
      return SizedBox();
    }
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

class _CollectionListItem extends StatelessWidget {
  final Collection collection;
  final GestureTapCallback onTap;
  final String url1;
  final String url2;
  final String url3;

  const _CollectionListItem(
      {Key key, this.collection, this.onTap, this.url1, this.url2, this.url3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
            onTap: onTap,
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  new CachedNetworkImage(
                    imageUrl: url1,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                  new CachedNetworkImage(
                    imageUrl: url2,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                  new CachedNetworkImage(
                    imageUrl: url3,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  )
                ]),
                Text(
                  collection.title ?? "",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).textTheme.body1.color),
                ),
                Text(
                  collection.totalPhotos ?? "0" + " photos",
                  style:
                      TextStyle(color: Theme.of(context).textTheme.body2.color),
                )
              ],
            )));
  }
}

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
