import 'package:app/src/models/cart/cart_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/errors/error.dart';
import 'package:app/src/resources/api_provider.dart';
import 'package:app/src/ui/accounts/login/login.dart';

class ShoppingCart with ChangeNotifier {

  ShoppingCart() {
    getCartWithCookies();
  }

  CartModel cart = CartModel.fromJson({});
  AppStateModel appStateModel = AppStateModel();
  int count = 0;
  bool isCartLoading =false;
  final apiProvider = ApiProvider();

  Future<bool> addToCart(BuildContext context, {int? productId, int? variationId, int? groupedProductId}) async {

    var data = new Map<String, dynamic>();
    if(variationId != null) {
      data['variation_id'] = variationId.toString();
    }
    if(groupedProductId != null) {
      data['quantity[' + groupedProductId.toString() + ']'] = '1';
    } else {
      data['quantity'] = '1';
    }

    if(productId != null) {
      data['product_id'] = productId.toString();
    }

    if(appStateModel.blocks.settings.loginBeforeAddToCart && (appStateModel.user.id == 0)) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return false;
    } else {
      final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-add_product_to_cart', data);
      if (response.statusCode == 200) {
        cart = CartModel.fromJson(json.decode(response.body));
        updateCartCount();
        return true;
      } else {
        Notice notice = noticeFromJson(response.body);
        showSnackBarError(context, parseHtmlString(notice.data[0].notice));
        return false;
      }
    }
  }

  void getCart() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-cart', Map());
    isCartLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      cart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      throw Exception('Failed to load cart');
    }
  }

  void getCartWithCookies() async {
    final response = await apiProvider.postWithCookies('/wp-admin/admin-ajax.php?action=build-app-online-cart', Map());
    isCartLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      cart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      throw Exception('Failed to load cart');
    }
  }

  void updateCartCount() {
    count = 0;
    if(cart.cartContents.isNotEmpty) {
      for (var i = 0; i < cart.cartContents.length; i++) {
        count = count + cart.cartContents[i].quantity;
      }
    }
    isCartLoading = false;
    notifyListeners();
  }

  Future<void> applyCoupon(String couponCode, BuildContext context) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=build-app-online-apply_coupon', {"coupon_code": couponCode});
    if (response.statusCode == 200) {
      getCart();
      showSnackBarSuccess(context, parseHtmlString(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      showSnackBarError(context, parseHtmlString(jsonDecode(response.body)));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<void> redeemRwardPoints(BuildContext context) async {
    final response = await apiProvider.post('/cart/', {"wc_points_rewards_apply_discount_amount": '', 'wc_points_rewards_apply_discount': 'Apply Discount'});
    if (response.statusCode == 200) {
      getCart();
      showSnackBarSuccess(context, 'Discount Applied Successfully');
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future increaseQty(BuildContext context, int productId, {int? variationId}) async {

    CartContent? cartContent;
    if (cart.cartContents.isNotEmpty) {
      if(variationId != null && cart.cartContents
          .any((cartContent) => cartContent.productId == productId && cartContent.variationId == variationId)) {
        cartContent = cart.cartContents
            .singleWhere((cartContent) => cartContent.productId == productId && cartContent.variationId == variationId);
      } else if (cart.cartContents
          .any((cartContent) => cartContent.productId == productId)) {
        cartContent = cart.cartContents
            .singleWhere((cartContent) => cartContent.productId == productId);
      }
      if(cartContent != null) {
        if(cartContent.managingStock && cartContent.stockQuantity <= cartContent.quantity) {
          showSnackBarError(context, 'You cannot add that amount to the cart — we have '+cartContent.quantity.toString()+' in stock and you already have '+cartContent.quantity.toString()+' in your cart.');
        } else {
          var formData = new Map<String, String>();
          String qty = (cartContent.quantity + 1).toString();
          formData['cart[' + cartContent.key + '][qty]'] = qty;
          formData['quantity'] = qty;
          formData['key'] = cartContent.key;
          formData['_wpnonce'] = cart.cartNonce;
          final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-update-cart-item-qty', formData);
          if (response.statusCode == 200) {
            cart = CartModel.fromJson(json.decode(response.body));
            updateCartCount();
          } else {
            throw Exception('Failed to load cart');
          }
        }
      }
    }
    return true;
  }

  Future decreaseQty(BuildContext context, int productId, {int? variationId}) async {
    CartContent? cartContent;
    if (cart.cartContents.isNotEmpty) {
      if(variationId != null && cart.cartContents
          .any((cartContent) => cartContent.productId == productId && cartContent.variationId == variationId)) {
        cartContent = cart.cartContents
            .singleWhere((cartContent) => cartContent.productId == productId && cartContent.variationId == variationId);
      } else if (cart.cartContents
          .any((cartContent) => cartContent.productId == productId)) {
        cartContent = cart.cartContents
            .singleWhere((cartContent) => cartContent.productId == productId);
      }
      if(cartContent != null) {
        var formData = new Map<String, String>();
        int qty = cartContent.quantity - 1;
        if(qty < 0) {
          removeItemFromCart(cartContent.key);
        } else {
          formData['cart[' + cartContent.key + '][qty]'] = qty.toString();
          formData['quantity'] = qty.toString();
          formData['key'] = cartContent.key;
          formData['_wpnonce'] = cart.cartNonce;
          final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-update-cart-item-qty', formData);
          if (response.statusCode == 200) {
            cart = CartModel.fromJson(json.decode(response.body));
            updateCartCount();
          } else {
            throw Exception('Failed to load cart');
          }
        }
      }
    }
    return true;
  }

  Future updateCartQty(BuildContext context, int qty, {CartContent? cartContent, int? productId, int? variationId}) async {

    if (cart.cartContents.isNotEmpty) {

      if(cartContent == null && productId != null) {
        if(variationId != null && cart.cartContents
            .any((cartContent) => cartContent.productId == productId && cartContent.variationId == variationId)) {
          cartContent = cart.cartContents
              .singleWhere((cartContent) => cartContent.productId == productId && cartContent.variationId == variationId);
        } else if (cart.cartContents
            .any((cartContent) => cartContent.productId == productId)) {
          cartContent = cart.cartContents
              .singleWhere((cartContent) => cartContent.productId == productId);
        }
      }

      if(cartContent != null) {
        var formData = new Map<String, String>();
        if(qty < 0) {
          removeItemFromCart(cartContent.key);
        } else {
          formData['cart[' + cartContent.key + '][qty]'] = qty.toString();
          formData['quantity'] = qty.toString();
          formData['key'] = cartContent.key;
          formData['_wpnonce'] = cart.cartNonce;
          final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-update-cart-item-qty', formData);
          if (response.statusCode == 200) {
            cart = CartModel.fromJson(json.decode(response.body));
            updateCartCount();
          } else {
            throw Exception('Failed to load cart');
          }
        }
      }
    }
    return true;
  }

  // Removes an item from the cart.
  bool removeCartItem(CartContent cartContent) {
    if (cart.cartContents.contains(cartContent)) {
      cart.cartContents.remove(cartContent);
      removeItemFromCart(cartContent.key);
    }
    updateCartCount();
    return true;
  }

  Future removeItemFromCart(String key) async {
    cart.cartContents.removeWhere((item) => item.key == key);
    notifyListeners();
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-remove_cart_item&item_key=' + key, Map());
    if (response.statusCode == 200) {
      cart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      throw Exception('Failed to load cart');
    }
    updateCartCount();
    return true;
  }

  Future<dynamic> removeCoupon(String code) async {
    var data = new Map<String, String>();
    data['coupon'] = code;
    cart.coupons.removeWhere((element) => element.code == code);
    notifyListeners();
    await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-remove_coupon', data);
    getCart();
  }

  Future<void> clearCart() async {
    cart = CartModel.fromJson({});
    notifyListeners();
    final response = await apiProvider.get('/wp-admin/admin-ajax.php?action=build-app-online-clearCart');
  }

  Future<bool> addToCartWithData(data, BuildContext context) async {
    if(appStateModel.blocks.settings.loginBeforeAddToCart && (appStateModel.user.id == 0)) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return false;
    } else {
      final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-add_product_to_cart', data);
      if (response.statusCode == 200) {
        cart = CartModel.fromJson(json.decode(response.body));
        updateCartCount();
        return true;
      } else {
        Notice notice = noticeFromJson(response.body);
        showSnackBarError(context, parseHtmlString(notice.data[0].notice));
        return false;
      }
    }
  }

  Future<bool> getCartAfterAddingBalanceToCart() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-cart', Map());
    notifyListeners();
    if (response.statusCode == 200) {
      cart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
      return true;
    } else {
      throw Exception('Failed to load cart');
    }
  }
}