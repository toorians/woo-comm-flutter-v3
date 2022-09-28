import 'dart:convert';
import 'package:app/src/models/errors/woo_error.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/wc_api.dart';
import './category_model.dart';
import '../functions.dart';
import '../resources/api_provider.dart';
import 'attributes_model.dart';
import 'blocks_model.dart';
import 'checkout/delivery_date.dart';
import 'customer_model.dart';
import 'errors/error.dart';
import 'errors/register_error.dart';
import 'product_addons_model.dart';
import 'product_model.dart';
import 'snackbar_activity.dart';

class AppStateModel extends Model {

  static final AppStateModel _appStateModel = new AppStateModel._internal();

  factory AppStateModel() {
    return _appStateModel;
  }

  AppStateModel._internal();

  late SnackBarActivity message;
  final messageFetcher = BehaviorSubject<SnackBarActivity>();
  ValueStream<SnackBarActivity> get messageStream => messageFetcher.stream;

  SelectedPage selectedPage = new SelectedPage(type: 'home', name: 'Home', id: 0);

  int currentPageIndex = 0;
  BlocksModel blocks = BlocksModel.fromJson({});
  Locale appLocale = Locale('en');
  static WooCommerceAPI wc_api = new WooCommerceAPI();
  List<ProductAddonsModel> productAddons = [];
  final apiProvider = ApiProvider();
  bool loadingHomeProducts = false;
  bool loggedIn = false;
  //List<int> wishListIds = [];
  double maxPrice = 1000000;
  var selectedRange = RangeValues(0, 1000000);
  String selectedCurrency = 'USD';
  int page = 1;
  var filter = new Map<String, dynamic>();
  bool hasMoreRecentItem = true;
  List<String> isVendor = ['seller', 'wcfm_vendor', 'dc_vendor'];
  bool loginLoading = false;
  List<Category> subCategories = [];
  List<Category> mainCategories = [];
  Map<String, dynamic> customerLocation = {};
  bool hasSeenIntro = false;
  String fcmToken = '';
  bool loading = false;
  bool listView = true;
  ThemeMode themeMode = ThemeMode.system;

  //For delivery Date time
  DeliveryDate deliveryDate = DeliveryDate(bookableDates: [], success: true);
  Map<String, DeliveryTime> deliverySlot = Map<String, DeliveryTime>();
  String? selectedDate;
  String? selectedDateFormatted;
  String? selectedTime;

  getLocalData() async {

    var prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('hasSeenIntro') != null)
    hasSeenIntro = prefs.getBool('hasSeenIntro')!;

    //prefs.setString('language_code', 'en');

    if (prefs.getString('language_code') != null) {
      appLocale = Locale(prefs.getString('language_code')!);
    }

    apiProvider.filter['lang'] = appLocale.languageCode;

    Map<String, dynamic> location = prefs.getString('customerLocation') != null && prefs.getString('customerLocation')!.isNotEmpty ? json.decode(prefs.getString('customerLocation')!) : {};
    if(location['address'] != null) {

      var searchData = new Map<String, String>();

      customerLocation['address'] = location['address'] != null ? location['address']  : '';
      customerLocation['name'] = location['name'];
      apiProvider.filter.addAll({
        'address': customerLocation['address'],
        'wcfmmp_user_location': customerLocation['address'],
      });
      if(location['longitude'] != null) {
        customerLocation['latitude'] = location['latitude'].toString();
        apiProvider.filter.addAll({
          'latitude': customerLocation['latitude'],
          'wcfmmp_user_location_lat': customerLocation['latitude'],
        });
        searchData['wcfmmp_radius_lat'] = customerLocation['latitude'];
      }

      if(location['longitude'] != null) {
        customerLocation['longitude'] = location['longitude'].toString();
        apiProvider.filter.addAll({
          'longitude': customerLocation['longitude'],
          'wcfmmp_user_location_lng': customerLocation['longitude']
        });
        searchData['wcfmmp_radius_lng'] = customerLocation['longitude'];

        var distance = prefs.getString('distance') != null ? json.decode(prefs.getString('distance')!) : '10';
        searchData['wcfmmp_radius_range'] = distance.toString();
        apiProvider.filter['search_data'] = Uri(queryParameters: searchData).query;
      }
    }

    if (prefs.getString('themeMode') != null) {
      final themeModeString = prefs.getString('themeMode');
      themeMode = themeModeString == 'ThemeMode.light' ? ThemeMode.light : themeModeString == 'ThemeMode.dark' ? ThemeMode.dark : ThemeMode.system;
    }

    notifyListeners();
    return Null;
  }

  Future<bool> getStoredBlocks() async {
    page = 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? blocksString = prefs.getString('blocks');
    String? storedCurrency = prefs.getString('currency');
    if (storedCurrency != null &&
        storedCurrency.isNotEmpty &&
        storedCurrency != '0') {
      selectedCurrency = storedCurrency;
      await switchCurrency(storedCurrency);
    }
    if (blocksString != null &&
        blocksString.isNotEmpty &&
        blocksString != '0') {
      try {
        blocks = BlocksModel.fromJson(json.decode(blocksString));
        if(mainCategories.length == 0 || (blocks.categories.where((cat) => cat.parent == 0).toList().length == (mainCategories.length - 1))) {
          mainCategories = blocks.categories.where((cat) => cat.parent == 0).toList();
          mainCategories.insert(0, Category(name: blocks.localeText.all, id: 0,  parent: 0, image: '', slug: '', description: '', count: 0));
        }
        user = blocks.user;
        //wishListIds = blocks.wishlist;
        notifyListeners();
      } catch (e, s) {}
    }
    return true;
  }

  updateAllBlocks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await apiProvider.fetchBlocks();
    if (response.statusCode == 200) {
      blocks = BlocksModel.fromJson(json.decode(response.body));
      if(mainCategories.length == 0 || (blocks.categories.where((cat) => cat.parent == 0).toList().length == (mainCategories.length - 1))) {
        mainCategories = blocks.categories.where((cat) => cat.parent == 0).toList();
        mainCategories.insert(0, Category(name: blocks.localeText.all, id: 0,  parent: 0, image: '', description: '',slug: '', count: 0));
      }
      user = blocks.user;
      
      if(prefs.getString('language_code') == null) {
        appLocale = Locale(blocks.language); //Uncomment for default language loading from server. Need to test this working properly
      }

      //wishListIds = blocks.wishlist;
      if (user.id > 0) {
        loggedIn = true;
      }
      selectedCurrency = blocks.currency; // Uncomment once backend currency switcher is working with WPML

      if(currentPageIndex == 0) {
        notifyListeners();
      }
      //print(blocks.settings.geoLocation);
      if(blocks.settings.geoLocation == false) {
        customerLocation.remove('latitude');
        customerLocation.remove('latitude');
        prefs.setString('customerLocation', json.encode(customerLocation));
        apiProvider.filter.remove('latitude');
        apiProvider.filter.remove('longitude');
        apiProvider.filter.remove('wcfmmp_user_location');
        apiProvider.filter.remove('wcfmmp_user_location_lat');
        apiProvider.filter.remove('wcfmmp_user_location_lng');
        apiProvider.filter.remove('address');
        apiProvider.filter.remove('wcfmmp_radius_range');
        apiProvider.filter.remove('search_data');
        resetAllBlocks();
      }
      /*if(blocks.oldSettings.switchAddons == 1) {
        getProDuctAddons();
      }*/
      if(blocks.splash != null) {
        //apiProvider.downloadSplashSave(blocks.splash);
      }
      prefs.setString('blocks', response.body);
      prefs.setString('themeMode', blocks.settings.themeMode.toString());
    } else {
      //Fluttertoast.showToast(gravity: ToastGravity.TOP, msg: 'Something is not right!');
    }
    return true;
  }

  resetAllBlocks() async {
    blocks.stores = [];
    loading = true;
    notifyListeners();
    hasMoreRecentItem = true;
    page = 1;
    final response = await apiProvider.fetchBlocks();
    loading = false;
    if (response.statusCode == 200) {
      blocks = BlocksModel.fromJson(json.decode(response.body));
      if(blocks.categories.where((cat) => cat.parent == 0).toList().length == (mainCategories.length - 1)) {
        mainCategories = blocks.categories.where((cat) => cat.parent == 0).toList();
        mainCategories.insert(0, Category(name: blocks.localeText.all, id: 0,  parent: 0, image: '', slug: '', description: '', count: 0));
      }
      user = blocks.user;
      //wishListIds = blocks.wishlist;
      if (user.id > 0) {
        loggedIn = true;
      }
      //selectedCurrency = blocks.currency; // Uncomment once backend currency switcher is working with WPML
      if(currentPageIndex == 0) {
        notifyListeners();
      }
      /*if(blocks.splash != null) {
        //apiProvider.downloadSplashSave(blocks.splash);
      }*/
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('blocks', response.body);
    } else {
      messageFetcher.add(SnackBarActivity(show: true, success: false, message: '${response.reasonPhrase}'));
    }
  }

  Future<void> setPickedLocation(Map<String, dynamic> result) async {

    customerLocation = result;
    customerLocation['address'] = customerLocation['address'] != null ? customerLocation['address'] : '';
    apiProvider.filter.addAll({
      'address': customerLocation['address'],
      'latitude': customerLocation['latitude'],
      'longitude': customerLocation['longitude'],
      'wcfmmp_user_location': customerLocation['address'],
      'wcfmmp_radius_addr': customerLocation['address'],
      'wcfmmp_user_location_lat': customerLocation['latitude'],
      'wcfmmp_user_location_lng': customerLocation['longitude']
    });

    var searchData = new Map<String, String>();
    searchData['wcfmmp_radius_lat'] = customerLocation['latitude'];
    searchData['wcfmmp_radius_lng'] = customerLocation['longitude'];
    searchData['wcfmmp_radius_range'] = blocks.settings.distance;
    apiProvider.filter['search_data'] = Uri(queryParameters: searchData).query;

    loading = true;
    blocks.stores = [];
    notifyListeners();
    resetAllBlocks();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('customerLocation', json.encode(customerLocation));
  }

  Future<void> setDeliveryLocation(Map<String, dynamic> result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerLocation.addAll(result);
    prefs.setString('customerLocation', json.encode(customerLocation));
    notifyListeners();
  }

  loadMoreRecentProducts() async {
    loadingHomeProducts = true;
    page = page + 1;
    filter['page'] = page.toString();
    final response = await apiProvider.fetchProducts(filter);
    if (response.statusCode == 200) {
      List<Product> products = productModelFromJson(response.body);
      blocks.recentProducts.addAll(products);
      if (products.length == 0) {
        hasMoreRecentItem = false;
      }
      loadingHomeProducts = false;
      notifyListeners();
    } else {
      loadingHomeProducts = false;
      throw Exception('Failed to load products');
    }
  }

  //Account
  Customer user = Customer.fromJson({});

  Future<bool> login(Map<String, dynamic> data, BuildContext context) async {
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=build-app-online-login', data);
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        updateAllBlocks();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      showSnackBarError(context, parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> googleLogin(data, BuildContext context) async {
    loginLoading = true;
    notifyListeners();
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=build-app-online-google_login', data);
    loginLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        updateAllBlocks();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      //TODO Replace with snackbar
      //Fluttertoast.showToast(msg: parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> appleLogin(data, BuildContext context) async {
    loginLoading = true;
    notifyListeners();
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=build-app-online-apple_login', data);
    loginLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        updateAllBlocks();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      //TODO Replace with snackbar
      //Fluttertoast.showToast(msg: parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> phoneLogin(data, BuildContext context) async {
    loginLoading = true;
    notifyListeners();
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=build-app-online-otp_verification', data);
    loginLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        updateAllBlocks();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      showSnackBarError(context, parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> facebookLogin(token, BuildContext context) async {
    loginLoading = true;
    notifyListeners();
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=build-app-online-facebook_login', {'access_token': token});
    loginLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        updateAllBlocks();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      //TODO Replace with snackbar
      //Fluttertoast.showToast(msg: parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> register(data, BuildContext context) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-create-user', data);
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        updateAllBlocks();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      RegisterError error = RegisterError.fromJson(json.decode(response.body));
      showSnackBarError(context, parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> applyVendor(data, BuildContext context) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-apply-vendor', data);
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        updateAllBlocks();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      RegisterError error = RegisterError.fromJson(json.decode(response.body));
      showSnackBarError(context, parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future logout() async {
    apiProvider.generateCookies();
    final response = await apiProvider.get('/wp-admin/admin-ajax.php?action=build-app-online-logout');
    if(response.statusCode == 200){
      user = new Customer.fromJson({});
      //wishListIds = [];
      loggedIn = false;
      notifyListeners();
      //getCart();
    }
    return true;
  }

  Future<bool> switchCurrency(String s) async {
    await apiProvider.post('/wp-admin/admin-ajax.php',
        {'action': 'wcml_switch_currency', 'currency': s, 'force_switch': '0'});
    return true;
  }

  getCustomerDetails() async {
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=build-app-online-customer', new Map());
    //Customer customers = Customer.fromJson(json.decode(response.body));
    //TODO Set is Loggedin if logged in
  }


  void setPage(String type, int id, String name) {
    selectedPage.type = type;
    selectedPage.id = id;
    selectedPage.name = name;
  }

  setSubCategories(int id) {
    subCategories = blocks.categories.where((cat) => cat.parent == id).toList();
    if (subCategories.length != 0) {
      subCategories.insert(0, Category(name: 'All', id: id, parent: 0, description: '', image: '', slug: '', count: 0));
    }
  }


  /// Products ///
  Map<String, List<Product>> products = new Map<String, List<Product>>();
  var productsPage = new Map<String, int>();
  List<AttributesModel> attributes = [];
  var productsFilter = new Map<String, dynamic>();
  var hasMoreItems = new Map<String, dynamic>();
  late TabController tabController;

  fetchAllProducts() async {
    if(!products.containsKey(productsFilter['id'])) {
      productsPage[productsFilter['id']] = 1;
      productsFilter['page'] = productsPage[productsFilter['id']].toString();
      products[productsFilter['id']] = await apiProvider.fetchProductList(productsFilter);
    }
    notifyListeners();
  }

  loadMore() async {
    hasMoreItems[productsFilter['id']] = true;
    notifyListeners();
    if(productsPage.containsKey(productsFilter['id']))
    productsPage[productsFilter['id']] = productsPage[productsFilter['id']]! + 1;
    productsFilter['page'] = productsPage[productsFilter['id']].toString();
    List<Product> moreProducts = await apiProvider.fetchProductList(productsFilter);
    if(products.containsKey(productsFilter['id']))
    products[productsFilter['id']]!.addAll(moreProducts);
    if(moreProducts.length < 6){
      hasMoreItems[productsFilter['id']] = false;
    }
    notifyListeners();
  }

  Future fetchProductsAttributes() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-product-attributes', {'category': productsFilter['id'].toString()});
    if (response.statusCode == 200) {
      attributes = filterModelFromJson(response.body);
    } else {
      throw Exception('Failed to load attributes');
    }
    notifyListeners();
  }

  void clearFilter() {
    for(var i = 0; i < attributes.length; i++) {
      for(var j = 0; j < attributes[i].terms.length; j++) {
        attributes[i].terms[j].selected = false;
      }
    }
    fetchAllProducts();
  }

  void applyFilter(int id, double minPrice, double maxPrice) {
    if(products[productsFilter['id']] != null) {
      products[productsFilter['id']]!.clear();
    }
    productsFilter['min_price'] = minPrice.toString();
    productsFilter['max_price'] = maxPrice.toString();
    if(attributes != null)
      for(var i = 0; i < attributes.length; i++) {
        for(var j = 0; j < attributes[i].terms.length; j++) {
          if(attributes[i].terms[j].selected) {
            productsFilter['attribute_term' + j.toString()] = attributes[i].terms[j].termId.toString();
            productsFilter['attributes' + j.toString()] = attributes[i].terms[j].taxonomy;
          }
        }
      }
    fetchAllProducts();
  }

  void changeCategory(int id) {
    productsFilter['id'] = id.toString();
    fetchAllProducts();
  }

  void setFilter(Map<String, dynamic> filter) {
    productsFilter = filter;
    selectedRange = RangeValues(0, blocks.maxPrice.toDouble());
    notifyListeners();
  }

  setIntroScreenSeen() async {
    hasSeenIntro = true;
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenIntro', true);
  }

  Future<void> updateLanguage(String code) async {
    apiProvider.filter['lang'] = code;
    appLocale = Locale(code);
    notifyListeners();
    resetAllBlocks();
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', code);
  }

  void _updatePushData() {
    var tokens = new Map<String, dynamic>();
    if(fcmToken.isNotEmpty) {
      tokens['fcm_token'] = fcmToken;
    }
    apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-update_user_notification', tokens);
  }

  getDeliveryDate() async {
    var formData = new Map<String, String>();
    formData['action'] = 'iconic_wds_get_upcoming_bookable_dates';
    final response = await apiProvider.post('/wp-admin/admin-ajax.php', formData);
    if (response.statusCode == 200) {
      deliveryDate = deliveryDateFromJson(response.body);
      notifyListeners();
      if(deliveryDate.bookableDates.length > 0) {
        List<String> str = deliveryDate.bookableDates[0].split('/');
        selectedDateFormatted = deliveryDate.bookableDates[0];
        selectedDate = str[2] + str[1] + str[0];
        getDeliverySlot(selectedDate);
      }
    } else {
      throw Exception('Failed to load delivery slot');
    }
  }

  getDeliverySlot(dateParam) async {
    var formData = new Map<String, String>();
    formData['action'] = 'iconic_wds_get_slots_on_date';
    formData['nonce'] = '5c895bbe90';
    formData['date'] = dateParam;
    final response = await apiProvider.post('/wp-admin/admin-ajax.php', formData);
    if (response.statusCode == 200) {
      deliverySlot[dateParam] = deliveryTimeFromJson(response.body);
      if(deliverySlot[dateParam]?.slots[0].value != null) {
        selectedTime = deliverySlot[dateParam]!.slots[0].value;
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load delivery slot');
    }
  }

  void setDate(String date, String stringDate) {
    selectedDateFormatted = stringDate;
    selectedDate = date;
    getDeliverySlot(selectedDate);
    notifyListeners();
  }

  void setDeliveryTime(String value) {
    selectedTime = value;
    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode? value) async {
    themeMode = value!;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', value.toString());
  }

  deleteAccount() async {
    var formData = new Map<String, String>();
    formData['action'] = 'build-app-online-delete_my_account';
    final response = await apiProvider.post('/wp-admin/admin-ajax.php', formData);
    if (response.statusCode == 200) {
      user = new Customer.fromJson({});
      loggedIn = false;
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      messageFetcher.add(SnackBarActivity(message: error.data[0].message, success: true));
      notifyListeners();
      return true;
    } else {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      messageFetcher.add(SnackBarActivity(message: error.data[0].message, success: false));
      return false;
    }
  }

  void updateNotifier(Customer u) {
    user = u;
    notifyListeners();
  }

}

class SelectedPage {
  int id;
  String type;
  String name;

  SelectedPage({
    required this.id,
    required this.type,
    required this.name,
  });
}