import 'package:app/src/ui/accounts/firebase_chat/chat.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/config.dart';
import 'package:app/src/ui/accounts/reward_points.dart';
import 'package:app/src/ui/blocks/products/wishlist_icon.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../orders/download_list.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../refer_and_earn.dart';
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

class UserAccount1 extends StatefulWidget {
  @override
  _UserAccount1State createState() => _UserAccount1State();
}

class _UserAccount1State extends State<UserAccount1> {
  final appStateModel = AppStateModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).canvasColor,
      floatingActionButton: AccountFloatingButton(),
      appBar: AppBar(
        title: Text(appStateModel.blocks.localeText.account),
      ),
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
        return ListView(
          children: _buildList(model),
        );
      }),
    );
  }

  _buildList(AppStateModel model) {
    List<Widget> list = [];
    bool isLoggedIn = model.user.id != null && model.user.id > 0;
    TextStyle? titleStyle = Theme.of(context).textTheme.bodyText1;
    double margin = 1;
    double elevation = 0.5;

    list.add(SizedBox(height: margin / 2));

    if (!isLoggedIn)
      list.add(CustomCard(
        child: ListTile(
          onTap: () {
            _userLogin();
          },
          leading: Icon(CupertinoIcons.person),
          title: Text(model.blocks.localeText.signIn, style: titleStyle),
          trailing: Icon(Icons.chevron_right),
        ),
      ));

    if (model.blocks.settings.wallet)
    list.add(CustomCard(
      child: ListTile(
        onTap: () {
          isLoggedIn
              ? Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Wallet()))
              : _userLogin();
        },
        leading: Icon(Icons.account_balance_wallet_outlined),
        title: Text(model.blocks.localeText.wallet, style: titleStyle),
        trailing: Icon(Icons.chevron_right),
      ),
    ));

    if (model.blocks.settings.referAndEarn)
      list.add(CustomCard(
        child: ListTile(
          onTap: () {
            isLoggedIn
                ? Navigator.push(
                context, MaterialPageRoute(builder: (context) => ReferAndEarn()))
                : _userLogin();
          },
          leading: Icon(CupertinoIcons.money_pound_circle),
          title: Text(model.blocks.localeText.referAndEarn, style: titleStyle),
          trailing: Icon(Icons.chevron_right),
        ),
      ));

    list.add(CustomCard(
      child: ListTile(
        onTap: () {
          isLoggedIn
              ? Navigator.push(
                  context, MaterialPageRoute(builder: (context) => WishList()))
              : _userLogin();
        },
        leading: Icon(CupertinoIcons.heart),
        title: Text(model.blocks.localeText.wishlist, style: titleStyle),
        trailing: Icon(Icons.chevron_right),
      ),
    ));

    if (model.blocks.settings.rewardPoints)
    list.add(CustomCard(
      child: ListTile(
        onTap: () {
          isLoggedIn
              ? Navigator.push(
              context, MaterialPageRoute(builder: (context) => RewardPoints()))
              : _userLogin();
        },
        leading: Icon(CupertinoIcons.money_dollar_circle),
        title: Text(model.blocks.localeText.rewardPoints, style: titleStyle),
        trailing: Icon(Icons.chevron_right),
      ),
    ));

    if(!model.blocks.settings.catalogueMode)
    list.add(CustomCard(
      child: ListTile(
        onTap: () {
          isLoggedIn
              ? Navigator.push(
                  context, MaterialPageRoute(builder: (context) => OrderList()))
              : _userLogin();
        },
        leading: Icon(CupertinoIcons.bag),
        title: Text(model.blocks.localeText.orders, style: titleStyle),
        trailing: Icon(Icons.chevron_right),
      ),
    ));

    if (model.blocks.settings.downloadProducts)
    list.add(CustomCard(
      child: ListTile(
        onTap: () {
          isLoggedIn
              ? Navigator.push(
              context, MaterialPageRoute(builder: (context) => DownloadsPage()))
              : _userLogin();
        },
        leading: Icon(CupertinoIcons.cloud_download),
        title: Text(model.blocks.localeText.downloads, style: titleStyle),
        trailing: Icon(Icons.chevron_right),
      ),
    ));

    /*list.add(
        CustomCard(
          child: ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MessageList()));
            },
            leading: Icon(MStoreIcons.notifications),
            title: Text(model.blocks.localeText.notifications, style: titleStyle),
            trailing: Icon(Icons.chevron_right),
          ),
        )
    );*/


    if(model.blocks.settings.chatType == 'firebaseChat' || model.blocks.settings.chatType == 'circular')
    list.add(CustomCard(
      child: ListTile(
        onTap: () {
          isLoggedIn
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FireBaseChat(otherUserId: model.blocks.siteSettings.adminUIDs.first)))
              : _userLogin();
        },
        leading: Icon(CupertinoIcons.chat_bubble),
        title: Text(model.blocks.localeText.chat, style: titleStyle),
        trailing: Icon(Icons.chevron_right),
      ),
    ));

    list.add(CustomCard(
      child: ListTile(
        onTap: () {
          isLoggedIn
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomerAddress()))
              : _userLogin();
        },
        leading: Icon(CupertinoIcons.location),
        title: Text(model.blocks.localeText.address, style: titleStyle),
        trailing: Icon(Icons.chevron_right),
      ),
    ));

    if(appStateModel.blocks.settings.darkThemeSwitch)
    list.add(CustomCard(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsPage()));
        },
        leading: Icon(CupertinoIcons.settings),
        title: Text(model.blocks.localeText.settings, style: titleStyle),
        trailing: Icon(Icons.chevron_right),
      ),
    ));

    if (model.blocks.languages.length > 0)
      list.add(CustomCard(
        child: ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LanguagePage()));
          },
          leading: Icon(CupertinoIcons.globe),
          title: Text(model.blocks.localeText.language, style: titleStyle),
          trailing: Icon(Icons.chevron_right),
        ),
      ));

    if (model.blocks.currencies.length > 0)
      list.add(CustomCard(
        child: ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CurrencyPage()));
          },
          leading: Icon(CupertinoIcons.money_dollar_circle),
          title: Text(model.blocks.localeText.currency, style: titleStyle),
          trailing: Icon(Icons.chevron_right),
        ),
      ));

    if (appStateModel.blocks.settings.dynamicLink.isNotEmpty)
    list.add(CustomCard(
      child: ListTile(
        onTap: () => _shareApp(),
        leading: Icon(CupertinoIcons.share),
        title: Text(model.blocks.localeText.shareApp, style: titleStyle),
        trailing: Icon(Icons.chevron_right),
      ),
    ));

    /*if (isLoggedIn &&
        !model.isVendor.contains(model.user.role) &&
        model.blocks.settings.vendorType == 'dokan') {
      list.add(CustomCard(
        child: ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ApplyForVendor()));
          },
          leading: Icon(MStoreIcons.account_circle_fill),
          title: Text(model.blocks.localeText.becomeVendor, style: titleStyle),
          trailing: Icon(Icons.chevron_right),
        ),
      ));
    }*/
    if (isLoggedIn)
      list.add(CustomCard(
        child: ListTile(
          onTap: () async {
            await model.logout();
            context.read<Favourites>().clear();
            context.read<ShoppingCart>().getCart();
          },
         // onTap: () => model.logout(),
          leading: Icon(CupertinoIcons.power),
          title: Text(model.blocks.localeText.logout, style: titleStyle),
          trailing: Icon(Icons.chevron_right),
        ),
      ));

    if (model.blocks.pages.length != 0 &&
        model.blocks.pages[0].url.isNotEmpty) {
      list.add(SizedBox(height: 24));
      model.blocks.pages.forEach((element) {
        list.add(CustomCard(
          child: ListTile(
            onTap: () => _onPressItem(element, context),
            leading: Icon(Icons.info),
            title: Text(element.title, style: titleStyle),
            trailing: Icon(Icons.chevron_right),
          ),
        ));
      });
    }

    if (isLoggedIn &&
        ((model.isVendor.contains(model.user.role) &&
                model.blocks.settings.multiVendor) ||
            model.user.role.contains('administrator'))) {
      list.add(SizedBox(height: 24));
      list.add(CustomCard(
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VendorProductList(vendorId: model.user.id.toString())));
          },
          leading: Icon(CupertinoIcons.rectangle_grid_2x2),
          title: Text(model.blocks.localeText.products, style: titleStyle),
          trailing: Icon(Icons.chevron_right),
        ),
      ));
      list.add(CustomCard(
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VendorOrderList(vendorId: model.user.id.toString())));
          },
          leading: Icon(Icons.shopping_basket_outlined),
          title: Text(model.blocks.localeText.orders, style: titleStyle),
          trailing: Icon(Icons.chevron_right),
        ),
      ));
    }

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
    String id = appStateModel.user.id > 0 ? appStateModel.user.id.toString() : '0';
    final url = Config().url + '?wwref=' + id;
    if(appStateModel.blocks.settings.dynamicLink.isNotEmpty) {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: appStateModel.blocks.settings.dynamicLink,
        link: Uri.parse(url),
        socialMetaTagParameters:  SocialMetaTagParameters(
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
}

class CustomCard extends StatelessWidget {
  CustomCard({Key? key, required this.child}) : super(key: key);

  final Widget child;
  final double margin = 0.1;
  final double elevation = 0.0;
  final double borderRadius = 0;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black; //Theme.of(context).accentColor;
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      margin: EdgeInsets.fromLTRB(margin, margin / 2, margin, margin / 2),
      child: Column(
        children: [
          child,
          Divider(height: 0)
        ],
      ),
    );
  }
}
