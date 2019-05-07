# photo

A photo viewer create with a [Plugin](https://github.com/hayoi/haystack). It's so simple to create an Flutter app for Android and IOS.  
Using [Unsplash Api](https://unsplash.com/documentation#get-a-photo).  
![discover dark](https://raw.githubusercontent.com/hayoi/photo/master/image/discover_dark.png)
![collection list dark](https://raw.githubusercontent.com/hayoi/photo/master/image/collection_list.png)
![settings dark](https://raw.githubusercontent.com/hayoi/photo/master/image/settings.png)

## Create HomeView
1. Create a Flutter project with Android Studio.
2. Right tap lib folder to open the plugin, select "New"-->"Generate App Template".
3. Type "Home" in PageName Field, select "Get" checkbox. select BottomTabBar checkbox for a BottomNavigationBar. Type "User" in the Model Entry Name. Copy User json to Json Field from [Unsplash User Api](https://unsplash.com/documentation#get-a-users-public-profile). Tap "OK" buttom.
4. Set the id Field of User class as unique and select Datetime for all datetime type field. Generate.
 ### Create DiscoverView
 1. Right tap lib folder, select "New"-->"Generate App Template".
 2. Type "Discover" in PageName Field, select checkboxs: Query, AppBar, TopTabBar, ActionButton, Search. Type "Photo" in Model Entry Name, copy Photo json to Json Field from [Unsplash Photo Api](https://unsplash.com/documentation#get-a-photo). Tap "OK" buttom.
 3. Set the id Field of Photo class as unique and other field. Generate.
 ### Create CollectListView
 Open Plugin, type "CollectList" in PageName Field, select checkboxs: Query, AppBar, ListView, ActionButton, Search, Type "Collection" in Model Entry Name, copy Collection Json object to Json Field from [Unsplash Collection Api](https://unsplash.com/documentation#list-featured-collections). Type "Collection" in the Model Entry Name and tap "OK" buttom.
 ### Create MeView
 Open Plugin, type "Me" in PageName Field, select checkboxs: AppBar, UI only. Type User in the Model Entry Name and tap "OK" buttom.
 ### Modify Navigation route
 main.dart
 ```dart
 Map<String, WidgetBuilder> _routes() {
    return <String, WidgetBuilder>{
      "/settings": (_) => SettingsOptionsPage(
            options: _options,
            onOptionsChanged: _handleOptionsChanged,
          ),
      "/": (_) => new HomeView(),
    };
  }
 ```
 home_view.dart
 ```dart
 	widget = PageView(
        children: <Widget>[DiscoverView(), CollectListView(), MeView()],
 ```
 ### Set Server Address
 Edit network_common.dart according [Unsplash Public Action Api](https://unsplash.com/documentation#public-actions)
```dart
    // address
    dio.options.baseUrl = 'https://api.unsplash.com/';
    
    // authentication info
    options.headers["Authorization"] =
          "Client-ID e993cde7a4d49aa482dd572dfca4dd27891fc573c4f5bed7f202e156e02b8e8e";
```
  
 ### Create Photo latest page
 Open Plugin, type "Photo" in PageName Field, select checkboxs: UI only, Query in ViewModel Setting, ListView. Type Photo in the Model Entry Name and tap "OK" 
 #### Edit Photo api
 Edit photo_repository.dart according [Unsplash list-photo Api](https://unsplash.com/documentation#list-photos)
```dart
   Future<Page> getPhotosList(String sorting, int page, int limit) {
    return new NetworkCommon().dio.get("photos", queryParameters: {
      "order_by": sorting,
      "page": page,
      "per_page": limit
    }).then((d) {
      var results = new NetworkCommon().decodeResp(d);
      Page page = new NetworkCommon().decodePage(d);
      page.data =
      results.map<Photo>((item) => new Photo.fromJson(item)).toList();
      return page;
    });
  }
```
#### Edit photomiddleware
Edit photo_middleware.dart
```dart
Middleware<AppState> _createGetPhotos(PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (checkActionRunning(store, action)) return;
    running(next, action);
    int num = store.state.photoState.page.next;
    if (action.isRefresh) {
      num = 1;
    } else {
      if (store.state.photoState.page.next <= 0) {
        noMoreItem(next, action);
        return;
      }
    }
    repository.getPhotosList(action.orderBy, num, 10).then((page) {
      next(SyncPhotosAction(page: page, photos: page.data));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}
```
Edit photo_actions.dart
```dart
// add orderBy property
class GetPhotosAction {
  final String actionName = "GetPhotosAction";
  final bool isRefresh;
  final String orderBy;

  GetPhotosAction({this.orderBy, this.isRefresh});
}
```
#### Edit photo_view.dart
We use the follor package to list and show photos. import them in pubspec.yaml
```
  cached_network_image: ^0.7.0
  flutter_staggered_grid_view: ^0.2.7
```
In photo_view.dart
```dart
// define orderBy property in PhotoView
class PhotoView extends StatelessWidget {
  final String orderBy;

//build()
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
// _createItem()
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
```
Add orderBy parameter to photo_view_model.dart
```dart
  final Function(bool, String) getPhotos;
 
      getPhotos: (isRefresh, orderBy) {
        store.dispatch(GetPhotosAction(isRefresh: isRefresh,orderBy: orderBy));
      },
```
#### Add PhotoView to DiscoverView
```dart
  TabController _controller;
  List<String> _tabs = [
    "Latest",
 //will add some photos of some collection here
  ];
  List<int> _views = [
    0,
  ];
 
 // init TabController
  TabController _makeNewTabController() => TabController(
        vsync: this,
        length: _tabs.length,
      );

  Widget build(BuildContext context) {
    var widget;

    widget = TabBarView(
      key: Key(Random().nextDouble().toString()),
      controller: _controller,
      children: _views.map((id) {
        if (id == 0) {
          return PhotoView(orderBy: "latest");
        } else {
          return CollectionView(collection: id);
        }
      }).toList(),
    );
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          tabs: _tabs.map((title) => Tab(text: title)).toList(),
        ),
        title: Text("Discover"),
        actions: _buildActionButton(),
      ),
      body: widget,
    );
  }
```
now you can the app.
### Next, Create CollectionView and Middleware
#### add new action to middleware
Add new Property in photo_state.dart to save photos of each collection
```dart
  final Map<int, PhotoOfCollection> collectionPhotos;
```
add new acion in photo_actions.dart
```dart
class SyncCollectionPhotosAction {
  final String actionName = "SyncCollectionPhotosAction";
  final Page page;
  final int collectionId;

  SyncCollectionPhotosAction({this.collectionId, this.page});
}
```
in photo_reducer.dart
```dart
  TypedReducer<PhotoState, SyncCollectionPhotosAction>(_syncCollectionPhotos),
  
PhotoState _syncCollectionPhotos(
    PhotoState state, SyncCollectionPhotosAction action) {
  state.collectionPhotos.update(action.collectionId, (v) {
    v.id = action.collectionId;
    v.page?.last = action.page?.last;
    v.page?.prev = action.page?.prev;
    v.page?.first = action.page?.first;
    v.page?.next = action.page?.next;
    for (var photo in action.page?.data) {
      v.photos
          ?.update(photo.id.toString(), (vl) => photo, ifAbsent: () => photo);
    }
    return v;
  }, ifAbsent: () {
    PhotoOfCollection pc = new PhotoOfCollection();
    pc.id = action.collectionId;
    Page page = Page();
    page.last = action.page?.last;
    page.prev = action.page?.prev;
    page.first = action.page?.first;
    page.next = action.page?.next;
    pc.page = page;
    pc.photos = Map();
    for (var photo in action.page?.data) {
      pc.photos
          ?.update(photo.id.toString(), (v) => photo, ifAbsent: () => photo);
    }
    return pc;
  });
  return state.copyWith(collectionPhotos: state.collectionPhotos);
}
```

photo_middleware.dart
```dart
//add new action to list
  final getCollectionPhotos = _createGetCollectionPhotos(_repository);
  
    TypedMiddleware<AppState, GetCollectionPhotosAction>(getCollectionPhotos),

// new handle function
Middleware<AppState> _createGetCollectionPhotos(PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (checkActionRunning(store, action)) return;
    running(next, action);
    int num =
        store.state.photoState.collectionPhotos[action.id]?.page?.next ?? 1;
    if (action.isRefresh) {
      num = 1;
    } else {
      if (store.state.photoState.collectionPhotos[action.id] != null &&
          store.state.photoState.collectionPhotos[action.id].page.next <= 0) {
        noMoreItem(next, action);
        return;
      }
    }
    repository.getCollectionPhotos(action.id, num, 10).then((page) {
      next(SyncCollectionPhotosAction(collectionId: action.id, page: page));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}
```
#### Edit photo network api[Unsplash collection api](https://unsplash.com/documentation#get-a-collections-photos)
```dart
  Future<Page> getCollectionPhotos(int id, int page, int limit) {
    return new NetworkCommon().dio.get("collections/${id}/photos", queryParameters: {
      "page": page,
      "per_page": limit
    }).then((d) {
      var results = new NetworkCommon().decodeResp(d);
      Page page = new NetworkCommon().decodePage(d);
      page.data =
          results.map<Photo>((item) => new Photo.fromJson(item)).toList();
      return page;
    });
  }
```
#### Create Collection View
 Open Plugin, type "Collection" in PageName Field, select checkboxs: UI only, Query in ViewModel Setting , ListView. Type Photo in the Model Entry Name and tap "OK" 
Edit collection_View.dart
```dart
// add a int property in CollectionView to specify collection id
  final int collection;
  
  edit widget
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

// modify list item
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
```
Modify collection_view_model.dart
```dart
  final Function(bool) getPhotoOfCollection;
  
  static CollectionViewModel fromStore(Store<AppState> store, int id) {
    return CollectionViewModel(
      photos: store.state.photoState.collectionPhotos[id]?.photos?.values
          ?.toList() ?? [],
      getPhotoOfCollection: (isRefresh) {
        store.dispatch(GetCollectionPhotosAction(id: id, isRefresh: isRefresh));
      },
```
Add some collection to Discover page
```dart
  List<String> _tabs = [
    "Latest",
    "Wallpapers",
    "Textures",
    "Rainy",
    "Summer",
    "Flowers",
    "Women",
    "Home",
    "Oh Baby","Work","Winter","Animals"
  ];
  List<int> _views = [
    0,
    151521,
    175083,
    1052192,
    583479,
    1988224,
    4386752,
    145698,
    1099399,385548,3178572,181581
  ];
```
or, get a collections list from server
```dart
  List<int> getTabPPage() {
    List<int> list = [];
    list.add(0);
    for (var c in this.widget.viewModel.collections) {
      list.add(c.id);
    }

    return list;
  }

  List<String> getTab() {
    List<String> list = [];
    list.add("latest");
    for (var c in this.widget.viewModel.collections) {
      list.add(c.title ?? "");
    }

    return list;
  }
```

### New a photo Viewer page
Open Plugin, type "ViewPhoto" in PageName Field, select checkbox: UI only. Type Photo in the Model Entry Name and tap "OK" 
Add two property to ViewPhotoView
```dart
  final int id; //collection id
  final int pageIndex; //the index of photo in the list
  
  // build()
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
```
Edit view_photo_view_model.dart
```dart
    return ViewPhotoViewModel(
      photos: id == 0
          ? store.state.photoState.photos.values.toList() ?? []
          : store.state.photoState.collectionPhotos[id]?.photos?.values
                  ?.toList() ??
              [],
    );
```
Add action to photo list view:collection_view.dart and photo_view.dart
```dart
                child: InkWell(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPhotoView(
                              id: this.widget.collection, pageIndex: index),
                        ),
                      ),
```
Add Setting page to Me page
in me_view.dart
```dart
    widget = RaisedButton(
      child: Text("Settings"),
      onPressed: () => Navigator.of(context).pushNamed("/settings"),
    );
```
Look! It's very easy to create app with plugin: Flutter App Template Generater. Check the source code for the detail.
Search the plugin in plugin market in Intillij IDEA and Android Studio, using it to help you to develop App.
 ![discover](https://raw.githubusercontent.com/hayoi/photo/master/image/dicover.png)
