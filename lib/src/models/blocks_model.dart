// To parse this JSON data, do
//
//     final blocksModel = blocksModelFromJson(jsonString);

import 'dart:convert';

import 'package:app/src/models/theme/menu_group_model.dart';
import 'package:app/src/models/post_model.dart';
import 'package:app/src/models/social_link.dart';
import 'package:app/src/models/theme/bottom_navigation_bar.dart';
import 'package:app/src/models/theme/hex_color.dart';
import 'package:app/src/models/theme/tab_bar_style.dart';
import 'package:flutter/material.dart';
import './vendor/store_model.dart';
import '../models/product_model.dart';
import 'category_model.dart';
import 'customer_model.dart';
import 'location_model.dart';
import '../themes/theme.dart';

BlocksModel blocksModelFromJson(String str) => BlocksModel.fromJson(json.decode(str));

class BlocksModel {
  List<Block> blocks;
  Settings settings;
  List<OldChild> pages;
  SiteSettings siteSettings;
  List<Product> featured;
  List<Product> onSale;
  List<Product> bestSelling;
  List<Category> categories;
  List<Category> brands;
  int maxPrice;
  //String loginNonce;
  String currency;
  String language;
  String vendorType;
  List<Language> languages;
  List<Currency> currencies;
  //bool status;
  List<Product> recentProducts;
  Customer user;
  LocaleText localeText;
  List<OldChild> splash;
  Nonce nonce;
  List<StoreModel> stores;
  PageLayout pageLayout;
  Widgets widgets;
  AppTheme theme;
  BlockThemes blockTheme;
  AppTypography typography;
  List<int> wishlist;
  List<Block> productPageLayout;

  BlocksModel({
    required this.blocks,
    required this.settings,
    required this.pages,
    required this.siteSettings,
    required this.featured,
    required this.onSale,
    required this.bestSelling,
    required this.categories,
    required this.brands,
    required this.maxPrice,
    //required this.loginNonce,
    required this.currency,
    required this.languages,
    required this.vendorType,
    required this.currencies,
    //required this.status,
    required this.recentProducts,
    required this.user,
    required this.language,
    required this.localeText,
    required this.splash,
    required this.nonce,
    required this.stores,
    required this.pageLayout,
    required this.widgets,
    required this.theme,
    required this.typography,
    required this.blockTheme,
    required this.wishlist,
    required this.productPageLayout,
  });

  factory BlocksModel.fromJson(Map<String, dynamic> json) => BlocksModel(
    blocks: _nullOrEmptyOrFalse(json["dotapp_blocks"]) ? [] : List<Block>.from(json["dotapp_blocks"].map((x) => Block.fromJson(x))),
    settings: _nullOrEmptyOrFalse(json["dotapp_settings"]) ? Settings.fromJson({}) : Settings.fromJson(json["dotapp_settings"]),
    recentProducts: json["recentProducts"] == null ? [] : List<Product>.from(json["recentProducts"].map((x) => Product.fromJson(x))),
    pages: json["pages"] == null ? [] : List<OldChild>.from(json["pages"].map((x) => OldChild.fromJson(x))),
    siteSettings: json["settings"] == null ? SiteSettings.fromJson({}) : SiteSettings.fromJson(json["settings"]),
    featured: json["featured"] == null ? [] : List<Product>.from(json["featured"].map((x) => Product.fromJson(x))),
    onSale: json["on_sale"] == null ? [] : List<Product>.from(json["on_sale"].map((x) => Product.fromJson(x))),
    bestSelling: json["best_selling"] == null ? [] : List<Product>.from(json["best_selling"].map((x) => Product.fromJson(x))),
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    brands: json["brands"] == null ? [] : List<Category>.from(json["brands"].map((x) => Category.fromJson(x))),
    maxPrice: json["max_price"] == null ? 100000 : json["max_price"],
    //loginNonce: json["login_nonce"] == null ? null : json["login_nonce"],
    currency: json["currency"] == null ? 'USD' : json["currency"],
    vendorType: json["vendorType"] == null ? '' : json["vendorType"],
    languages: json["languages"] == null ? [] : List<Language>.from(json["languages"].map((x) => Language.fromJson(x))),
    currencies: json["currencies"] == null ? [] : List<Currency>.from(json["currencies"].map((x) => Currency.fromJson(x))),
    user: json["user"] == null ? Customer.fromJson({}) : Customer.fromJson(json["user"]),
    localeText: json["locale"] == null ? LocaleText.fromJson({}) : LocaleText.fromJson(json["locale"]),
    language: json["language"] == null ? 'en': json["language"],
    splash: json["splash"] == null || json["splash"] == '' ? [] : List<OldChild>.from(json["splash"].map((x) => OldChild.fromJson(x))),
    nonce: json["nonce"] == null ? Nonce.fromJson({}) : Nonce.fromJson(json["nonce"]),
    stores: json["stores"] == null ? [] : List<StoreModel>.from(json["stores"].map((x) => StoreModel.fromJson(x))),
    pageLayout: json["pageLayout"] == null ? PageLayout.fromJson({}) : PageLayout.fromJson(json["pageLayout"]),
    widgets: json["widgets"] == null ? Widgets.fromJson({}) : Widgets.fromJson(json["widgets"]),
    theme: json["theme"] == null ? AppTheme.fromJson({}) : AppTheme.fromJson(json["theme"]),
    typography: json["typography"] == null ? AppTypography.fromJson({}) : AppTypography.fromJson(json["typography"]),
    blockTheme: json["dotapp_theme"] == null || json["dotapp_theme"] == false ? BlockThemes.fromJson({}) : BlockThemes.fromJson(json['dotapp_theme'] as Map<String, dynamic>),
    wishlist: json["wishlist"] == null ? [] : List<int>.from(json["wishlist"].map((x) => x)),
    productPageLayout: _nullOrEmptyOrFalse(json["productPageLayout"]) ? [] : List<Block>.from(json["productPageLayout"].map((x) => Block.fromJson(x))),
    //status: true,
  );

}

class Settings {
  AppBarStyle appBarStyle;
  PageLayout pageLayout;
  bool multiVendor;
  bool storeTab;
  bool tabBar;
  bool tabLabels;
  bool listingAddToCart;
  bool productFooterAddToCart;
  bool categoriesByLocation;
  bool homePageProducts;
  String distance;
  bool pullToRefresh;
  List<String> labels;
  List<String> popularSearches;
  bool referAndEarn;
  bool blog;
  bool wpml;
  bool webViewCheckout;
  bool multiCurrency;
  bool rewardPoints;
  bool productAddons;
  bool loginBeforeAddToCart;
  bool geoLocation;
  bool downloadProducts;
  bool wallet;
  bool productPageChat;
  bool homePageChat;
  String chatType;
  String vendorChatType;
  String fbPageName;
  String phoneNumber;
  String email;
  bool googleLogin;
  bool fbLogin;
  bool appleLogin;
  bool otpLogin;
  ThemeMode themeMode;
  bool darkThemeSwitch;
  bool customLocation;
  List<CustomLocation> locations;
  bool productRatings;
  bool checkoutLocationPicker;
  String dynamicLink;
  bool googleMapLocation;
  List<MenuGroup> menuGroup;
  BlockThemes menuTheme = BlockThemes.fromJson({});
  String menuBackgroundImage = '';
  bool menuSocialLink = false;
  bool accountSocialLink = false;
  SocialLink socialLink;
  bool customAccount;
  String accountBackgroundImage = '';
  BlockThemes accountTheme = BlockThemes.fromJson({});
  List<MenuGroup> accountGroup;
  bool wishlist;
  BottomNavigationBarModel bottomNavigationBar;
  String dialCode;
  String whatsapp;
  BlockTabBarStyle bottomTabBarStyle;
  bool catalogueMode;
  Child? homeFloatingButton;
  Child? accountFloatingButton;
  bool buyNowButton;
  OrderSettings orderSettings;
  String appleAppName;
  String appleAppID;
  List<Child> floatingButtons;
  String? logo;
  String? darkLogo;
  ProductSettings productSettings;
  bool chatWithVendor;

  Settings({
    required this.appBarStyle,
    required this.pageLayout,
    required this.multiVendor,
    required this.storeTab,
    required this.tabBar,
    required this.tabLabels,
    required this.listingAddToCart,
    required this.productFooterAddToCart,
    required this.categoriesByLocation,
    required this.homePageProducts,
    required this.distance,
    required this.pullToRefresh,
    required this.labels,
    required this.popularSearches,
    required this.referAndEarn,
    required this.email,
    required this.blog,
    required this.wpml,
    required this.webViewCheckout,
    required this.multiCurrency,
    required this.rewardPoints,
    required this.productAddons,
    required this.loginBeforeAddToCart,
    required this.geoLocation,
    required this.downloadProducts,
    required this.wallet,
    required this.productPageChat,
    required this.homePageChat,
    required this.chatType,
    required this.vendorChatType,
    required this.fbPageName,
    required this.phoneNumber,
    required this.googleLogin,
    required this.otpLogin,
    required this.appleLogin,
    required this.fbLogin,
    required this.themeMode,
    required this.darkThemeSwitch,
    required this.customLocation,
    required this.locations,
    required this.productRatings,
    required this.checkoutLocationPicker,
    required this.dynamicLink,
    required this.googleMapLocation,
    required this.menuGroup,
    required this.menuTheme,
    required this.menuBackgroundImage,
    required this.menuSocialLink,
    required this.socialLink,
    required this.accountSocialLink,
    required this.customAccount,
    required this.accountBackgroundImage,
    required this.accountGroup,
    required this.accountTheme,
    required this.wishlist,
    required this.bottomNavigationBar,
    required this.dialCode,
    required this.whatsapp,
    required this.bottomTabBarStyle,
    required this.catalogueMode,
    this.homeFloatingButton,
    this.accountFloatingButton,
    required this.buyNowButton,
    required this.orderSettings,
    required this.appleAppName,
    required this.appleAppID,
    required this.floatingButtons,
    this.logo,
    this.darkLogo,
    required this.productSettings,
    required this.chatWithVendor
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    productSettings: json["productSettings"] == null ? ProductSettings.fromJson({}) : ProductSettings.fromJson(json["productSettings"]),
    appBarStyle: json["appBarStyle"] == null ? AppBarStyle.fromJson({}) : AppBarStyle.fromJson(json["appBarStyle"]),
    pageLayout: json["pageLayout"] == null ? PageLayout.fromJson({}) : PageLayout.fromJson(json["pageLayout"]),
    multiVendor: json["multiVendor"] == null ? false : json["multiVendor"],
    storeTab: json["storeTab"] == null ? false : json["storeTab"],
    tabBar: json["tabBar"] == null ? false : json["tabBar"],
    tabLabels: json["tabLabels"] == null ? false : json["tabLabels"],
    listingAddToCart: json["listingAddToCart"] == null ? false : json["listingAddToCart"],
    productFooterAddToCart: json["productFooterAddToCart"] == null ? false : json["productFooterAddToCart"],
    categoriesByLocation: json["categoriesByLocation"] == null ? false : json["categoriesByLocation"],
    homePageProducts: json["homePageProducts"] == null ? true : json["homePageProducts"],
    distance: json["distance"] == null ? '10' : json["distance"],
    pullToRefresh: json["pullToRefresh"] == null ? false : json["pullToRefresh"],
    labels: json["labels"] == null ? [] : List<String>.from(json["labels"].map((x) => x)),
    popularSearches: json["popularSearches"] == null ? [] : List<String>.from(json["popularSearches"].map((x) => x)),
    referAndEarn: json["referAndEarn"] == null ? false : json["referAndEarn"],
    blog: json["blog"] == null ? false : json["blog"],
    wpml: json["wpml"] == null ? false : json["wpml"],
    webViewCheckout: json["webViewCheckout"] == null ? false : json["webViewCheckout"],
    multiCurrency: json["multiCurrency"] == null ? false : json["multiCurrency"],
    rewardPoints: json["rewardPoints"] == null ? false : json["rewardPoints"],
    productAddons: json["productAddons"] == null ? false : json["productAddons"],
    loginBeforeAddToCart: json["loginBeforeAddToCart"] == null ? false : json["loginBeforeAddToCart"],
    geoLocation: json["geoLocation"] == null ? false : json["geoLocation"],
    downloadProducts: json["downloadProducts"] == null ? false : json["downloadProducts"],
    wallet: json["wallet"] == null ? false : json["wallet"],
    productPageChat: json["productPageChat"] == null ? false : json["productPageChat"],
    homePageChat: json["homePageChat"] == null ? false : json["homePageChat"],
    chatType: json["chatType"] == null ? '' : json["chatType"],
    vendorChatType: json["vendorChatType"] == null ? '' : json["vendorChatType"],
    fbPageName: json["fbPageName"] == null ? '' : json["fbPageName"],
    email: json["email"] == null ? '' : json["email"],
    phoneNumber: json["phoneNumber"] == null ? '' : json["phoneNumber"],
    googleLogin: json["googleLogin"] == null ? false : json["googleLogin"],
    fbLogin: json["fbLogin"] == null ? false : json["fbLogin"],
    otpLogin: json["otpLogin"] == null ? false : json["otpLogin"],
    appleLogin: json["appleLogin"] == null ? false : json["appleLogin"],
    themeMode: json["themeMode"] == 'ThemeMode.light' ? ThemeMode.light : json["themeMode"] == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.system,
    darkThemeSwitch: json["darkThemeSwitch"] == null ? false : json["darkThemeSwitch"],
    customLocation: json["customLocation"] == null ? false : json["customLocation"],
    locations: json["locations"] == null ? [] : List<CustomLocation>.from(json["locations"].map((x) => CustomLocation.fromJson(x))),
    productRatings: json["productRatings"] == null ? false : json["productRatings"],
    checkoutLocationPicker: json["checkoutLocationPicker"] == null ? false : json["checkoutLocationPicker"],
    dynamicLink: json["dynamicLink"] == null ? '' : json["dynamicLink"],
    googleMapLocation: json["googleMapLocation"] == null ? false : json["googleMapLocation"],
    menuGroup: json["menuGroup"] == null ? [] : List<MenuGroup>.from(json["menuGroup"].map((x) => MenuGroup.fromJson(x))),
    menuTheme: _nullOrEmptyOrFalse(json["menuTheme"]) ? BlockThemes.fromJson({}) : BlockThemes.fromJson(json["menuTheme"]),
    menuBackgroundImage: json["menuBackgroundImage"] == null ? '' : json["menuBackgroundImage"],
    menuSocialLink: json["menuSocialLink"] == null ? false : json["menuSocialLink"],
    accountSocialLink: json["accountSocialLink"] == null ? false : json["accountSocialLink"],
    socialLink: json["socialLink"] == null ? SocialLink.fromJson({}) : SocialLink.fromJson(json["socialLink"]),
    customAccount: json["customAccount"] == null ? false : json["customAccount"],
    accountBackgroundImage: json["accountBackgroundImage"] == null ? '' : json["accountBackgroundImage"],
    accountGroup: json["accountGroup"] == null ? [] : List<MenuGroup>.from(json["accountGroup"].map((x) => MenuGroup.fromJson(x))),
    accountTheme: _nullOrEmptyOrFalse(json["accountTheme"]) ? BlockThemes.fromJson({}) : BlockThemes.fromJson(json["accountTheme"]),
    wishlist: json["wishlist"] == null ? true : json["wishlist"],
    bottomNavigationBar: _nullOrEmptyOrFalse(json["bottomNavigationBar"]) ? BottomNavigationBarModel.fromJson({}) : BottomNavigationBarModel.fromJson(json["bottomNavigationBar"]),
    dialCode: json["dialCode"] == null ? '+1' : json["dialCode"],
    whatsapp: json["whatsapp"] == null ? '' : json["whatsapp"],
    bottomTabBarStyle: json["bottomTabBarStyle"] == null ? BlockTabBarStyle.fromJson({}) : BlockTabBarStyle.fromJson(json["bottomTabBarStyle"]),
    catalogueMode: json["catalogueMode"] == true ? true : false,
    homeFloatingButton: json["homeFloatingButton"] == null ? null : Child.fromJson(json["homeFloatingButton"]),
    accountFloatingButton: json["accountFloatingButton"] == null ? null : Child.fromJson(json["accountFloatingButton"]),
    buyNowButton: json["buyNowButton"] == false ? false :  true,
    orderSettings: json["orderSettings"] == null ? OrderSettings.fromJson({}) : OrderSettings.fromJson(json["orderSettings"]),
    appleAppName: json["appleAppName"] == null ? '' : json["appleAppName"],
    appleAppID: json["appleAppID"] == null ? '' : json["appleAppID"],
    floatingButtons: json["floatingButtons"] == null ? [] : List<Child>.from(json["floatingButtons"].map((x) => Child.fromJson(x))),
    logo: json["logo"] == null ? null : json["logo"],
    darkLogo: json["darkLogo"] == null ? null : json["darkLogo"],
    chatWithVendor: json["chatWithVendor"] == false ? false :  true,
  );
}

class ProductSettings {
  ProductSettings({
    required this.imageFit,
  });

  BoxFit imageFit;

  factory ProductSettings.fromJson(Map<String, dynamic> json) => ProductSettings(
    imageFit: json["imageFit"] == null ? BoxFit.cover : getBoxFit(json["imageFit"]),
  );
}

class OrderSettings {
  OrderSettings({
    required this.cancelOrderStatus,
    required this.refundOrderStatus,
    required this.supportOrderStatus,
  });

  List<String> cancelOrderStatus;
  List<String> refundOrderStatus;
  List<String> supportOrderStatus;

  factory OrderSettings.fromJson(Map<String, dynamic> json) => OrderSettings(
    cancelOrderStatus: json["cancelOrderStatus"] == null ? [] : List<String>.from(json["cancelOrderStatus"].map((x) => x)),
    refundOrderStatus: json["refundOrderStatus"] == null ? []: List<String>.from(json["refundOrderStatus"].map((x) => x)),
    supportOrderStatus: json["supportOrderStatus"] == null ? [] : List<String>.from(json["supportOrderStatus"].map((x) => x)),
  );
}

class AppBarStyle {

  String appBarType;
  bool cart;
  bool searchIcon;
  bool searchBar;
  bool location;
  bool barcode;
  bool logo;
  bool drawer;

  AppBarStyle({
    required this.appBarType,
    required this.cart,
    required this.searchIcon,
    required this.searchBar,
    required this.location,
    required this.barcode,
    required this.logo,
    required this.drawer
  });

  factory AppBarStyle.fromJson(Map<String, dynamic> json) => AppBarStyle(
    appBarType: json["appBarType"] == null ? 'STYLEDEFAULT' : json["appBarType"],
    cart: json["cart"] == null ? true : json["cart"],
    searchIcon: json["searchIcon"] == null ? false : json["searchIcon"],
    searchBar: json["searchBar"] == null ? false : json["searchBar"],
    location: json["location"] == null ? false : json["location"],
    barcode: json["barcode"] == null ? false : json["barcode"],
    logo: json["logo"] == null ? false : json["logo"],
    drawer: json["drawer"] == null ? false : json["drawer"],
  );
}

class Nonce {
  Nonce({
    required this.wooWalletTopup,
    required this.wcfmSettings,
    required this.wcfmEnquiry,
    required this.wcfmAjaxNonce
  });

  String wooWalletTopup;
  String wcfmSettings;
  String wcfmEnquiry;
  String wcfmAjaxNonce;

  factory Nonce.fromJson(Map<String, dynamic> json) => Nonce(
    wooWalletTopup: json["woo_wallet_topup"] == null ? '' : json["woo_wallet_topup"],
    wcfmSettings: json["wcfm_settings"] == null ? '' : json["wcfm_settings"],
    wcfmEnquiry: json["wcfm_enquiry"] == null ? '' : json["wcfm_enquiry"],
    wcfmAjaxNonce: json["wcfm_ajax_nonce"] == null ? '' : json["wcfm_ajax_nonce"],
  );
}

class LocaleText {
  String home;
  String companyName;
  String category;
  String categories;
  String cart;
  String addToCart;
  String buyNow;
  String outOfStock;
  String inStock;
  String account;
  String product;
  String products;
  String signIn;
  String signUp;
  String orders;
  String order;
  String wishlist;
  String address;
  String settings;
  String localeTextContinue;
  String save;
  String filter;
  String apply;
  String featured;
  String newArrivals;
  String sales;
  String shareApp;
  String username;
  String password;
  String firstName;
  String lastName;
  String phoneNumber;
  String address2;
  String email;
  String city;
  String pincode;
  String location;
  String select;
  String selectLocation;
  String states;
  String state;
  String country;
  String countires;
  String relatedProducts;
  String justForYou;
  String youMayAlsoLike;
  String billing;
  String shipping;
  String discount;
  String subtotal;
  String total;
  String tax;
  String fee;
  String orderSummary;
  String thankYou;
  String payment;
  String paymentMethod;
  String shippingMethod;
  String billingAddress;
  String shippingAddress;
  String noOrders;
  String noMoreOrders;
  String noWishlist;
  String noMoreWishlist;
  String localeTextNew;
  String otp;
  String reset;
  String resetPassword;
  String newPassword;
  String requiredField;
  String pleaseEnter;
  String pleaseEnterUsername;
  String pleaseEnterCompanyName;
  String pleaseEnterPassword;
  String pleaseEnterFirstName;
  String pleaseEnterLastName;
  String pleaseEnterCity;
  String pleaseEnterPincode;
  String pleaseEnterState;
  String pleaseEnterValidEmail;
  String pleaseEnterPhoneNumber;
  String pleaseEnterOtp;
  String pleaseEnterAddress;
  String logout;
  String pleaseWait;
  String language;
  String currency;
  String forgotPassword;
  String alreadyHaveAnAccount;
  String dontHaveAnAccount;
  String theme;
  String light;
  String dark;
  String system;
  String noProducts;
  String noMoreProducts;
  String chat;
  String call;
  String info;
  String edit;
  String welcome;
  String checkout;
  String items;
  String couponCode;
  String pleaseEnterCouponCode;
  String emptyCart;
  String youOrderHaveBeenReceived;
  String thankYouForShoppingWithUs;
  String thankYouOrderIdIs;
  String youWillReceiveAConfirmationMessage;
  String add;
  String quantity;
  String qty;
  String search;
  String reviews;
  String variations;
  String sku;
  String description;
  String regularPrice;
  String salesPrice;
  String stockStatus;
  String backOrder;
  String options;
  String message;
  String contacts;
  String name;
  String type;
  String status;
  String long;
  String simple;
  String grouped;
  String external;
  String private;
  String draft;
  String pending;
  String publish;
  String visible;
  String variable;
  String catalog;
  String hidden;
  String notify;
  String yes;
  String no;
  String weight;
  String purchaseNote;
  String submit;
  String catalogVisibility;
  String all;
  String stores;
  String wallet;
  String cancel;
  String searchProducts;
  String searchStores;
  String noResults;
  String thankYouForYourReview;
  String pleaseEnterMessage;
  String yourReview;
  String pleaseSelectYourRating;
  String whatIsYourRate;
  String ok;
  String or;
  String sendOtp;
  String balance;
  String debit;
  String credit;
  String addBalance;
  String enterRechargeAmount;
  String pleaseEnterRechargeAmount;
  String attributes;
  String noConversationsYet;
  String sale;
  String inValidCode;
  String verifyNumber;
  String inValidNumber;
  String enterOtp;
  String verifyOtp;
  String orderNote;
  String bestSelling;
  String viewAll;
  String resendOTP;
  String isRequired;
  String price;
  String writeYourReview;
  String thankYouForYourMessage;
  String date;
  String priceHighToLow;
  String priceLowToHigh;
  String popular;
  String rating;
  String processing;
  String onHold;
  String completed;
  String pendingPayment;
  String failed;
  String refunded;
  String cancelled;
  String useCurrentLocation;
  String searchYourPlace;
  String weAreNotInYourArea;
  String changeYourLocation;
  String tapToSelectThisLocation;
  String nearbyPlaces;
  String becomeVendor;
  String notifications;
  String referAndEarn;
  String downloads;
  String pleaseSelectLanguage;
  String searchIn;
  String enterOtpThatWasSentTo;
  String didNotReceiveCode;
  String shipped;
  String ordered;
  String delivered;
  String askAQuestion;
  String coupons;
  String rewardPoints;
  String paymentError;
  String remove;
  String popularSearches;
  String support;
  String refund;
  String callDeliveryBoy;
  String manageStock;
  String stockQuantity;

  String copy;
  String share;
  String shareAndEarnMoney;
  String from;
  String to;
  String registerAsVendor;
  String shopName;
  String shopUrl;
  String schedule;

  String priority;
  String amount;
  String requestReason;
  String yourRequestSubmitted;
  String valueNotMoreThan;

  String generalQuery;
  String suggestion;
  String deliveryIssue;
  String damageItemReceived;
  String wrongItemReceived;

  String normal;
  String low;
  String medium;
  String high;
  String urgent;
  String critical;

  String deliveryIn10Minutes;

  String deleteAccountMessage;

  String deleteAccount;
  String off;

  LocaleText({
    required this.home,
    required this.companyName,
    required this.category,
    required this.categories,
    required this.cart,
    required this.addToCart,
    required this.buyNow,
    required this.outOfStock,
    required this.inStock,
    required this.account,
    required this.product,
    required this.products,
    required this.signIn,
    required this.signUp,
    required this.orders,
    required this.order,
    required this.wishlist,
    required this.address,
    required this.settings,
    required this.localeTextContinue,
    required this.save,
    required this.filter,
    required this.apply,
    required this.featured,
    required this.newArrivals,
    required this.sales,
    required this.shareApp,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address2,
    required this.email,
    required this.city,
    required this.pincode,
    required this.location,
    required this.select,
    required this.selectLocation,
    required this.states,
    required this.state,
    required this.country,
    required this.countires,
    required this.relatedProducts,
    required this.justForYou,
    required this.youMayAlsoLike,
    required this.billing,
    required this.shipping,
    required this.discount,
    required this.subtotal,
    required this.total,
    required this.tax,
    required this.fee,
    required this.orderSummary,
    required this.thankYou,
    required this.payment,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.billingAddress,
    required this.shippingAddress,
    required this.noOrders,
    required this.noMoreOrders,
    required this.noWishlist,
    required this.noMoreWishlist,
    required this.localeTextNew,
    required this.otp,
    required this.reset,
    required this.resetPassword,
    required this.newPassword,
    required this.requiredField,
    required this.pleaseEnter,
    required this.pleaseEnterUsername,
    required this.pleaseEnterCompanyName,
    required this.pleaseEnterPassword,
    required this.pleaseEnterFirstName,
    required this.pleaseEnterLastName,
    required this.pleaseEnterCity,
    required this.pleaseEnterPincode,
    required this.pleaseEnterState,
    required this.pleaseEnterValidEmail,
    required this.pleaseEnterPhoneNumber,
    required this.pleaseEnterOtp,
    required this.pleaseEnterAddress,
    required this.logout,
    required this.pleaseWait,
    required this.language,
    required this.currency,
    required this.forgotPassword,
    required this.alreadyHaveAnAccount,
    required this.dontHaveAnAccount,
    required this.theme,
    required this.light,
    required this.dark,
    required this.system,
    required this.noProducts,
    required this.noMoreProducts,
    required this.chat,
    required this.call,
    required this.info,
    required this.edit,
    required this.welcome,
    required this.checkout,
    required this.items,
    required this.couponCode,
    required this.pleaseEnterCouponCode,
    required this.emptyCart,
    required this.youOrderHaveBeenReceived,
    required this.thankYouForShoppingWithUs,
    required this.thankYouOrderIdIs,
    required this.youWillReceiveAConfirmationMessage,
    required this.add,
    required this.quantity,
    required this.qty,
    required this.search,
    required this.reviews,
    required this.variations,
    required this.sku,
    required this.description,
    required this.regularPrice,
    required this.salesPrice,
    required this.stockStatus,
    required this.backOrder,
    required this.options,
    required this.message,
    required this.contacts,
    required this.name,
    required this.type,
    required this.status,
    required this.long,
    required this.simple,
    required this.grouped,
    required this.external,
    required this.private,
    required this.draft,
    required this.pending,
    required this.publish,
    required this.visible,
    required this.variable,
    required this.catalog,
    required this.hidden,
    required this.notify,
    required this.yes,
    required this.no,
    required this.weight,
    required this.purchaseNote,
    required this.submit,
    required this.catalogVisibility,
    required this.all,
    required this.stores,
    required this.wallet,
    required this.cancel,
    required this.searchProducts,
    required this.searchStores,
    required this.noResults,
    required this.thankYouForYourReview,
    required this.pleaseEnterMessage,
    required this.yourReview,
    required this.pleaseSelectYourRating,
    required this.whatIsYourRate,
    required this.ok,
    required this.or,
    required this.sendOtp,
    required this.attributes,
    required this.noConversationsYet,
    required this.balance,
    required this.addBalance,
    required this.enterRechargeAmount,
    required this.pleaseEnterRechargeAmount,
    required this.credit,
    required this.debit,
    required this.sale,
    required this.inValidCode,
    required this.verifyNumber,
    required this.inValidNumber,
    required this.enterOtp,
    required this.verifyOtp,
    required this.orderNote,
    required this.bestSelling,
    required this.viewAll,
    required this.resendOTP,
    required this.isRequired,
    required this.price,
    required this.writeYourReview,
    required this.thankYouForYourMessage,
    required this.date,
    required this.priceHighToLow,
    required this.priceLowToHigh,
    required this.rating,
    required this.popular,
    required this.pendingPayment,
    required this.completed,
    required this.processing,
    required this.onHold,
    required this.cancelled,
    required this.failed,
    required this.refunded,
    required this.useCurrentLocation,
    required this.searchYourPlace,
    required this.weAreNotInYourArea,
    required this.changeYourLocation,
    required this.tapToSelectThisLocation,
    required this.nearbyPlaces,
    required this.becomeVendor,
    required this.notifications,
    required this.referAndEarn,
    required this.downloads,
    required this.pleaseSelectLanguage,
    required this.searchIn,
    required this.enterOtpThatWasSentTo,
    required this.didNotReceiveCode,
    required this.ordered,
    required this.shipped,
    required this.delivered,
    required this.askAQuestion,
    required this.coupons,
    required this.rewardPoints,
    required this.paymentError,
    required this.remove,
    required this.popularSearches,
    required this.support,
    required this.refund,
    required this.callDeliveryBoy,
    required this.manageStock,
    required this.stockQuantity,

    required this.copy,
    required this.share,
    required this.shareAndEarnMoney,
    required this.from,
    required this.to,
    required this.registerAsVendor,
    required this.shopName,
    required this.shopUrl,
    required this.schedule,
    required this.priority,
    required this.amount,
    required this.requestReason,
    required this.yourRequestSubmitted,
    required this.valueNotMoreThan,

    required this.generalQuery,
    required this.suggestion,
    required this.deliveryIssue,
    required this.damageItemReceived,
    required this.wrongItemReceived,
    required this.normal,
    required this.low,
    required this.medium,
    required this.high,
    required this.urgent,
    required this.critical,
    required this.deliveryIn10Minutes,
    required this.deleteAccount,
    required this.deleteAccountMessage,
    required this.off,
  });

  factory LocaleText.fromJson(Map<String, dynamic> json) => LocaleText(
    home: json["Home"] == null ?"Home": json["Home"],
    companyName: json["Company Name"] == null ?"Company Name": json["Company Name"],
    category: json["Category"] == null ?"Category": json["Category"],
    categories: json["Categories"] == null ?"Categories": json["Categories"],
    cart: json["Cart"] == null ?"Cart": json["Cart"],
    addToCart: json["Add to cart"] == null ?"Add to cart": json["Add to cart"],
    buyNow: json["Buy now"] == null ?"Buy now": json["Buy now"],
    outOfStock: json["Out of stock"] == null ?"Out of stock": json["Out of stock"],
    inStock: json["In stock"] == null ?"In stock": json["In stock"],
    account: json["Account"] == null ?"Account": json["Account"],
    product: json["Product"] == null ?"Product": json["Product"],
    products: json["Products"] == null ?"Products": json["Products"],
    signIn: json["Sign In"] == null ?"Sign In": json["Sign In"],
    signUp: json["Sign Up"] == null ?"Sign Up": json["Sign Up"],
    orders: json["Orders"] == null ?"Orders": json["Orders"],
    order: json["Order"] == null ?"Order": json["Order"],
    wishlist: json["Wishlist"] == null ?"Wishlist": json["Wishlist"],
    address: json["Address"] == null ?"Address": json["Address"],
    settings: json["Settings"] == null ?"Settings": json["Settings"],
    localeTextContinue: json["Continue"] == null ?"Continue": json["Continue"],
    save: json["Save"] == null ?"Save": json["Save"],
    filter: json["Filter"] == null ?"Filter": json["Filter"],
    apply: json["Apply"] == null ?"Apply": json["Apply"],
    featured: json["Featured"] == null ?"Featured": json["Featured"],
    newArrivals: json["New Arrivals"] == null ?"New Arrivals": json["New Arrivals"],
    sales: json["Sales"] == null ?"Sales": json["Sales"],
    shareApp: json["Share app"] == null ?"Share app": json["Share app"],
    username: json["Username"] == null ?"Username/Email": json["Username"],
    password: json["Password"] == null ?"Password": json["Password"],
    firstName: json["First Name"] == null ?"First Name": json["First Name"],
    lastName: json["Last Name"] == null ?"Last Name": json["Last Name"],
    phoneNumber: json["Phone Number"] == null ?"Phone Number": json["Phone Number"],
    address2: json["Address 2"] == null ?"Address 2": json["Address 2"],
    email: json["Email"] == null ?"Email": json["Email"],
    city: json["City"] == null ?"City": json["City"],
    pincode: json["Pincode"] == null ?"Pincode": json["Pincode"],
    location: json["Location"] == null ?"Location": json["Location"],
    select: json["Select"] == null ?"Select": json["Select"],
    selectLocation: json["Select location"] == null ?"Select location": json["Select location"],
    states: json["States"] == null ?"States": json["States"],
    state: json["State"] == null ?"State": json["State"],
    country: json["Country"] == null ?"Country": json["Country"],
    countires: json["Countires"] == null ?"Countires": json["Countires"],
    relatedProducts: json["Related Products"] == null ?"Related Products": json["Related Products"],
    justForYou: json["Just for you"] == null ?"Just for you": json["Just for you"],
    youMayAlsoLike: json["You may also like"] == null ?"You may also like": json["You may also like"],
    billing: json["Billing"] == null ?"Billing": json["Billing"],
    shipping: json["Shipping"] == null ?"Shipping": json["Shipping"],
    discount: json["Discount"] == null ?"Discount": json["Discount"],
    subtotal: json["Subtotal"] == null ?"Subtotal": json["Subtotal"],
    total: json["Total"] == null ?"Total": json["Total"],
    tax: json["Tax"] == null ?"Tax": json["Tax"],
    fee: json["Fee"] == null ?"Fee": json["Fee"],
    orderSummary: json["Order summary"] == null ?"Order summary": json["Order summary"],
    thankYou: json["Thank You"] == null ?"Thank You": json["Thank You"],
    payment: json["Payment"] == null ?"Payment": json["Payment"],
    paymentMethod: json["Payment method"] == null ?"Payment method": json["Payment method"],
    shippingMethod: json["Shipping method"] == null ?"Shipping method": json["Shipping method"],
    billingAddress: json["Billing address"] == null ?"Billing address": json["Billing address"],
    shippingAddress: json["Shipping address"] == null ?"Shipping address": json["Shipping address"],
    noOrders: json["No orders"] == null ?"No orders": json["No orders"],
    noMoreOrders: json["No more orders"] == null ?"No more orders": json["No more orders"],
    noWishlist: json["No wishlist"] == null ?"No wishlist": json["No wishlist"],
    noMoreWishlist: json["No more wishlist"] == null ?"No more wishlist": json["No more wishlist"],
    localeTextNew: json["New"] == null ?"New": json["New"],
    otp: json["OTP"] == null ?"OTP": json["OTP"],
    reset: json["Reset"] == null ?"Reset": json["Reset"],
    resetPassword: json["Reset password"] == null ?"Reset password": json["Reset password"],
    newPassword: json["New password"] == null ?"New password": json["New password"],
    requiredField: json["Required Field"] == null ?"Required Field": json["Required Field"],
    pleaseEnter: json["Please enter"] == null ?"Please enter": json["Please enter"],
    pleaseEnterUsername: json["Please enter username"] == null ?"Please enter username": json["Please enter username"],
    pleaseEnterCompanyName: json["Please enter company name"] == null ?"Please enter company name": json["Please enter company name"],
    pleaseEnterPassword: json["Please enter password"] == null ?"Please enter password": json["Please enter password"],
    pleaseEnterFirstName: json["Please enter first name"] == null ?"Please enter first name": json["Please enter first name"],
    pleaseEnterLastName: json["Please enter last name"] == null ?"Please enter last name": json["Please enter last name"],
    pleaseEnterCity: json["Please enter city"] == null ?"Please enter city": json["Please enter city"],
    pleaseEnterPincode: json["Please enter pincode"] == null ?"Please enter pincode": json["Please enter pincode"],
    pleaseEnterState: json["Please enter state"] == null ?"Please enter state": json["Please enter state"],
    pleaseEnterValidEmail: json["Please enter valid email"] == null ?"Please enter valid email": json["Please enter valid email"],
    pleaseEnterPhoneNumber: json["Please enter phone number"] == null ?"Please enter phone number": json["Please enter phone number"],
    pleaseEnterOtp: json["Please enter otp"] == null ?"Please enter otp": json["Please enter otp"],
    pleaseEnterAddress: json["Please enter address"] == null ?"Please enter address": json["Please enter address"],
    logout: json["Logout"] == null ?"Logout": json["Logout"],
    pleaseWait: json["Please wait"] == null ?"Please wait": json["Please wait"],
    language: json["Language"] == null ?"Language": json["Language"],
    currency: json["Currency"] == null ?"Currency": json["Currency"],
    forgotPassword: json["Forgot password"] == null ?"Forgot password?": json["Forgot password"],
    alreadyHaveAnAccount: json["Already have an account"] == null ?"Already have an account?": json["Already have an account"],
    dontHaveAnAccount: json["Dont have an account"] == null ?"Don't have an account?": json["Dont have an account"],
    theme: json["Theme"] == null ?"Theme": json["Theme"],
    light: json["Light"] == null ?"Light": json["Light"],
    dark: json["Dark"] == null ?"Dark": json["Dark"],
    system: json["System"] == null ?"System": json["System"],
    noProducts: json["No products"] == null ?"No products": json["No products"],
    noMoreProducts: json["No more products"] == null ?"No more products": json["No more products"],
    chat: json["Chat"] == null ?"Chat": json["Chat"],
    call: json["Call"] == null ?"Call": json["Call"],
    info: json["Info"] == null ?"Info": json["Info"],
    edit: json["Edit"] == null ?"Edit": json["Edit"],
    welcome: json["Welcome"] == null ?"Welcome": json["Welcome"],
    checkout: json["Checkout"] == null ?"Checkout": json["Checkout"],
    items: json["Items"] == null ?"Items": json["Items"],
    couponCode: json["Coupon code"] == null ?"Coupon code": json["Coupon code"],
    pleaseEnterCouponCode: json["Please enter coupon code"] == null ?"Please enter coupon code": json["Please enter coupon code"],
    emptyCart: json["Empty Cart"] == null ?"Empty Cart": json["Empty Cart"],
    youOrderHaveBeenReceived: json["You order have been received"] == null ?"You order have been received": json["You order have been received"],
    thankYouForShoppingWithUs: json["Thank you for shopping with us"] == null ?"Thank you for shopping with us": json["Thank you for shopping with us"],
    thankYouOrderIdIs: json["Thank you order id is"] == null ?"Thank you order id is": json["Thank you order id is"],
    youWillReceiveAConfirmationMessage: json["You will receive a confirmation message"] == null ?"You will receive a confirmation message": json["You will receive a confirmation message"],
    add: json["Add"] == null ?"Add": json["Add"],
    quantity: json["Quantity"] == null ?"Quantity": json["Quantity"],
    qty: json["QTY"] == null ?"QTY": json["QTY"],
    search: json["Search"] == null ?"Search": json["Search"],
    reviews: json["Reviews"] == null ?"Reviews": json["Reviews"],
    variations: json["Variations"] == null ?"Variations": json["Variations"],
    sku: json["SKU"] == null ?"SKU": json["SKU"],
    description: json["Description"] == null ?"Description": json["Description"],
    regularPrice: json["Regular price"] == null ?"Regular price": json["Regular price"],
    salesPrice: json["Sales price"] == null ?"Sales price": json["Sales price"],
    stockStatus: json["Stock status"] == null ?"Stock status": json["Stock status"],
    backOrder: json["Back order"] == null ?"Back order": json["Back order"],
    options: json["Options"] == null ?"Options": json["Options"],
    message: json["Message"] == null ?"Message": json["Message"],
    contacts: json["Contacts"] == null ?"Contacts": json["Contacts"],
    name: json["Name"] == null ?"Name": json["Name"],
    type: json["Type"] == null ?"Type": json["Type"],
    status: json["Status"] == null ?"Status": json["Status"],
    long: json["Long"] == null ?"Long": json["Long"],
    grouped: json["Grouped"] == null ?"Grouped": json["Grouped"],
    simple: json["Simple"] == null ?"Simple": json["Simple"],
    external: json["External"] == null ?"External": json["External"],
    private: json["Private"] == null ?"Private": json["Private"],
    draft: json["Draft"] == null ?"Draft": json["Draft"],
    pending: json["Pending"] == null ?"Pending": json["Pending"],
    publish: json["Publish"] == null ?"Publish": json["Publish"],
    visible: json["Visible"] == null ?"Visible": json["Visible"],
    variable: json["Variable"] == null ?"Variable": json["Variable"],
    catalog: json["Catalog"] == null ?"Catalog": json["Catalog"],
    hidden: json["Hidden"] == null ?"Hidden": json["Hidden"],
    notify: json["Notify"] == null ?"Notify": json["Notify"],
    yes: json["Yes"] == null ?"Yes": json["Yes"],
    no: json["No"] == null ?"No": json["No"],
    ok: json["Ok"] == null ?"Ok": json["Ok"],
    weight: json["Weight"] == null ?"Weight": json["Weight"],
    purchaseNote: json["Purchase Note"] == null ?"Purchase Note": json["Purchase Note"],
    submit: json["Submit"] == null ?"Submit": json["Submit"],
    catalogVisibility: json["Catalog Visibility"] == null ?"Catalog Visibility": json["Catalog Visibility"],
    all: json["All"] == null ?"All": json["All"],
    stores: json["Stores"] == null ?"Stores": json["Stores"],
    wallet: json["Wallet"] == null ?"Wallet": json["Wallet"],
    cancel: json["Cancel"] == null ?"Cancel": json["Cancel"],
    searchProducts: json["Search Products"] == null ?"Search Products": json["Search Products"],
    searchStores: json["Search Stores"] == null ?"Search Stores": json["Search Stores"],
    noResults: json["No Results"] == null ?"No Results": json["No Results"],
    thankYouForYourReview: json["Thank you for your review"] == null ?"Thank you for your review": json["Thank you for your review"],
    pleaseEnterMessage: json["Please enter message"] == null ?"Please enter message": json["Please enter message"],
    yourReview: json["Your review"] == null ?"Your review": json["Your review"],
    pleaseSelectYourRating: json["Please enter your review"] == null ?"Please enter your review": json["Please enter your review"],
    whatIsYourRate: json["What is your rate"] == null ?"What is your rate": json["What is your rate"],
    or: json["Or"] == null ?"Or": json["Or"],
    sendOtp: json["Send OTP"] == null ?"Send OTP": json["Send OTP"],
    attributes: json["Attributes"] == null ?"Attributes": json["Attributes"],
    noConversationsYet: json["No conversations yet"] == null ?"No conversations yet": json["No conversations yet"],
    balance: json["Balance"] == null ?"Balance": json["Balance"],
    debit: json["Debit"] == null ?"Debit": json["Debit"],
    credit: json["Credit"] == null ?"Credit": json["Credit"],
    addBalance: json["Add balance"] == null ?"Add balance": json["Add balance"],
    enterRechargeAmount: json["Enter recharge amount"] == null ?"Enter recharge amount": json["Enter recharge amount"],
    pleaseEnterRechargeAmount: json["Please enter recharge amount"] == null ?"Please enter recharge amount": json["Please enter recharge amount"],
    sale: json["Sale"] == null ?"Sale": json["Sale"],
    inValidCode: json["Invalid Code"] == null ?"The verification code used is invalid": json["Invalid Code"],
    verifyNumber: json["Verify Number"] == null ?"Verify Number": json["Verify Number"],
    inValidNumber: json["Invalid Number"] == null ?"The provided phone number is not valid.": json["Invalid Number"],
    enterOtp: json["Enter OTP"] == null ?"Enter OTP": json["Enter OTP"],
    verifyOtp: json["Verify OTP"] == null ?"Verify OTP": json["Verify OTP"],
    orderNote: json["Order Note"] == null ?"Order Note": json["Order Note"],
    bestSelling: json["Best Selling"] == null ?"Best Selling": json["Best Selling"],
    viewAll: json["View All"] == null ?"View All": json["View All"],
    resendOTP: json["resend OTP"] == null ?"Resend OTP": json["resend OTP"],
    isRequired: json["is required"] == null ?"is required": json["is required"],
    price: json["Price"] == null ?"Price": json["Price"],
    writeYourReview: json["Write Your Review"] == null ?"Write Your Review": json["Write Your Review"],
    thankYouForYourMessage: json["Thank you for your Message"] == null ?"Thank you for your Message": json["Thank you for your Message"],
    date: json["Date"] == null ?"Date": json["Date"],
    priceHighToLow: json["Price High to Low"] == null ?"Price High to Low": json["Price High to Low"],
    priceLowToHigh: json["Price Low to High"] == null ?"Price Low to High": json["Price Low to High"],
    popular: json["Popular"] == null ?"Popular": json["Popular"],
    rating: json["Rating"] == null ?"Rating": json["Rating"],
    processing: json["processing"] == null ?"Rrocessing": json["processing"],
    completed: json["completed"] == null ?"Completed": json["completed"],
    pendingPayment: json["pendingPayment"] == null ?"Pending Payment": json["pendingPayment"],
    onHold: json["onHold"] == null ?"On Hold": json["onHold"],
    refunded: json["refunded"] == null ?"Refunded": json["refunded"],
    cancelled: json["cancelled"] == null ?"Cancelled": json["cancelled"],
    failed: json["failed"] == null ?"Failed": json["failed"],
    useCurrentLocation: json["Use current location"] == null ?"Use current location": json["Use current location"],
    searchYourPlace: json["Search your place"] == null ?"Search your place": json["Search your place"],
    weAreNotInYourArea: json["Sorry! We are not in your area. We will be there soon!"] == null ?"Sorry! We are not in your area. We will be there soon!": json["Sorry! We are not in your area. We will be there soon!"],
    changeYourLocation: json["Change your location"] == null ?"Change your location": json["Change your location"],
    tapToSelectThisLocation: json["Tap to select this location"] == null ?"Tap to select this location": json["Tap to select this location"],
    nearbyPlaces: json["Nearby Places"] == null ?"Nearby Places": json["Nearby Places"],
    becomeVendor: json["Become a vendor"] == null ?"Become a vendor": json["Become a vendor"],
    notifications: json["notifications"] == null ?"Notifications": json["notifications"],
    referAndEarn: json["Refer and earn"] == null ?"Refer and earn": json["Refer and earn"],
    downloads: json["Downloads"] == null ?"Downloads": json["Downloads"],
    pleaseSelectLanguage: json["pleaseSelectLanguage"] == null ?"Please Select Language": json["pleaseSelectLanguage"],
    searchIn: json["searchIn"] == null ?"Search in": json["Search In"],
    enterOtpThatWasSentTo: json["Enter the code that was sent to"] == null ?"Enter the code that was sent to": json["Enter the code that was sent to"],
    didNotReceiveCode: json["Did not receive code"] == null ?"Did not receive code?": json["Did not receive code"],
    ordered: json["ordered"] == null ?"Ordered": json["ordered"],
    shipped: json["shipped"] == null ?"Shipped": json["shipped"],
    delivered: json["delivered"] == null ?"Delivered": json["delivered"],
    askAQuestion: json["askAQuestion"] == null ?"Ask A Question": json["askAQuestion"],
    coupons: json["Coupons"] == null ?"Coupons": json["Coupons"],
    rewardPoints: json["rewardPoints"] == null ?"Reward points": json["rewardPoints"],
    paymentError: json["paymentError"] == null ?"Sorry, we are unable to process your payment at this time. Please retry later.": json["paymentError"],
    remove: json["remove"] == null ?"Remove": json["remove"],
    popularSearches: json["popularSearches"] == null ?"Popular searches": json["popularSearches"],
    support: json["Support"] == null ?"Support": json["Support"],
    refund: json["Refund"] == null ?"Refund": json["Refund"],
    callDeliveryBoy: json["Call Delivery Boy"] == null ?"Call Delivery Boy": json["Call Delivery Boy"],
    manageStock: json["Manage Stock"] == null ?"Manage Stock": json["Manage Stock"],
    stockQuantity: json["Stock Quantity"] == null ?"Stock Quantity": json["Stock Quantity"],

    copy: json["Copy"] == null ?"Copy": json["Copy"],
    shareAndEarnMoney: json["Share and earn money"] == null ?"Share and earn money": json["Share and earn money"],
    share: json["Share"] == null ?"Share": json["Share"],
    from: json["From"] == null ?"From": json["From"],
    to: json["To"] == null ?"To": json["To"],
    registerAsVendor: json["Register as Vendor"] == null ?"Register as Vendor": json["Register as Vendor"],
    shopName: json["Shop Name"] == null ?"Shop Name": json["Shop Name"],
    shopUrl: json["Shop Url"] == null ?"Shop Url": json["Shop Url"],
    schedule: json["Schedule"] == null ?"Schedule": json["Schedule"],
    priority: json["Priority"] == null ?"Priority": json["Priority"],
    amount: json["Amount"] == null ?"Amount": json["Amount"],
    requestReason: json["Request reason"] == null ?"Request reason": json["Request reason"],
    yourRequestSubmitted: json["Your request has been submitted"] == null ?"Your request has been submitted": json["Your request has been submitted"],
    valueNotMoreThan: json["Value should not be more than"] == null ?"Value should not be more than": json["Value should not be more than"],
    generalQuery: json["General Query"] == null ?"General Query": json["General Query"],
    suggestion: json["Suggestion"] == null ?"Suggestion": json["Suggestion"],
    deliveryIssue: json["Delivery Issue"] == null ?"Delivery Issue": json["Delivery Issue"],
    damageItemReceived: json["Damage Item Received"] == null ?"Damage Item Received": json["Damage Item Received"],
    wrongItemReceived: json["Wrong Item Received"] == null ?"Wrong Item Received": json["Wrong Item Received"],
    normal: json["normal"] == null ?"normal": json["normal"],
    low: json["low"] == null ?"low": json["low"],
    medium: json["medium"] == null ?"medium": json["medium"],
    high: json["high"] == null ?"high": json["high"],
    urgent: json["urgent"] == null ?"urgent": json["urgent"],
    critical: json["critical"] == null ?"critical": json["critical"],
    deliveryIn10Minutes: json["deliveryIn10Minutes"] == null ?"delivery in 10 minutes": json["deliveryIn10Minutes"],
    deleteAccount: json["Delete account"] == null ?"Delete account": json["Delete account"],
    deleteAccountMessage: json["Closing your account deletes all your contents"] == null ?"Closing your account deletes all your contents. Here after, the data will be entirely purged from our system, and the process cannot be reversed.": json["Closing your account deletes all your contents"],
    off: json["off"] == null ?"OFF": json["off"],
  );
}

List<Block> blockFromJson(String str) => List<Block>.from(json.decode(str).map((x) => Block.fromJson(x)));

class Block {
  int id;
  bool status;
  BlockType? blockType;
  List<Child> children;
  List<Product> products;
  List<Category> categories;
  List<StoreModel> stores;
  String title;
  String? description;
  bool showTitle;
  String headerAlign;
  Color titleColor;
  BlockPadding blockPadding;
  BlockPadding blockMargin;
  int linkId;
  String linkType;
  double borderRadius;
  double childWidth;
  double childHeight;
  double elevation;
  bool flashSale;
  String saleEndDate;
  double maxCrossAxisExtent;
  double mainAxisSpacing;
  double crossAxisSpacing;
  Color backgroundColor;
  String style;
  String storeType;
  List<Post> posts;
  bool horizontal;
  int crossAxisCount;
  double childAspectRatio;

  Block({
    required this.id,
    required this.status,
    required this.blockType,
    required this.children,
    required this.products,
    required this.categories,
    required this.stores,
    required this.title,
    this.description,
    this.showTitle = true,
    this.headerAlign = 'center',
    this.titleColor = const Color(0xff000000),
    required this.blockMargin,
    required this.blockPadding,
    this.backgroundColor = const Color(0xffffffff),
    this.linkId = 0,
    required this.linkType,
    this.borderRadius = 0,
    this.childWidth = 200,
    this.childHeight = 200,
    this.elevation = 0,
    required this.saleEndDate,
    required this.flashSale,
    this.maxCrossAxisExtent = 200,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 10,
    required this.style,
    required this.storeType,
    required this.posts,
    this.horizontal = false,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
    id: json["id"] == null ? 0 : json["id"],
    status: json["status"] == null ? true : json["status"],
    blockType: _nullOrEmptyOrFalse(json["blockType"]) ? null : blockTypeValues.map[json["blockType"]],
    title: json["title"] == null ? '' : json["title"],
    description: json["description"] == null || json["description"] == '' ? null : json["description"],
    showTitle: json["showTitle"] == null ? false : json["showTitle"],
    children: _nullOrEmptyOrFalse(json["children"]) || json["children"] == '' ? [] : List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
    products: _nullOrEmptyOrFalse(json["products"]) ? [] : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    categories: _nullOrEmptyOrFalse(json["categories"]) ? [] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    posts: json["posts"] == null ? [] : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
    headerAlign: json["headerAlign"] == null ? 'none' : json["headerAlign"],
    titleColor: _nullOrEmptyOrFalse(json["titleColor"]) ? Colors.transparent : HexColor(json["titleColor"]),
    blockMargin: _nullOrEmptyOrFalse(json["blockMargin"]) ? BlockPadding.fromJson({}) : BlockPadding.fromJson(json["blockMargin"]),
    blockPadding: _nullOrEmptyOrFalse(json["blockPadding"]) ? BlockPadding.fromJson({}) : BlockPadding.fromJson(json["blockPadding"]),
    backgroundColor: _nullOrEmptyOrFalse(json["backgroundColor"]) ? Colors.transparent : HexColor(json["backgroundColor"]),
    linkId: json["linkId"] == null ? 0 : json["linkId"],
    linkType: _nullOrEmptyOrFalse(json["linkType"]) ? '' : json["linkType"],
    borderRadius: json["borderRadius"] == null ? 0 : json["borderRadius"].toDouble(),
    childWidth: json["childWidth"] == null ? 200 : json["childWidth"].toDouble(),
    childHeight: json["childHeight"] == null ? 300 : json["childHeight"].toDouble(),
    elevation: json["elevation"] == null ? 0 : json["elevation"].toDouble(),
    saleEndDate: _nullOrEmptyOrFalse(json["saleEndDate"]) ? DateTime.now().toIso8601String() : json["saleEndDate"],
    flashSale: _nullOrEmptyOrFalse(json["flashSale"]) ? false : json["flashSale"],
    stores: json["stores"] == null ? [] : List<StoreModel>.from(json["stores"].map((x) => StoreModel.fromJson(x))),
    maxCrossAxisExtent: json["maxCrossAxisExtent"] == null ? 300 : double.parse(json["maxCrossAxisExtent"].toString()),
    mainAxisSpacing: json["mainAxisSpacing"] == null ? 10 : double.parse(json["mainAxisSpacing"].toString()),
    crossAxisSpacing: json["crossAxisSpacing"] == null ? 10 : double.parse(json["crossAxisSpacing"].toString()),
    style: json["style"] == null ? 'STYLE1' : json["style"],
    storeType: json["storeType"] == null ? '' : json["storeType"],
    horizontal: json["horizontal"] == null ? false : json["horizontal"],
    crossAxisCount: json["crossAxisCount"] == null ? 2 : json["crossAxisCount"],
    childAspectRatio: json["childAspectRatio"] == null ? 1.0 : double.parse(json["childAspectRatio"].toString()),
  );
}

enum BlockType { bannerList, bannerGrid, bannerScroll, bannerSlider, categoryList, categoryGrid, categoryScroll, categorySlider, storeList, storeScroll, storeListTile, storeSlider,
  productGrid, productList, productScroll, productSlider, categoryListTile, categoryPresets, brandListTile, brandPresets, brandList, brandGrid, brandScroll, brandSlider,
  postList, postScroll, postListTile, postSlider, bannerPresets, textList, htmlList, videoList, videoListWithController, youTubeVideo}

final blockTypeValues = EnumValues({
  "bannerList": BlockType.bannerList,
  "bannerGrid": BlockType.bannerGrid,
  "bannerScroll": BlockType.bannerScroll,
  "bannerSlider": BlockType.bannerSlider,
  "categoryList": BlockType.categoryList,
  "categoryGrid": BlockType.categoryGrid,
  "categoryScroll": BlockType.categoryScroll,
  "categorySlider": BlockType.categorySlider,
  "storeList": BlockType.storeList,
  "storeScroll": BlockType.storeScroll,
  "storeSlider": BlockType.storeSlider,
  "storeListTile": BlockType.storeListTile,
  "productList": BlockType.productList,
  "productGrid": BlockType.productGrid,
  "productScroll": BlockType.productScroll,
  "productSlider": BlockType.productSlider,
  "categoryListTile": BlockType.categoryListTile,
  "categoryPresets": BlockType.categoryPresets,
  "brandListTile": BlockType.brandListTile,
  "brandPresets": BlockType.brandPresets,
  "brandList": BlockType.brandList,
  "brandGrid": BlockType.brandGrid,
  "brandScroll": BlockType.brandScroll,
  "brandSlider": BlockType.brandSlider,
  "postList": BlockType.postList,
  "postScroll": BlockType.postScroll,
  "postSlider": BlockType.postSlider,
  "postListTile": BlockType.postListTile,
  "bannerPresets": BlockType.bannerPresets,
  "textList": BlockType.textList,
  "htmlList": BlockType.htmlList,
  "videoList": BlockType.videoList,
  "videoListWithController": BlockType.videoListWithController,
  "youTubeVideo": BlockType.youTubeVideo
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class BlockPadding {
  BlockPadding({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });

  double left;
  double top;
  double right;
  double bottom;

  factory BlockPadding.fromJson(Map<String, dynamic> json) => BlockPadding(
    left: _nullOrEmptyOrFalse(json["left"]) || double.parse(json["left"].toString()).isNegative ? 0 : double.parse(json["left"].toString()),
    top: _nullOrEmptyOrFalse(json["top"]) || double.parse(json["top"].toString()).isNegative ? 0 : double.parse(json["top"].toString()),
    right: _nullOrEmptyOrFalse(json["right"]) || double.parse(json["right"].toString()).isNegative ? 0 : double.parse(json["right"].toString()),
    bottom: _nullOrEmptyOrFalse(json["bottom"]) || double.parse(json["bottom"].toString()).isNegative ? 0 : double.parse(json["bottom"].toString()),
  );
}

class Child {
  String title;
  String description;
  String linkId;
  String linkType;
  String parent;
  String image;
  String storeType;
  String leading;
  String trailing;
  IconStyle? iconStyle;
  TextStyle? textStyle;

  Child({
    this.title = '',
    this.description = '',
    required this.linkType,
    this.linkId = '0',
    this.image = '',
    this.parent = '',
    this.storeType = '',
    this.leading = '',
    this.trailing = '',
    this.iconStyle,
    this.textStyle
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    title: json["title"] == null ? '' : json["title"],
    description: json["description"] == null ? '' : json["description"],
    linkId: json["linkId"] == null ? '0' : json["linkId"],
    linkType: json["linkType"] == null ? '' : json["linkType"],
    image: json["image"] == null ? '' : json["image"],
    storeType: json["storeType"] == null ? '' : json["storeType"],
    leading: json["leading"] == null ? '' : json["leading"],
    trailing: json["trailing"] == null ? '' : json["trailing"],
    iconStyle: json["iconStyle"] == null ? null : IconStyle.fromJson(json["iconStyle"]),
    textStyle: _nullOrEmptyOrFalse(json['textStyle']) ? null : buildTileTextStyle(json['textStyle']),
    parent: json["parent"] == null ? '0' : json["parent"],
  );
}

TextStyle buildTileTextStyle(Map<String, dynamic> json) {
  return TextStyle(
    color: _nullOrEmptyOrFalse(json['color']) ? null : HexColor(json['color']),
    fontFamily: _nullOrEmptyOrFalse(json['fontFamily']) ? null : json['fontFamily'].toString(),
    fontSize:  _nullOrEmptyOrFalse(json['fontSize']) ? 16 : double.parse(json['fontSize'].toString()),
    fontWeight:  _nullOrEmptyOrFalse(json['fontWeight']) ? FontWeight.w400 : getFontWeight(json['fontWeight']),
    fontStyle:  json['fontStyle'] == 'FontStyle.italic' ? FontStyle.italic : FontStyle.normal,
    letterSpacing:  _nullOrEmptyOrFalse(json['letterSpacing']) ? 1 : double.parse(json['letterSpacing'].toString()),
    wordSpacing:  _nullOrEmptyOrFalse(json['wordSpacing']) ? 1 : double.parse(json['wordSpacing'].toString()),
    textBaseline:  json['textBaseline'] == 'TextBaseline.ideographic' ? TextBaseline.ideographic : TextBaseline.alphabetic,
  );
}

class IconStyle {
  IconStyle({
    required this.color,
    required this.backgroundColor,
    required this.borderRadius,
    required this.elevation,
    this.style
  });

  Color color;
  Color backgroundColor;
  double borderRadius;
  double elevation;
  String? style;

  factory IconStyle.fromJson(Map<String, dynamic> json) => IconStyle(
    color: json["color"] == null ? Colors.white : HexColor(json["color"]),
    backgroundColor: json["backgroundColor"] == null ? Colors.deepOrange : HexColor(json["backgroundColor"]),
    borderRadius: json["borderRadius"] == null ? 0.0 : double.parse(json["borderRadius"].toString()),
    elevation: json["elevation"] == null ? 0.0 : double.parse(json["elevation"].toString()),
    style: json["style"] == null ? null : json["style"],
  );
}


class OldChild {
  String title;
  String description;
  String url;
  String sort;
  //String attachmentId;
  String thumb;
  String image;
  String height;
  String width;

  OldChild({
    required this.title,
    required this.description,
    required this.url,
    required this.sort,
    //required this.attachmentId,
    required this.thumb,
    required this.image,
    required this.height,
    required this.width,
  });

  factory OldChild.fromJson(Map<String, dynamic> json) => OldChild(
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    url: json["url"] == null ? null : json["url"],
    sort: json["sort"] == null ? null : json["sort"],
    //attachmentId: json["attachment_id"] == null ? null : json["attachment_id"],
    thumb: json["thumb"] == null ? null : json["thumb"],
    image: json["image"] == null ? null : json["image"],
    height: json["height"] == null ? null : json["height"],
    width: json["width"] == null ? null : json["width"],
  );
}

class SiteSettings {
  int maxPrice;
  String currency;
  String defaultCountry;
  String baseState;
  int priceDecimal;
  String vendorType;
  String siteName;
  String siteDescription;
  //String dynamicLink;
  List<String> adminUIDs;

  SiteSettings({
    required this.maxPrice,
    required this.currency,
    required this.defaultCountry,
    required this.baseState,
    required this.priceDecimal,
    required this.vendorType,
    required this.siteName,
    required this.siteDescription,
    //required this.dynamicLink,
    required this.adminUIDs,
  });

  factory SiteSettings.fromJson(Map<String, dynamic> json) => SiteSettings(
    maxPrice: json["max_price"] == null ? 100000 : json["max_price"],
    currency: json["currency"] == null ? 'USD' : json["currency"],
    defaultCountry: json["defaultCountry"] == null ? 'USD' : json["defaultCountry"],
    baseState: json["baseState"] == null ? '' : json["baseState"],
    priceDecimal: json["priceDecimal"] == null ? 2 : json["priceDecimal"],
    vendorType: json["vendorType"] == null ? '' : json["vendorType"],
    siteName: json["siteName"] == null ? '' : json["siteName"],
    siteDescription: json["siteDescription"] == null ? '' : json["siteDescription"],
    //dynamicLink: json["dynamic_link"] == null ? '' : json["dynamic_link"],
    adminUIDs: json["adminUIDs"] == null ? [] : List<String>.from(json["adminUIDs"].map((x) => x)),
  );
}

class Language {
  String code;
  String id;
  String nativeName;
  String major;
  dynamic active;
  String defaultLocale;
  String encodeUrl;
  String tag;
  String translatedName;
  String url;
  String countryFlagUrl;
  String languageCode;

  Language({
    required this.code,
    required this.id,
    required this.nativeName,
    required this.major,
    required this.active,
    required this.defaultLocale,
    required this.encodeUrl,
    required this.tag,
    required this.translatedName,
    required this.url,
    required this.countryFlagUrl,
    required this.languageCode,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    code: json["language_code"] == null ? 'en' : json["language_code"],
    id: json["id"] == null ? '0' : json["id"].toString(),
    nativeName: json["native_name"] == null ? 'English' : json["native_name"],
    major: json["major"] == null ? '' : json["major"],
    active: json["active"],
    defaultLocale: json["default_locale"] == null ? '' : json["default_locale"],
    encodeUrl: json["encode_url"] == null ? '' : json["encode_url"],
    tag: json["tag"] == null ? '' : json["tag"],
    translatedName: json["translated_name"] == null ? '' : json["translated_name"],
    url: json["url"] == null ? '' : json["url"],
    countryFlagUrl: json["country_flag_url"] == null ? '' : json["country_flag_url"],
    languageCode: json["language_code"] == null ? '' : json["language_code"],
  );
}

class Currency {
  //Languages languages;
  /*dynamic rate;
  String position;
  String thousandSep;
  String decimalSep;
  String numDecimals;
  String rounding;
  int roundingIncrement;
  int autoSubtract;*/
  String code;
/*  DateTime updated;
  int previousRate;*/

  Currency({
    //required this.languages,
    /*required this.rate,
    required this.position,
    required this.thousandSep,
    required this.decimalSep,
    required this.numDecimals,
    required this.rounding,
    required this.roundingIncrement,
    required this.autoSubtract,*/
    required this.code,
    /*required this.updated,
    required this.previousRate,*/
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    //languages: json["languages"] == null ? null : Languages.fromJson(json["languages"]),
    //rate: json["rate"],
    //position: json["position"] == null ? null : json["position"],
    //thousandSep: json["thousand_sep"] == null ? null : json["thousand_sep"],
    //decimalSep: json["decimal_sep"] == null ? null : json["decimal_sep"],
    //numDecimals: json["num_decimals"] == null ? null : json["num_decimals"],
    //rounding: json["rounding"] == null ? null : json["rounding"],
    //roundingIncrement: json["rounding_increment"] == null ? null : json["rounding_increment"],
    //autoSubtract: json["auto_subtract"] == null ? null : json["auto_subtract"],
    code: json["code"] == null ? null : json["code"],
    //updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
    //previousRate: json["previous_rate"] == null ? null : json["previous_rate"],
  );
}

class PageLayout {
  String home;
  String category;
  String login;
  String stores;
  String account;
  String product;

  PageLayout({
    required this.home,
    required this.category,
    required this.login,
    required this.stores,
    required this.account,
    required this.product
  });

  factory PageLayout.fromJson(Map<String, dynamic> json) => PageLayout(
    home: json["home"] == null ? 'layout1' : json["home"],
    category: json["category"] == null ? 'layout1' : json["category"],
    login: json["login"] == null ? 'layout1' : json["login"],
    stores: json["stores"] == null ? 'layout1' : json["stores"],
    account: json["account"] == null ? 'layout1' : json["account"],
    product: json["product"] == null ? 'layout1' : json["product"],
  );
}

class Widgets {
  String button;

  Widgets({
    required this.button,
  });

  factory Widgets.fromJson(Map<String, dynamic> json) => Widgets(
    button: json["button"] == null ? 'button1' : json["button"],
  );
}

//TODO For Online Built app only
class AppTheme {
  AppTheme({
    required this.primarySwatch,
    required this.primaryColor,
    required this.accentColor,
    required this.buttonColor,
  });

  String primarySwatch;
  String primaryColor;
  String accentColor;
  String buttonColor;

  factory AppTheme.fromJson(Map<String, dynamic> json) => AppTheme(
    primarySwatch: json["primary_swatch"] == null ? 'Colors.blue' : json["primary_swatch"],
    primaryColor: json["primary_color"] == null ? '#FFFFFF' : json["primary_color"],
    accentColor: json["accent_color"] == null ? '#007AFF' : json["accent_color"],
    buttonColor: json["button_color"] == null ? '#FFC107' : json["button_color"],
  );
}

class AppTypography {
  AppTypography({
    required this.bodyText1,
    required this.bodyText2,
    required this.subtitle1,
    required this.subtitle2,
    required this.headline1,
    required this.headline2,
    required this.headline3,
    required this.headline4,
    required this.headline5,
    required this.headline6,
    required this.caption,
    required this.overline,
    required this.button,
  });

  BodyText bodyText1;
  BodyText bodyText2;
  BodyText subtitle1;
  BodyText subtitle2;
  BodyText headline1;
  BodyText headline2;
  BodyText headline3;
  BodyText headline4;
  BodyText headline5;
  BodyText headline6;
  BodyText caption;
  BodyText overline;
  BodyText button;

  factory AppTypography.fromJson(Map<String, dynamic> json) => AppTypography(
    bodyText1: json["body_text_1"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["body_text_1"]),
    bodyText2: json["body_text_2"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["body_text_2"]),
    subtitle1: json["subtitle_1"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["subtitle_1"]),
    subtitle2: json["subtitle_2"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["subtitle_2"]),
    headline1: json["headline_1"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["headline_1"]),
    headline2: json["headline_2"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["headline_2"]),
    headline3: json["headline_3"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["headline_3"]),
    headline4: json["headline_4"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["headline_4"]),
    headline5: json["headline_5"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["headline_5"]),
    headline6: json["headline_6"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["headline_6"]),
    caption: json["caption"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["caption"]),
    overline: json["overline"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["overline"]),
    button: json["button"] == null ? BodyText.fromJson({}) : BodyText.fromJson(json["button"]),
  );
}

class BodyText {
  BodyText({
    required this.fontFamily,
    //required this.fontOptions,
    // this.google,
    required this.fontWeight,
    required this.fontStyle,
    required this.fontSize,
    required this.lineHeight,
    required this.wordSpacing,
    required this.letterSpacing,
    required this.color,
  });

  String fontFamily;
  //String fontOptions;
  //String google;
  FontWeight fontWeight;
  FontStyle fontStyle;
  double fontSize;
  double lineHeight;
  double wordSpacing;
  double letterSpacing;
  Color color;

  factory BodyText.fromJson(Map<String, dynamic> json) => BodyText(
    fontFamily: _nullOrEmptyOrFalse(json["font-family"]) ? 'Default' : json["font-family"],
    fontWeight: _nullOrEmptyOrFalse(json["font-weight"]) ? FontWeight.normal : getFontWeight(json["font-weight"]),
    fontStyle: json["font-style"] == 'italic' ? FontStyle.italic : FontStyle.normal,
    fontSize: _nullOrEmptyOrFalse(json["font-size"]) ? 14 : double.parse(json["font-size"].replaceAll('px','')),
    lineHeight: _nullOrEmptyOrFalse(json["line-height"]) ? 1 : double.parse(json["line-height"].replaceAll('px','')),
    letterSpacing: _nullOrEmptyOrFalse(json["letter-spacing"]) ? 0 : double.parse(json["letter-spacing"].toString()),
    wordSpacing: _nullOrEmptyOrFalse(json["word-spacing"]) ? 0 : double.parse(json["word-spacing"].toString()),
    color: _nullOrEmptyOrFalse(json["color"]) ? Colors.black : HexColor(json["color"]),
  );

}


_nullOrEmptyOrFalse(json) {
  if(json == null || json == '' || json == false) {
    return true;
  } else return false;
}

getFontWeight(String fontWeight) {
  switch (fontWeight) {
    case 'normal':
      return FontWeight.normal;
    case 'bold':
      return FontWeight.bold;
    case '100':
      return FontWeight.w100;
    case '200':
      return FontWeight.w200;
    case '300':
      return FontWeight.w300;
    case '400':
      return FontWeight.w400;
    case '500':
      return FontWeight.w500;
    case '600':
      return FontWeight.w600;
    case '700':
      return FontWeight.w700;
    case '800':
      return FontWeight.w800;
    case '900':
      return FontWeight.w900;
    default:
      return FontWeight.normal;
  }
}

getBoxFit(String boxFit) {
  switch (boxFit) {
    case 'BoxFit.fill':
      return BoxFit.fill;
    case 'BoxFit.contain':
      return BoxFit.contain;
    case 'BoxFit.cover':
      return BoxFit.cover;
    case 'BoxFit.scaleDown':
      return BoxFit.scaleDown;
    case 'BoxFit.fitHeight':
      return BoxFit.fitHeight;
    case 'BoxFit.fitWidth':
      return BoxFit.fitWidth;
    case 'BoxFit.none':
      return BoxFit.none;
    default:
      return BoxFit.contain;
  }
}
