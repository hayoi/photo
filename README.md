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
 ### Create FollowView
 Open Plugin, type "Follow" in PageName Field, select checkboxs: Query, AppBar, ListView, ActionButton, Search, we had create User model, don't need to create any more, so select UI only checkbox. Type User in the Model Entry Name and tap "OK" buttom.
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
        children: <Widget>[DiscoverView(), FollowView(), MeView()],
 ```
 ![home](https://raw.githubusercontent.com/hayoi/photo/master/image/home1.png)
