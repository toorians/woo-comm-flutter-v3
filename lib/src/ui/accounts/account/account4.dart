import 'package:app/src/ui/accounts/firebase_chat/chat.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/config.dart';
import 'package:app/src/ui/accounts/reward_points.dart';
import 'package:app/src/ui/blocks/products/wishlist_icon.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/src/provider.dart';
import '../../../ui/accounts/orders/download_list.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'apply_for_vendor.dart';
import '../../../ui/pages/webview.dart';
import '../../../models/app_state_model.dart';
import '../../../models/blocks_model.dart';
import '../../../ui/accounts/settings/settings.dart';
import '../../vendor/ui/orders/order_list.dart';
import '../../vendor/ui/products/vendor_products/product_list.dart';
import '../address/customer_address.dart';
import '../currency.dart';
import '../language/language.dart';
import '../login/login.dart';
import '../orders/order_list.dart';
import '../../pages/post_detail.dart';
import '../wallet.dart';
import '../wishlist.dart';
import 'account_floating_button.dart';

class UserAccount4 extends StatefulWidget {
  @override
  _UserAccount4State createState() => _UserAccount4State();
}

class _UserAccount4State extends State<UserAccount4> {
  final appStateModel = AppStateModel();
  @override
  Widget build(BuildContext context) {
    TextStyle? menuTextStyle = Theme.of(context).textTheme.bodyText1;
    Color? onPrimaryColor = Theme.of(context).primaryTextTheme.headline6!.color;
    Color headerBackgroundColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      floatingActionButton: AccountFloatingButton(),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondary,
            height: 300,
            child:  Container(
              height: 300,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Center(
                child: Container(
                  child: Container(
                      width: 200,
                      child: Image.asset('assets/images/logo.png', fit: BoxFit.fitHeight,)
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 180),
            child: ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverPadding(padding: EdgeInsets.only(top: 40, left: 24, right: 24),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                              _buildListOfList(model)
                          ),
                        ),
                      )
                    ],
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  _buildListOfList(AppStateModel model) {
    TextStyle? titleStyle = Theme.of(context).textTheme.bodyText1;
    bool isLoggedIn = model.user.id > 0;
    List<Widget> list = [];
    list.add(Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: _buildUserList(model),
      ),
    ));

    if (model.blocks != null && model.blocks.pages.length != 0 && model.blocks.pages[0].url.isNotEmpty) {
      list.add(SizedBox(height: 32));
      list.add(Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: _buildPageList(model),
        ),
      ));
    }

    if (isLoggedIn && ((model.isVendor.contains(model.user.role) && model.blocks.settings.multiVendor) || model.user.role.contains('administrator')))
      list.add(Container(height: 32, child: SizedBox(height: 32)));
    list.add(Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(top: 48, bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: _buildvendorList(model),
      ),
    ));

    return list;
  }

  _buildUserList(AppStateModel model) {
    List<Widget> list = [];
    bool isLoggedIn = model.user.id > 0;
    TextStyle? titleStyle = Theme.of(context).textTheme.bodyText1;
    double margin = 8;

    list.add(SizedBox(height: margin/2));

    if(!isLoggedIn)
      list.add(
          CustomCard(
            child: ListTile(
              onTap: () {
                _userLogin();
              },
              leading: Icon(Icons.person),
              title: Text(model.blocks.localeText.signIn, style: titleStyle),
              trailing: Icon(Icons.arrow_right),
            ),
          )
      );

    if (isLoggedIn && !model.isVendor.contains(model.user.role) && model.blocks.siteSettings.vendorType == 'dokan') {
      list.add(
          CustomCard(
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyForVendor()));
              },
              leading: Icon(FlutterRemix.account_circle_fill),
              title: Text(model.blocks.localeText.becomeVendor, style: titleStyle),
              trailing: Icon(Icons.arrow_right),
            ),
          )
      );
    }

    if (model.blocks.settings.wallet)
    list.add(
        CustomCard(
          child: ListTile(
            onTap: () {
              isLoggedIn ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Wallet())) : _userLogin();
            },
            leading: Icon(Icons.account_balance_wallet),
            title: Text(model.blocks.localeText.wallet, style: titleStyle),
            trailing: Icon(Icons.arrow_right),
          ),
        )
    );

    list.add(
        CustomCard(
          child: ListTile(
            onTap: () {
              isLoggedIn ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WishList())) : _userLogin();
            },
            leading: Icon(CupertinoIcons.heart),
            title: Text(model.blocks.localeText.wishlist, style: titleStyle),
            trailing: Icon(Icons.arrow_right),
          ),
        )
    );

    if (model.blocks.settings.rewardPoints)
      list.add(CustomCard(
        child: ListTile(
          onTap: () {
            isLoggedIn
                ? Navigator.push(
                context, MaterialPageRoute(builder: (context) => RewardPoints()))
                : _userLogin();
          },
          leading: Icon(CupertinoIcons.money_dollar_circle_fill),
          title: Text(model.blocks.localeText.rewardPoints, style: titleStyle),
          trailing: Icon(Icons.arrow_right),
        ),
      ));

    if(!model.blocks.settings.catalogueMode)
    list.add(
        CustomCard(
          child: ListTile(
            onTap: () {
              isLoggedIn ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderList())) : _userLogin();
            },
            leading: Icon(FlutterRemix.shopping_basket_2_fill),
            title: Text(model.blocks.localeText.orders, style: titleStyle),
            trailing: Icon(Icons.arrow_right),
          ),
        )
    );

    if (model.blocks.settings.downloadProducts)
      list.add(CustomCard(
        child: ListTile(
          onTap: () {
            isLoggedIn
                ? Navigator.push(
                context, MaterialPageRoute(builder: (context) => DownloadsPage()))
                : _userLogin();
          },
          leading: Icon(Icons.cloud_download_rounded),
          title: Text(model.blocks.localeText.downloads, style: titleStyle),
          trailing: Icon(Icons.arrow_right),
        ),
      ));

    if(model.blocks.settings.chatType == 'firebaseChat' || model.blocks.settings.chatType == 'circular')
      list.add(
        CustomCard(
          child: ListTile(
            onTap: () {
              isLoggedIn ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FireBaseChat(otherUserId: model.blocks.siteSettings.adminUIDs.first))) : _userLogin();
            },
            leading: Icon(Icons.chat_bubble),
            title: Text(model.blocks.localeText.chat, style: titleStyle),
            trailing: Icon(Icons.arrow_right),
          ),
        )
    );

    /*list.add(
        CustomCard(
          child: ListTile(
            onTap: () {
              isLoggedIn ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MessageList())) : _userLogin();
            },
            leading: Icon(MStoreIcons.shopping_basket_2_fill),
            title: Text(model.blocks.localeText.orders, style: titleStyle),
            trailing: Icon(Icons.notifications),
          ),
        )
    );*/

    list.add(
        CustomCard(
          child: ListTile(
            onTap: () {
              isLoggedIn ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomerAddress())) : _userLogin();
            },
            leading: Icon(CupertinoIcons.location),
            title: Text(model.blocks.localeText.address, style: titleStyle),
            trailing: Icon(Icons.arrow_right),
          ),
        )
    );

    if(appStateModel.blocks.settings.darkThemeSwitch)
    list.add(
        CustomCard(
          child: ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
            leading: Icon(CupertinoIcons.settings),
            title: Text(model.blocks.localeText.settings, style: titleStyle),
            trailing: Icon(Icons.arrow_right),
          ),
        )
    );

    if (model.blocks.languages.length > 0)
      list.add(
          CustomCard(
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LanguagePage()));
              },
              leading: Icon(Icons.language),
              title: Text(model.blocks.localeText.language, style: titleStyle),
              trailing: Icon(Icons.arrow_right),
            ),
          )
      );

    if (model.blocks.currencies.length > 0)
      list.add(
          CustomCard(
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CurrencyPage()));
              },
              leading: Icon(Icons.attach_money),
              title: Text(model.blocks.localeText.currency, style: titleStyle),
              trailing: Icon(Icons.arrow_right),
            ),
          )
      );

    if (appStateModel.blocks.settings.dynamicLink.isNotEmpty)
    list.add(
        CustomCard(
          child: ListTile(
            onTap: () => _shareApp(),
            leading: Icon(CupertinoIcons.share),
            title: Text(model.blocks.localeText.shareApp, style: titleStyle),
            trailing: Icon(Icons.arrow_right),
          ),
        )
    );

    if (isLoggedIn)
    list.add(
        CustomCard(
          child: ListTile(
            onTap: () async {
              await model.logout();
              context.read<Favourites>().clear();
              context.read<ShoppingCart>().getCart();
            },
            leading: Icon(CupertinoIcons.power),
            title: Text(model.blocks.localeText.logout, style: titleStyle),
            trailing: Icon(Icons.arrow_right),
          ),
        )
    );

    if (model.blocks != null && model.blocks.pages.length != 0 && model.blocks.pages[0].url.isNotEmpty) {
      list.add(SizedBox(height: 24));
      model.blocks.pages.forEach((element) {
        list.add(
            CustomCard(
              child: ListTile(
                onTap: () => _onPressItem(element, context),
                leading: Icon(Icons.info),
                title: Text(element.title, style: titleStyle),
                trailing: Icon(Icons.arrow_right),
              ),
            )
        );
      });
    }

    return list;
  }

  _buildvendorList(AppStateModel model) {
    List<Widget> list = [];
    bool isLoggedIn = model.user.id > 0;
    TextStyle? titleStyle = Theme.of(context).textTheme.bodyText1;

    list.add(
        CustomCard(
          child: ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VendorProductList(vendorId: model.user.id.toString())));
            },
            leading: Icon(FlutterRemix.grid_fill),
            title: Text(model.blocks.localeText.products, style: titleStyle),
            trailing: Icon(Icons.arrow_right),
          ),
        )
    );
    list.add(
        CustomCard(
          child: ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VendorOrderList(vendorId: model.user.id.toString())));
            },
            leading: Icon(Icons.shopping_basket),
            title: Text(model.blocks.localeText.orders, style: titleStyle),
            trailing: Icon(Icons.arrow_right),
          ),
        )
    );

    return list;
  }

  _buildPageList(AppStateModel model) {
    List<Widget> list = [];
    TextStyle? titleStyle = Theme.of(context).textTheme.bodyText1;

    model.blocks.pages.forEach((element) {
      list.add(
          CustomCard(
            child: ListTile(
              onTap: () => _onPressItem(element, context),
              leading: Icon(Icons.info),
              title: Text(element.title, style: titleStyle),
              trailing: Icon(Icons.arrow_right),
            ),
          )
      );
    });

    return list;
  }

  _buildVendorList() {
    List<Widget> list = [];

    return list;
  }

  _userLogin() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    context.read<Favourites>().getWishList();
    context.read<ShoppingCart>().getCart();
  }

  Future openLink(String url) async {
    launchUrl(Uri.parse(url));
    //canLaunch not working for some android device
    /*if (await canLaunch(url)) {
      await launchUri(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }*/
  }

  _shareApp() async {
    String id = appStateModel.user.id > 0
        ? appStateModel.user.id.toString()
        : '0';
    final url = Config().url + '?wwref=' + id;
    if (appStateModel.blocks.settings.dynamicLink.isNotEmpty) {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: appStateModel.blocks.settings.dynamicLink,
        link: Uri.parse(url),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Check this app',
        ),
        androidParameters: AndroidParameters(
          packageName: Config().androidPackageName,
          minimumVersion: 0,
        ),
        iosParameters: IOSParameters(
          bundleId: Config().iosPackageName,
        ),
      );

      final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      Share.share(dynamicLink.shortUrl.toString());
    }
  }

  _onPressItem(OldChild page, BuildContext context) {
    if (page.description == 'page') {
      var child = Child(linkId: page.url.toString(), linkType: 'page');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WPPostPage(child: child)));
    } else if (page.description == 'post') {
      var child = Child(linkId: page.url.toString(), linkType: 'post');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WPPostPage(child: child)));
    } else if (page.description == 'link') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebViewPage(url: page.url, title: page.title)));
    }
  }

  Widget buildAccountBackground(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 30,
          left: -30,
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(38 / 360),
            child: Container(
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
              height: 35,
              width: 90,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: -5,
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(127 / 360),
            child: Container(
              color: Theme.of(context).primaryColorDark.withOpacity(0.8),
              height: 35,
              width: 90,
            ),
          ),
        ),
        Positioned(
          bottom: 62,
          right: -40,
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(125 / 360),
            child: Container(
              color: Theme.of(context).primaryColorDark.withOpacity(0.8),
              height: 35,
              width: 100,
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          right: -60,
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(125 / 360),
            child: Container(
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
              height: 35,
              width: 160,
            ),
          ),
        )
      ],
    );
  }

  Widget buildAccountBackground2(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColorDark,
                  Theme.of(context).primaryColorLight.withOpacity(0.1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
        ),
        Positioned(
          top: 10,
          left: 80,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
            ),
            height: 60,
            width: 60,
          ),
        ),
        Positioned(
          top: 0,
          left: -5,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
            ),
            height: 35,
            width: 90,
          ),
        ),
        Positioned(
          bottom: 62,
          right: -40,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
            ),
            height: 100,
            width: 100,
          ),
        ),
        Positioned(
          bottom: -40,
          right: 60,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
            ),
            height: 80,
            width: 80,
          ),
        )
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({Key? key, required this.child}) : super(key: key);

  final Widget child;
  final double margin = 1;
  final double elevation = 0.0;
  final double borderRadius = 0;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;//Theme.of(context).accentColor;
    return Column(
      children: [
        Card(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          margin: EdgeInsets.fromLTRB(margin, margin/2, margin, margin/2),
          child: child,
        ),
        Divider(height: 0)
      ],
    );
  }
}
