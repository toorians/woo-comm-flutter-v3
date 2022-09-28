import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../ui/products/product_detail/product_detail.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import '../../../ui/products/product_grid/products_widgets/price_widget.dart';
import '../../../functions.dart';
import 'add_to_cart.dart';

class VariationProductAddToCart extends StatefulWidget {
  final Product product;
  const VariationProductAddToCart({Key? key, required this.product}) : super(key: key);
  @override
  _VariationProductAddToCartState createState() => _VariationProductAddToCartState();
}

class _VariationProductAddToCartState extends State<VariationProductAddToCart> {

  AvailableVariation? _selectedVariation;

  @override
  void initState() {
    if(widget.product.availableVariations.length > 0) {
      _selectedVariation = widget.product.availableVariations.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = Theme.of(context).textTheme.caption!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700
    );

    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return Column(
          children: [
            model.blocks.settings.listingAddToCart ? Column(
              children: [
                widget.product.availableVariations.length > 0 && _selectedVariation != null ? Column(
                  children: [
                    Align(alignment: AlignmentDirectional.centerStart, child: VariationPriceWidget(selectedVariation: _selectedVariation!)),
                    SizedBox(height: 8,),
                    Container(
                      height: 25,
                      child: OutlinedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTitle(_selectedVariation),style: _textStyle,),
                                Icon(Icons.keyboard_arrow_down, size: 16, color: Theme.of(context).textTheme.caption!.color)
                              ],
                            ),
                          ),
                          onPressed: (){
                            _selectVariant(context);
                          },
                          //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(2.0))
                      ),
                    ),
                  ],
                ) : Align(alignment: AlignmentDirectional.centerStart, child: PriceWidget(product: widget.product)),
                SizedBox(height: 16),
                AddToCart(product: widget.product, model: model, variation: _selectedVariation),
              ],
            ) : Align(alignment: AlignmentDirectional.centerStart, child: PriceWidget(product: widget.product)),
            SizedBox(height: 8)
          ],
        );
      }
    );
  }

  Future<Product> _selectVariant(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            titlePadding: EdgeInsets.only(top: 10,bottom: 0),
            elevation: 4,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Available quantities for',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                    //letterSpacing: 1
                  ),),
                SizedBox(height: 8,),
                Text(widget.product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    //letterSpacing: 1
                  ),
                ),
              ],
            ),
            children: _buildVariationList(),
          );
        });
  }

  _buildVariationList() {
    List<Widget> list = [];
    widget.product.availableVariations.forEach((element) {
      list.add(
        element != null ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(
            ),
            buildSimpleDialog(context, element),
          ],
        ) : Container(),
      );
    });
    return list;
  }

  Widget buildSimpleDialog(BuildContext context, AvailableVariation variation) {
    return variation != null ? ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        color: _selectedVariation == variation ? Colors.black87 : Colors.white,
        child: Center(
          child: SimpleDialogOption(
            onPressed: () {
              setState(() {
                _selectedVariation = variation;
              });
              Navigator.of(context).pop();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTitle(variation) , style:TextStyle(
                      fontSize: 12,
                      color: _selectedVariation == variation ? Colors.white : Colors.black87
                  ),),
                  _variationPrice(variation),
                ]
            ),
          ),
        ),
      ),
    ) : Container();
  }

  getTitle(AvailableVariation? variation) {
    var name = '';
    if(variation != null)
    for (var value in variation.option) {
      if(value.value.isNotEmpty)
        name = name + value.value + ' ';
    }
    return name;
  }

  _variationPrice(AvailableVariation variation) {
    if(variation.formattedPrice != null && variation.formattedSalesPrice == null) {
      return Text(parseHtmlString(variation.formattedPrice!), style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _selectedVariation == variation ? Colors.white : Colors.black38,
      ));
    } else if(variation.formattedPrice != null && variation.formattedSalesPrice != null) {
      return Row(
        children: [
          Text(parseHtmlString(variation.formattedPrice!), style: TextStyle(
            fontSize: 10,
            decoration: TextDecoration.lineThrough,
            color: _selectedVariation == variation ? Colors.white : Colors.black38,
          )),
          SizedBox(width: 4),
          Text(parseHtmlString(variation.formattedSalesPrice!), style: TextStyle(
              fontWeight: FontWeight.bold, color: _selectedVariation == variation ? Colors.white : Colors.black
          )),
        ],
      );
    } else return Container();
  }

  onProductClick() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: widget.product);
    }));
  }
}

