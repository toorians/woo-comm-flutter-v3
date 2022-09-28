import 'package:app/src/ui/products/product_grid/products_widgets/grouped_poducts.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../../../pages/webview.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/product_model.dart';
import 'grouped_products.dart';
import 'variations_products.dart';

class AddButtonDetail extends StatefulWidget {

  AddButtonDetail({
    Key? key,
    this.addonFormKey,
    this.addOnsFormData,
    required this.product,
    required this.model,
  }) : super(key: key);

  final Product product;
  final AppStateModel model;
  final GlobalKey<FormState>? addonFormKey;
  final Map<String, dynamic>? addOnsFormData;
  
  @override
  _AddButtonDetailState createState() => _AddButtonDetailState();
}

class _AddButtonDetailState extends State<AddButtonDetail> {
  
  var isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    if(getQty() != 0 || isLoading)
      return Container(
        color: Theme.of(context).buttonTheme.colorScheme!.primary,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 70,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).buttonTheme.colorScheme!.onPrimary),
                tooltip: 'Decrease quantity by 1',
                onPressed: () async {
                  if(widget.product.type == 'variable' || widget.product.type == 'grouped') {
                    _bottomSheet(context);
                  } else {
                    bool status = await context.read<ShoppingCart>().decreaseQty(context, widget.product.id);
                  }
                },
              ),
              isLoading ? SizedBox(
                child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).buttonTheme.colorScheme!.onPrimary),
                height: 20.0,
                width: 20.0,
              ) :  SizedBox(
                width: 20.0,
                child: Text(getQty().toString(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color:Theme.of(context).buttonTheme.colorScheme!.onPrimary
                ),),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Theme.of(context).buttonTheme.colorScheme!.onPrimary),
                tooltip: 'Increase quantity by 1',
                onPressed: () async {
                  if(widget.product.type == 'variable' || widget.product.type == 'grouped') {
                    _bottomSheet(context);
                  } else {
                    bool status = await context.read<ShoppingCart>().increaseQty(context, widget.product.id);
                  }
                },
              ),
            ],
          ),
        ),
      );
    else return SizedBox(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(0.0),
          ),
          elevation: 0
        ),
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: widget.product.type != 'external' ? Text(widget.model.blocks.localeText.
          addToCart) : Text(widget.model.blocks.localeText.
          buyNow),
        ),
        onPressed: widget.product.stockStatus == 'outofstock' ? null : () {
          if(widget.product.type == 'variable' || widget.product.type == 'grouped') {
            _bottomSheet(context);
          } else {
            addToCart(context);
          }
        },
      ),
    );
  }

  addToCart(BuildContext context) async {
    if(widget.product.type != 'external') {
      var data = new Map<String, dynamic>();
      data['product_id'] = widget.product.id.toString();
      data['quantity'] = '1';

      if(widget.addonFormKey != null && widget.addonFormKey!.currentState!.validate()) {
        widget.addonFormKey!.currentState!.save();
        data.addAll(widget.addOnsFormData!);
      }
      setState(() {
        isLoading = true;
      });
      bool status = await context.read<ShoppingCart>().addToCartWithData(data, context);
      setState(() {
        isLoading = false;
      });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => WebViewPage(url: widget.product.addToCartUrl, title: widget.product.name),
          ));
    }

  }

/*  decreaseQty() async {
    if (widget.model.shoppingCart.cartContents.isNotEmpty) {
      if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id)) {
        final cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id);
        setState(() {
          isLoading = true;
        });
        await widget.model.decreaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  increaseQty() async {
    if (widget.model.shoppingCart.cartContents.length > 0) {
      if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id)) {
        final cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id);
        setState(() {
          isLoading = true;
        });
        bool status = await widget.model.increaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }*/

  getQty() {
    var count = 0;
    if(context.read<ShoppingCart>().cart.cartContents.any((element) => element.productId == widget.product.id)) {
      if(widget.product.type == 'variable') {
        context.read<ShoppingCart>().cart.cartContents.where((variation) => variation.productId == widget.product.id).toList().forEach((e) => {
          count = count + e.quantity
        });
        return count;
      } else return context.read<ShoppingCart>().cart.cartContents.firstWhere((element) => element.productId == widget.product.id).quantity;
    } else return count;
  }

  void _bottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Text(widget.product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                if (widget.product.type == 'variable') Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.availableVariations.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return VariationProduct(id: widget.product.id, variation: widget.product.availableVariations[Index], addOnsFormData: widget.addOnsFormData, addonFormKey: widget.addonFormKey,);
                      }
                  ),
                ) else widget.product.children.length > 0 ? Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.children.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return GroupedProduct(context: ctxt, id: widget.product.id, product: widget.product.children[Index]);
                      }
                  ),
                ) : Container(),
              ],
            ),
          ),
        );
      },
    );
  }

}
