import 'dart:io';
import 'package:app/src/ui/accounts/account/delete_account.dart';
import 'package:app/src/ui/accounts/firebase_chat/chat.dart';
import 'package:app/src/ui/accounts/firebase_chat/rooms.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/config.dart';
import 'package:app/src/ui/accounts/reward_points.dart';
import 'package:app/src/ui/blocks/block_page.dart';
import 'package:app/src/ui/blocks/category/all_brnads.dart';
import 'package:app/src/ui/blocks/posts/post_detail.dart';
import 'package:app/src/ui/blocks/products/wishlist_icon.dart';
import 'package:app/src/ui/checkout/cart/cart4.dart';
import 'package:app/src/ui/vendor/ui/orders/order_list.dart';
import 'package:app/src/ui/vendor/ui/products/vendor_products/product_list.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:app/src/ui/accounts/address/customer_address.dart';
import 'package:app/src/ui/accounts/currency.dart';
import 'package:app/src/ui/accounts/language/language.dart';
import 'package:app/src/ui/accounts/login/login.dart';
import 'package:app/src/ui/accounts/orders/download_list.dart';
import 'package:app/src/ui/accounts/orders/order_list.dart';
import 'package:app/src/ui/accounts/refer_and_earn.dart';
import 'package:app/src/ui/accounts/settings/settings.dart';
import 'package:app/src/ui/accounts/wallet.dart';
import 'package:app/src/ui/accounts/wishlist.dart';
import 'package:app/src/ui/vendor/ui/stores/stores.dart';
import 'package:app/src/ui/vendor/ui/vendor_app/vendor_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/src/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../src/models/app_state_model.dart';
import '../../../../src/models/category_model.dart';
import '../../../../src/models/vendor/store_model.dart';
import '../../../../src/ui/categories/categories.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/blocks_model.dart';
import '../../../models/post_model.dart';
import '../../../models/product_model.dart';
import '../../pages/post_detail.dart';
import '../../pages/webview.dart';
import '../../products/product_detail/product_detail.dart';
import '../../products/products/products.dart';
import 'alerts.dart';
import 'contact_form.dart';
import 'iframe.dart';

onItemClick(Child data, BuildContext context) async {
  if (data.linkId.isNotEmpty) {
    if (data.linkType == 'category') {
      var filter = new Map<String, dynamic>();
      filter['id'] = data.linkId;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductsWidget(filter: filter, name: data.title)));
    } else if (data.linkType == 'product') {
      Product product =Product.fromJson({'id': int.parse(data.linkId)});
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetail(
                    product: product,
                  )));
    } else if (data.linkType == 'page') {
      var child = Child(linkId: data.linkId, linkType: 'page');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WPPostPage(child: child)));
    } else if (data.linkType == 'pageWebView') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WebViewPage(url: data.linkId)));
    } else if (data.linkType == 'post') {
      var child = Child(linkId: data.linkId, linkType: 'post');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WPPostPage(child: child)));
    } else if (data.linkType == 'store') {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        var store = StoreModel.fromJson({'id': int.parse(data.linkId)});
        var filter = new Map<String, dynamic>();
        return StoreHomePage(store: store);
      }));
    } else if (data.linkType == 'storeList') {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        var filter = new Map<String, dynamic>();
        if(data.storeType != null && data.storeType.isNotEmpty)
        filter['vendor_type'] = data.storeType;
        return StoreListPage(
            filter: filter);
      }));
    } else if (data.linkType == 'webView') {
      if(data.linkId.contains('store-manager') && AppStateModel().user.id == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WebViewPage(url: data.linkId, title: data.title)));
      }
    } else if (data.linkType == 'categories') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Categories()));
    } else if (data.linkType == 'template') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlockPage(child: data)));
    } else if(data.linkType == 'contactForm7') {
      Category category = new Category.fromJson({});
      category.id = int.parse(data.linkId);
      category.name = data.title;
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactForm7(category: category)),
      );
    } else if (data.linkType == 'product_tag') {
      var filter = new Map<String, dynamic>();
      filter['tag'] = data.linkId;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductsWidget(filter: filter, name: data.title)));
    } else if (data.linkType == 'brand') {
      var filter = new Map<String, dynamic>();
      filter['brand'] = data.linkId;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductsWidget(filter: filter, name: data.title)));
    } else if (data.linkType == 'allBrands') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AllBrands(title: data.title)));
    } else if(data.linkType == 'URLLauncher') {
      if (await canLaunchUrl(Uri.parse(data.linkId))) {
        await launchUrl(Uri.parse(data.linkId), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch' + data.linkId;
      }
    } else if(data.linkType == 'IFrame') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => IframePage(url: data.linkId, title: data.title)));
    } else if(data.linkType == 'postNotification') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AlertsPage(categories: AppStateModel().blocks.categories)));
    } else if(data.linkType == 'productNotification') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AlertsPage(categories: AppStateModel().blocks.categories)));
    } else if(data.linkType == 'rateApp') {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      } else {
        if (Platform.isAndroid) {
          final PackageInfo packageInfo = await PackageInfo.fromPlatform();
          final String packageName = packageInfo.packageName;
          launchUrlString('http://play.google.com/store/apps/details?id=' + packageName);
        } else if (Platform.isIOS) {
          launchUrlString('itms-apps://itunes.apple.com/'+ AppStateModel().blocks.settings.appleAppName +'/id' + AppStateModel().blocks.settings.appleAppID);
        }
      }
    } else if(data.linkType == 'shareApp') {
      String projectAppID;
      try {

        final PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final String packageName = packageInfo.packageName;

        if(AppStateModel().blocks.settings.dynamicLink.isNotEmpty) {
          String wwref =  '?wwref=' + AppStateModel().user.id.toString();
          final url = Uri.parse(Config().url + wwref);
          final DynamicLinkParameters parameters = DynamicLinkParameters(
            uriPrefix: AppStateModel().blocks.settings.dynamicLink,
            link: url,
            socialMetaTagParameters:  SocialMetaTagParameters(
              title: packageInfo.appName,
            ),
            androidParameters: AndroidParameters(
              packageName: Config().androidPackageName,
            ),
            iosParameters: IOSParameters(
              bundleId: Config().iosPackageName,
            ),
          );

          final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
          Share.share(dynamicLink.shortUrl.toString());

        } else {

        } if (Platform.isAndroid) {
          Share.share('check out this app http://play.google.com/store/apps/details?id=' + packageName, subject: 'Check this app!');
        } else if (Platform.isIOS) {
          Share.share('check out this app itms-apps://itunes.apple.com/'+ AppStateModel().blocks.settings.appleAppName +'/id' + AppStateModel().blocks.settings.appleAppID, subject: 'Check this app!');
        }

      } on PlatformException {
        projectAppID = 'Failed to get app ID.';
      }
    } else if(data.linkType == 'settings') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
    } else if(data.linkType == 'language') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
    } else if(data.linkType == 'currency') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CurrencyPage()));
    } else if(data.linkType == 'cart') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
    } else if(data.linkType == 'logout') {
      await AppStateModel().logout();
      context.read<Favourites>().clear();
      context.read<ShoppingCart>().getCart();
    } else {
      if(AppStateModel().user.id == 0 && ['login', 'wishList', 'orders', 'wallet', 'rewardPoints', 'address', 'downloads', 'referAndEarn', 'chatRoom', 'chat', 'deleteAccount'].contains(data.linkType)) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      } else if(data.linkType == 'login') {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
        context.read<Favourites>().getWishList();
        context.read<ShoppingCart>().getCart();
      } else if (data.linkType == 'rewardPoints') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RewardPoints();
        }));
      } else if(data.linkType == 'wishList') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WishList()));
      } else if(data.linkType == 'orders') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderList()));
      } else if(data.linkType == 'deleteAccount') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteAccount()));
      } else if(data.linkType == 'wallet') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Wallet()));
      } else if(data.linkType == 'address') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerAddress()));
      } else if(data.linkType == 'downloads'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DownloadsPage()));
      } else if(data.linkType == 'referAndEarn') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReferAndEarn()));
      } else if(data.linkType == 'chatRoom') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RoomsPage()));
      } else if(data.linkType == 'chat') {
        List ids = AppStateModel().blocks.siteSettings.adminUIDs;
        if(ids.length > 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FireBaseChat(otherUserId: AppStateModel().blocks.siteSettings.adminUIDs.first)));
        }
      } else if(data.linkType == 'vendorProducts') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VendorProductList(vendorId: AppStateModel().user.id.toString())));
      } else if(data.linkType == 'vendorOrders') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VendorOrderList(vendorId: AppStateModel().user.id.toString())));
      } else if (data.linkType == 'vendorWebView' || data.linkType == 'accountWebView') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WebViewPage(url: data.linkId, title: data.title)));
      }
    }
  }
}

onCategoryClick(Category category, BuildContext context) {
  var filter = new Map<String, dynamic>();
  filter['id'] = category.id.toString();

  /*Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BookingProductsWidget(filter: filter, name: category.name)));*/

  /*Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              GroceryProductsWidget(filter: filter, name: category.name)));*/


  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProductsWidget(filter: filter, name: category.name)));
}

onPostClick(Post post, BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PostDetail(post: post)));
}

onBrandClick(Category category, BuildContext context) {
  var filter = new Map<String, dynamic>();
  filter['brand'] = category.slug;
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProductsWidget(filter: filter, name: category.name)));
}

onProductClick(Product product, BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetail(
                product: product,
              )));
}

onStoreClick(StoreModel store, BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    var filter = new Map<String, dynamic>();
    return StoreHomePage(store: store);
  }));
  /*Navigator.push(context, MaterialPageRoute(builder: (context) {
    var filter = new Map<String, dynamic>();
    return VendorDetailPage(store: store, filter: filter);
  }));*/
}
