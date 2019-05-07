# photo

A photo viewer create with a [Plugin](https://github.com/hayoi/haystack). It's so simple to create an Flutter app for Android and IOS.  
Using [Unsplash Api](https://unsplash.com/documentation#get-a-photo).

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
 Open Plugin, type "Me" in PageName Field, select checkboxs: Query, AppBar, UI only. Type User in the Model Entry Name and tap "OK" buttom.
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
 ![home](https://raw.githubusercontent.com/hayoi/photo/master/image/home1.png)
 
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
 Open Plugin, type "Photo" in PageName Field, select checkboxs: UI only, Query, ListView. Type Photo in the Model Entry Name and tap "OK" 
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




 
