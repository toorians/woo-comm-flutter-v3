import 'package:app/src/ui/accounts/firebase_chat/chat.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/product_model.dart';
import 'package:app/src/models/vendor/store_model.dart';
import 'package:app/src/ui/accounts/login/login.dart';
import 'package:app/src/ui/checkout/cart/cart4.dart';
import 'package:app/src/ui/pages/webview.dart';
import 'package:app/src/ui/vendor/ui/vendor_app/vendor_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageWithBottomCart extends StatefulWidget {
  final Widget child;
  final Product product;
  const PageWithBottomCart({Key? key, required this.child, required this.product}) : super(key: key);

  @override
  State<PageWithBottomCart> createState() => _PageWithBottomCartState();
}

class _PageWithBottomCartState extends State<PageWithBottomCart> {

  final appStateModel = AppStateModel();
  bool addingToCart = false;
  bool buyingNow = false;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            height: 94,
            width: size.width,
            //color: Colors.green,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.6),
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 60,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StoreHomePage(store: StoreModel.fromJson({'id': int.parse(widget.product.vendor.id), 'icon': widget.product.vendor.icon, 'name': widget.product.vendor.name}))));
                      },
                      icon: Icon(Icons.store),
                    ),
                  ),
                  SizedBox(width: 8, height: 40, child: VerticalDivider(width: 1, thickness: 1, color: Colors.grey[400],),),
                  SizedBox(
                    width: 60,
                    child: IconButton(
                      onPressed: () {
                        _chatWithVendor();
                      },
                      icon: Icon(Icons.chat_outlined),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        primary: Theme.of(context).colorScheme.secondary,
                        onPrimary:  Theme.of(context).colorScheme.onSecondary,
                        minimumSize: Size(100.0, 48.0),
                      ),
                      child: addingToCart ? Container(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).buttonTheme.colorScheme!.onPrimary),
                              strokeWidth: 2.0)) : Text(appStateModel.blocks.localeText.
                      addToCart),
                      onPressed: () {
                        addToCart(context);
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        minimumSize: Size(100.0, 48.0),
                      ),
                      child: buyingNow ? Container(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.onSecondary),
                              strokeWidth: 2.0)) : Text(appStateModel.blocks.localeText.
                      buyNow),
                      onPressed: () {
                        buyNow(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        )
      ],
    );
  }

  Future<void> addToCart(BuildContext context) async {
    if(widget.product.type != 'external') {
      setState(() {
        addingToCart = true;
      });
      var data = new Map<String, dynamic>();
      data['product_id'] = widget.product.id.toString();
      //data['add-to-cart'] = widget.product.id.toString();
      data['quantity'] = _quantity.toString();
      var doAdd = true;
      if (widget.product.type == 'variable' &&
          widget.product.variationOptions.isNotEmpty) {
        for (var i = 0; i < widget.product.variationOptions.length; i++) {
          if (widget.product.variationOptions[i].selected != null) {
            String key = widget.product.variationOptions[i].attribute.toLowerCase().replaceAll(' ', '-').replaceAll("'", "");
            if(!key.startsWith('pa_')) {
              key = 'pa_' + key;
            }
            data['variation[attribute_' + key + ']'] = widget.product.variationOptions[i].selected;
            data['attribute_' + key] = widget.product.variationOptions[i].selected;
          } else if (widget.product.variationOptions[i].selected == null &&
              widget.product.variationOptions[i].optionList.length != 0) {
            showSnackBarError(context, appStateModel.blocks.localeText.select + ' ' + widget.product.variationOptions[i].name);
            doAdd = false;
            break;
          } else if (widget.product.variationOptions[i].selected == null &&
              widget.product.variationOptions[i].optionList.length == 0) {
            setState(() {
              widget.product.stockStatus = 'outofstock';
            });
            doAdd = false;
            break;
          }
        }
        if (widget.product.variationId != null) {
          data['variation_id'] = widget.product.variationId;
        }
      }
      if (doAdd) {
        /*if (addonFormKey.currentState != null && addonFormKey.currentState!.validate()) {
          addonFormKey.currentState!.save();
          data.addAll(addOnsFormData);
        }*/
        bool status = await context.read<ShoppingCart>().addToCartWithData(data, context);
      }
      setState(() {
        addingToCart = false;
      });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => WebViewPage(url: widget.product.addToCartUrl, title: widget.product.name),
          ));
    }
  }

  Future<void> buyNow(BuildContext context) async {
    setState(() {
      buyingNow = true;
    });
    var data = new Map<String, dynamic>();
    data['product_id'] = widget.product.id.toString();
    //data['add-to-cart'] = widget.product.id.toString();
    data['quantity'] = _quantity.toString();
    var doAdd = true;
    if (widget.product.type == 'variable' &&
        widget.product.variationOptions != null) {
      for (var i = 0; i < widget.product.variationOptions.length; i++) {
        if (widget.product.variationOptions[i].selected != null) {
          String key = widget.product.variationOptions[i].attribute.toLowerCase().replaceAll(' ', '-').replaceAll("'", "");
          if(!key.startsWith('pa_')) {
            key = 'pa_' + key;
          }
          data['variation[attribute_' + key + ']'] = widget.product.variationOptions[i].selected;
          data['attribute_' + key] = widget.product.variationOptions[i].selected;
        } else if (widget.product.variationOptions[i].selected == null &&
            widget.product.variationOptions[i].optionList.length != 0) {
          showSnackBarError(context, appStateModel.blocks.localeText.select + ' ' + widget.product.variationOptions[i].name);
          doAdd = false;
          break;
        } else if (widget.product.variationOptions[i].selected == null &&
            widget.product.variationOptions[i].optionList.length == 0) {
          setState(() {
            widget.product.stockStatus = 'outofstock';
          });
          doAdd = false;
          break;
        }
      }
      if (widget.product.variationId != null) {
        data['variation_id'] = widget.product.variationId;
      }
    }
    if (doAdd) {
      /*if (addonFormKey.currentState != null && addonFormKey.currentState!.validate()) {
        addonFormKey.currentState!.save();
        data.addAll(addOnsFormData);
      }*/
      bool status = await context.read<ShoppingCart>().addToCartWithData(data, context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CartPage(),
          ));
    }
    setState(() {
      buyingNow = false;
    });
  }

  _chatWithVendor() {
    if(appStateModel.user.id > 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FireBaseChat(otherUserId: widget.product.vendor.UID!);
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
  }
}