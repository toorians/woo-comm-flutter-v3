import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import './../../../../models/app_state_model.dart';
import './../../../../models/product_model.dart';
import '../../../../functions.dart';

class VariationProduct extends StatefulWidget {

  VariationProduct({
    Key? key,
    this.addonFormKey,
    this.addOnsFormData,
    required this.id,
    required this.variation,
  }) : super(key: key);

  final int id;
  final AvailableVariation variation;
  final GlobalKey<FormState>? addonFormKey;
  final Map<String, dynamic>? addOnsFormData;
  final model = AppStateModel();

  @override
  _VariationProductState createState() => _VariationProductState();
}

class _VariationProductState extends State<VariationProduct> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: leadingIcon(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(parseHtmlString(getTitle())),
          SizedBox(height: 4),
          _variationPrice()
        ],
      ),
      trailing: (getQty() != 0 || isLoading) ? ButtonBar(
        alignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 30,
            width: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                primary: Colors.grey.withOpacity(0.3),
                elevation: 0,
                onPrimary: isDark ? Colors.white : Colors.black,
                padding: EdgeInsets.all(0),
              ),
              child: new Icon(Icons.remove, size: 18),
              onPressed: () async {
                bool status = await context.read<ShoppingCart>().decreaseQty(context, widget.id, variationId: widget.variation.variationId);
              },
            ),
          ),
          isLoading ? SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2),
            height: 20.0,
            width: 20.0,
          ) :  SizedBox(
            width: 20.0,
            child: Text(getQty().toString(), textAlign: TextAlign.center,),
          ),
          SizedBox(
            height: 30,
            width: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                elevation: 0,
                padding: EdgeInsets.all(0),
              ),
              child: new Icon(Icons.add, size: 18),
              onPressed: () async {
                bool status = await context.read<ShoppingCart>().increaseQty(context, widget.id, variationId: widget.variation.variationId);
              },
            ),
          ),
        ],
      ) : SizedBox(
        height: 30,
        child: TextButton(
          child: Text(widget.model.blocks.localeText.add.toUpperCase()),
          onPressed: () => addToCart(context),
        ),
      ),
    );
  }

  getTitle() {
    var name = '';
    for (var value in widget.variation.option) {
      if(value.value != null)
      name = name + value.value + ' ';
    }
    return name;
  }

  Container leadingIcon() {
    return Container(
      width: 45,
      height: 45,
      child: CachedNetworkImage(
        imageUrl: widget.variation.image.url.isNotEmpty ? widget.variation.image.url : '',
        imageBuilder: (context, imageProvider) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          margin: EdgeInsets.all(0.0),
          //shape: StadiumBorder(),
          child: Ink.image(
            child: InkWell(
              onTap: () {
                //onCategoryClick(category);
              },
            ),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (context, url) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          //shape: StadiumBorder(),
        ),
        errorWidget: (context, url, error) => Card(
          elevation: 0.0,
          color: Colors.white,
          //shape: StadiumBorder(),
        ),
      ),
    );
  }

  addToCart(BuildContext context) async {
    var data = new Map<String, dynamic>();
    data['product_id'] = widget.id.toString();
    data['variation_id'] = widget.variation.variationId.toString();
    data['quantity'] = '1';
    setState(() {
      isLoading = true;
    });
    if(widget.addonFormKey != null && widget.addonFormKey!.currentState!.validate()) {
      widget.addonFormKey!.currentState!.save();
      data.addAll(widget.addOnsFormData!);
    }
    bool status = await context.read<ShoppingCart>().addToCartWithData(data, context);
    setState(() {
      isLoading = false;
    });
    if(!status) {
      Navigator.of(context).pop();
    }
  }

  /*decreaseQty() async {
    if (widget.model.shoppingCart.cartContents.isNotEmpty) {
      if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.variationId == widget.variation.variationId)) {
        final cartContent = widget.model.shoppingCart.cartContents.singleWhere((cartContent) => cartContent.variationId == widget.variation.variationId);
        setState(() {
          isLoading = true;
        });
        bool status = await widget.model.decreaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
        if(!status) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  increaseQty() async {
    if (widget.model.shoppingCart.cartContents.isNotEmpty) {
      if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.variationId == widget.variation.variationId)) {
        final cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.variationId == widget.variation.variationId);
        setState(() {
          isLoading = true;
        });
        bool status = await widget.model.increaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
        if(!status) {
          Navigator.of(context).pop();
        }
      }
    }
  }*/

  getQty() {
    if(context.read<ShoppingCart>().cart.cartContents.any((element) => element.variationId == widget.variation.variationId)) {
      return context.read<ShoppingCart>().cart.cartContents.firstWhere((element) => element.variationId == widget.variation.variationId).quantity;
    } else return 0;
  }

  _variationPrice() {
    if(widget.variation.formattedPrice != null && widget.variation.formattedSalesPrice == null) {
      return Text(parseHtmlString(widget.variation.formattedPrice!), style: TextStyle(
        fontWeight: FontWeight.w600,
      ));
    } else if(widget.variation.formattedPrice != null && widget.variation.formattedSalesPrice != null) {
      return Row(
        children: [
          Text(parseHtmlString(widget.variation.formattedSalesPrice!), style: TextStyle(
          fontWeight: FontWeight.w600,
      )),
          SizedBox(width: 4),
          Text(parseHtmlString(widget.variation.formattedPrice!), style: TextStyle(
            fontSize: 10,
            decoration: TextDecoration.lineThrough
          )),
        ],
      );
    }
  }
}