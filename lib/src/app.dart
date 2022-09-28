import 'package:app/src/ui/accounts/firebase_chat/chat.dart';
import 'package:app/src/ui/blocks/banners/contact_form.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/models/theme/bottom_navigation_bar.dart';
import 'package:app/src/resources/get_icon.dart';
import 'package:app/src/ui/accounts/account/account_floating_button.dart';
import 'package:app/src/ui/accounts/login/login.dart';
import 'package:app/src/ui/accounts/orders/order_list.dart';
import 'package:app/src/ui/accounts/wishlist.dart';
import 'package:app/src/ui/blocks/block_page.dart';
import 'package:app/src/ui/blocks/place_selector.dart';
import 'package:app/src/ui/home/search.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';
import 'resources/api_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ui/products/product_detail/product_detail.dart';
import 'ui/products/products/products.dart';
import 'models/app_state_model.dart';
import 'models/category_model.dart';
import 'models/product_model.dart';
import 'ui/accounts/account/account.dart';
import 'ui/categories/categories.dart';
import 'ui/checkout/cart/cart4.dart';
import 'ui/checkout/order_summary.dart';
import 'ui/blocks/home.dart';
import 'ui/blocks/home2.dart';
import 'ui/blocks/home_nearby.dart';
import 'ui/pages/post_detail.dart';
import 'ui/pages/webview.dart';
import './ui/home/place_picker.dart';
import 'ui/vendor/ui/stores/stores.dart';

class App extends StatefulWidget {
  final appStateModel = AppStateModel();
  App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {

  //int _currentIndex = 0;
  List<Category> mainCategories = [];
  List<Widget> _children = [];
  bool enableStoreTab = false;
  late int bottomItemsLength;

  @override
  void initState() {
    configureFcm();
    this.initDynamicLinks();
    enableStoreTab = widget.appStateModel.blocks.settings.storeTab;

    bottomItemsLength = widget.appStateModel.blocks.settings.bottomNavigationBar.items.length;

    if(bottomItemsLength < 2) {
      if(widget.appStateModel.blocks.settings.pageLayout.home == 'layout2') {
        _children.add(Home2());
      } else if(widget.appStateModel.blocks.settings.pageLayout.home == 'layout3') {
        _children.add(Home());
      } else if(widget.appStateModel.blocks.settings.pageLayout.home == 'layout1') {
        _children.add(HomeNearBy());
      } else {
        _children.add(HomeNearBy());
      }
    } else {
      widget.appStateModel.blocks.settings.bottomNavigationBar.items.forEach((element) {
        if(element.link == 'home') {
          if(widget.appStateModel.blocks.settings.pageLayout.home == 'layout2') {
            _children.add(Home2());
          } else if(widget.appStateModel.blocks.settings.pageLayout.home == 'layout3') {
            _children.add(Home());
          } else if(widget.appStateModel.blocks.settings.pageLayout.home == 'layout1') {
            _children.add(HomeNearBy());
          } else {
            _children.add(HomeNearBy());
          }
        } else if(element.link == 'category') {
          _children.add(Categories());
        } else if(element.link == 'store') {
          _children.add(StoreListPage());
        } else if(element.link == 'orders') {
          _children.add(OrderList());
        } else if(element.link == 'search') {
          _children.add(Search());
        } /*else if(element.link == 'bookings') {
          _children.add(BookingsPage());
        } */else if(element.link == 'template') {
          String id = element.linkId != null ? element.linkId! : '0';
          _children.add(BlockPage(child: Child(linkType: 'template', linkId: id, title: element.title)));
        } else if(element.link == 'wishlist') {
          _children.add(WishList());
        } else if(element.link == 'cart') {
          _children.add(CartPage());
        } else if(element.link == 'account') {
          _children.add(Account());
        } else if(element.link == 'webView') {
          String id = element.linkId != null ? element.linkId! : '0';
          _children.add(WebViewPage(url: id));
        } else if(element.link == 'pageWebView') {
          _children.add(WebViewPage(url: element.linkId!));
        } else if(element.link == 'post') {
          var child = Child(linkId: element.linkId!, linkType: 'post');
          _children.add(WPPostPage(child: child));
        } else if(element.link == 'page') {
          var child = Child(linkId: element.linkId!, linkType: 'page');
          _children.add(WPPostPage(child: child));
        } else if(element.link == 'contactForm7') {
          Category category = new Category(id: int.parse(element.linkId!), name: element.title);
          _children.add(ContactForm7(category: category));
        }
      });
    }
    
    super.initState();
  }

  Future<void> onChangePageIndex(int index) async {
    if(widget.appStateModel.blocks.settings.bottomNavigationBar.items.length > index) {
      if(['wishlist', 'orders', 'booking'].contains(widget.appStateModel.blocks.settings.bottomNavigationBar.items[index].link) && widget.appStateModel.user.id == 0) {
        await Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => Login()));
        setState(() {});
      } else {
        widget.appStateModel.currentPageIndex = index;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    //Uncomment only when testing without location
    /*return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.start,
      floatingActionButton: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            if (model.blocks.settings.homePageChat == true && _currentIndex == 0) {
              return FloatingActionButton(
                onPressed: () =>
                    _openWhatsApp(model.blocks.settings.phoneNumber.toString()),
                tooltip: 'Chat',
                child: Icon(Icons.chat_bubble),
              );
            } else {
              return Container();
            }
          }),
      body: _children[_currentIndex],
      bottomNavigationBar: buildBottomNavigationBar(context),
    );*/

    if (widget.appStateModel.blocks.settings.geoLocation && widget.appStateModel.blocks.settings.customLocation) {
      return ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            if (model.customerLocation['name'] == null && model.blocks.settings.locations.length > 0) {
              return Scaffold(body: PlaceSelector() // create login with no pop()
              );
            } else {
              return Scaffold(
                drawerDragStartBehavior: DragStartBehavior.start,
                floatingActionButton: ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                      if (model.blocks.settings.homePageChat &&
                          widget.appStateModel.currentPageIndex == 0) {
                        return AccountFloatingButton(page: 'home');
                      } else {
                        return Container();
                      }
                    }),
                body: _children[widget.appStateModel.currentPageIndex],
                bottomNavigationBar: buildBottomNavigationBar(context),
              );
            }
          }
      );
    }

    else if (widget.appStateModel.blocks.settings.geoLocation && widget.appStateModel.blocks.settings.googleMapLocation) {
      return ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            if (model.loading) {
              return Scaffold(
                body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width - 32,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            } else if (model.customerLocation['latitude'] == null) {
              return Scaffold(body: PlacePickerHome() // create login with no pop()
              );
            } else if (model.blocks.stores.length != 0) {
              return Scaffold(
                drawerDragStartBehavior: DragStartBehavior.start,
                floatingActionButton: ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                      if (model.blocks.settings.homePageChat &&
                          widget.appStateModel.currentPageIndex == 0) {
                        return AccountFloatingButton(page: 'home');
                      } else {
                        return Container();
                      }
                    }),
                body: _children[widget.appStateModel.currentPageIndex],
                bottomNavigationBar: buildBottomNavigationBar(context),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.white,
                body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: Stack(
                    alignment: Alignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          width: MediaQuery.of(context).size.width - 32,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        child: Column(
                          children: [
                            Container(
                                width: 200,
                                child: Text(
                                  model.blocks.localeText.weAreNotInYourArea,
                                  textAlign: TextAlign.center, style: TextStyle(color: Colors.black),)),
                            SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PlacePickerHome()));
                                setState(() {});
                                await model.updateAllBlocks();
                                setState(() {});
                              },
                              child: Text(model.blocks.localeText.changeYourLocation),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
      );
    }

    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.start,
      floatingActionButton: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            if (model.blocks.settings.homePageChat && widget.appStateModel.currentPageIndex == 0) {
              return AccountFloatingButton(page: 'home');
            } else {
              return Container();
            }
          }),
      body: _children[widget.appStateModel.currentPageIndex],
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  onProductClick(product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: product);
    }));
  }

  Future _openWhatsApp(String number) async {
    final url = 'https://wa.me/' + number;
    launchUrl(Uri.parse(url));
  }

  BottomNavigationBar? buildBottomNavigationBar(BuildContext context) {

    BottomNavigationBarModel bottomNavigationBar = widget.appStateModel.blocks.settings.bottomNavigationBar;

    if(bottomItemsLength >= 2 && bottomNavigationBar.items.length >= 2 && bottomItemsLength == bottomNavigationBar.items.length) {
      bool isDark = Theme.of(context).brightness == Brightness.dark;
      return BottomNavigationBar(
        currentIndex: widget.appStateModel.currentPageIndex,
        onTap: onChangePageIndex,
        type: bottomNavigationBar.type,
        //showSelectedLabels: bottomNavigationBar.showSelectedLabels,
        //showUnselectedLabels: bottomNavigationBar.showUnselectedLabels,
        items: setBottomNavigationBarItem(bottomNavigationBar.items),
        //elevation: bottomNavigationBar.elevation,
      );
    } return null;

  }

  setBottomNavigationBarItem(List<NavigationItem> items) {

    List<BottomNavigationBarItem> _bottomNavigationBarItem = [];

    if(bottomItemsLength == widget.appStateModel.blocks.settings.bottomNavigationBar.items.length)
    items.forEach((element) {
      if(element.link != 'cart') {
        _bottomNavigationBarItem.add(
            BottomNavigationBarItem(
              backgroundColor: element.backgroundColor,
              icon: getIcon(element.icon),
              activeIcon: getIcon(element.activeIcon),
              label: element.title,
            )
        );
      } else {
        _bottomNavigationBarItem.add(
            BottomNavigationBarItem(
                backgroundColor: element.backgroundColor,
                icon: Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: getIcon(element.icon),
                  ),
                  new Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: context.watch<ShoppingCart>().count != 0 ? Card(
                        elevation: 0,
                        clipBehavior: Clip.antiAlias,
                        shape: StadiumBorder(),
                        color: Colors.red,
                        child: Container(
                            padding: EdgeInsets.all(2),
                            constraints: BoxConstraints(minWidth: 20.0),
                            child: Center(
                                child: Text(
                                  context.read<ShoppingCart>().count.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      backgroundColor: Colors.red),
                                )))) : Container(),
                  ),
                ]),
                activeIcon: Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: getIcon(element.activeIcon),
                  ),
                  new Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: context.watch<ShoppingCart>().count != 0 ? Card(
                        elevation: 0,
                        clipBehavior: Clip.antiAlias,
                        shape: StadiumBorder(),
                        color: Colors.red,
                        child: Container(
                            padding: EdgeInsets.all(2),
                            constraints: BoxConstraints(minWidth: 20.0),
                            child: Center(
                                child: Text(
                                  context.read<ShoppingCart>().count.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      backgroundColor: Colors.red),
                                )))) : Container(),
                  ),
                ]),
                label: element.title,
            )
        );
      }
    });

    return _bottomNavigationBarItem;
  }

  Future<void> configureFcm() async {

    await Future.delayed(Duration(seconds: 3));

      try {
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(announcement: true, criticalAlert: true);
      } catch(e) {}

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {_onMessage(message);});

     //FirebaseMessaging.onMessage.listen((RemoteMessage message) {_onMessage(message);});

     FirebaseMessaging.instance.getToken().then((String? token) {
       if(token != null) {
         widget.appStateModel.fcmToken = token;
         widget.appStateModel.apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-update_user_notification', {'fcm_token': token});
       }
     });

     FirebaseMessaging.instance.subscribeToTopic('all');

  }

  void _onMessage(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      if (message.data.containsKey('category')) {
        var filter = new Map<String, dynamic>();
        filter['id'] = message.data['category'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductsWidget(filter: filter, name: '')));
      } else if (message.data.containsKey('product_id')) {
        Product product = Product.fromJson({'id': int.parse(message.data['product_id'].toString())});
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                    product: product
                )));
      } else if (message.data.containsKey('product')) {
        Product product = Product.fromJson({'id': int.parse(message.data['product'].toString())});
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                  product: product
                )));
      } else if (message.data.containsKey('page')) {
        var child = Child(linkId: message.data['page'].toString(), linkType: 'page');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => WPPostPage(child: child)));
      } else if (message.data.containsKey('post')) {
        var child = Child(linkId: message.data['post'].toString(), linkType: 'post');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => WPPostPage(child: child)));
      } else if (message.data.containsKey('link')) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WebViewPage(url: message.data['link'], title: '')));
      } else if (message.data.containsKey('order')) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderSummary(id: message.data['order'])));
      }
    } else if (message.data.containsKey('chat')) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FireBaseChat(otherUserId: message.data['chat'])));
    }
  }

  void initDynamicLinks() {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      await Future.delayed(Duration(seconds: 1));
      final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
      if(data != null) {
        final Uri? deepLink = data.link;
        if (deepLink != null) {
          this.navigateTo(deepLink);
        }
      } else {
        final Uri? deepLink = dynamicLinkData.link;
        if (deepLink != null) {
          this.navigateTo(deepLink);
        }
      }

    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  Future<void> navigateTo(Uri deepLink) async {
    await Future.delayed(Duration(seconds: 1));
    if(deepLink.queryParameters.containsKey('wwref')) {
      ApiProvider().filter.addAll({'wwref': deepLink.queryParameters['wwref']!});
      ApiProvider().get('/my-account/?wwref=' + deepLink.queryParameters['wwref']!);
    }
    if (deepLink.queryParameters['category'] != null) {
      var filter = new Map<String, dynamic>();
      filter['id'] = deepLink.queryParameters['category'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductsWidget(filter: filter, name: '')));
    } else if (deepLink.queryParameters.containsKey('product_id')) {
      Product product = Product.fromJson({'id': int.parse(deepLink.queryParameters['product_id']!)});
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetail(
                  product: product
              )));
    } else if (deepLink.queryParameters.containsKey('product')) {
      Product product = Product.fromJson({'id': int.parse(deepLink.queryParameters['product']!)});
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetail(
                  product: product
              )));
    } else if (deepLink.queryParameters.containsKey('page')) {
      var child = Child(linkId: deepLink.queryParameters['post'].toString(), linkType: 'page');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WPPostPage(child: child)));
    } else if (deepLink.queryParameters.containsKey('post')) {
      var child = Child(linkId: deepLink.queryParameters['post'].toString(), linkType: 'post');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WPPostPage(child: child)));
    } else if (deepLink.queryParameters.containsKey('link')) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebViewPage(url: deepLink.queryParameters['link']!, title: '')));
    } else if (deepLink.queryParameters.containsKey('order')) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OrderSummary(id: deepLink.queryParameters['order']!)));
    } else if (deepLink.queryParameters.containsKey('chat')) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FireBaseChat(otherUserId: deepLink.queryParameters['chat']!)));
    }
  }
}