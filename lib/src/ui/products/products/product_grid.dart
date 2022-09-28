import 'package:app/src/ui/blocks/products/percent_off.dart';
import 'package:app/src/ui/blocks/products/product_image.dart';
import 'package:app/src/ui/blocks/products/wishlist_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../ui/blocks/products/product_ratting.dart';
import '../../../ui/products/product_detail/product_detail.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import '../../../ui/products/product_grid/products_widgets/price_widget.dart';
import '../../../functions.dart';
import 'add_to_cart.dart';
import 'product_label.dart';

class ProductItemCard extends StatefulWidget {
  final Product product;
  const ProductItemCard({Key? key, required this.product}) : super(key: key);
  @override
  _ProductItemCardState createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard> {

  AvailableVariation? _selectedVariation;
  int percentOff = 0;

  @override
  void initState() {
    if(widget.product.availableVariations.length > 0) {
      _selectedVariation = widget.product.availableVariations.first;
    }
    if ((widget.product.salePrice != 0)) {
      percentOff = (((widget.product.regularPrice - widget.product.salePrice) / widget.product.regularPrice) * 100).round();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = Theme.of(context).textTheme.caption!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700
    );

    return Stack(
      children: [
        ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () => onProductClick(),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                                constraints: new BoxConstraints(
                                  minHeight: (MediaQuery.of(context).size.width / 2) - ( 2 * 4),
                                ),
                                //height: (MediaQuery.of(context).size.width / 2) - ( 2 * 4),
                                child: ProductCachedImage(imageUrl:  widget.product.images[0].src)
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        widget.product.tags.contains('fresh') ? Container(
                                          height: 18,
                                          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                          decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius: BorderRadius.all(Radius.circular(2)
                                            ),),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Icon(Icons.fiber_manual_record_sharp, size: 9, color: Colors.green),
                                                SizedBox(width: 4),
                                                Text('Fresh',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.w600,
                                                    //letterSpacing: 1
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ) : Container(),
                                        Spacer(),
                                        widget.product.tags.contains('express') ? Container(
                                          height: 18,
                                          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                          decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius: BorderRadius.all(Radius.circular(2)
                                            ),),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              //Image.asset('lib/assets/images/bike.webp',width: 20, height: 8,fit: BoxFit.fill, color:Colors.grey),
                                              Text('Express',
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w600,
                                                  //letterSpacing: 1
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(Icons.pedal_bike_rounded, size: 10, color: Colors.black45,),
                                              /**/
                                            ],
                                          ),
                                        ) : Container(),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(widget.product.name, maxLines: 2, style: Theme.of(context).textTheme.bodyText2,),
                                    ),
                                    SizedBox(height: 4),
                                    ProductRating(ratingCount: widget.product.ratingCount, averageRating: widget.product.averageRating),
                                    //SizedBox(height: 8),
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
                                                      Text(getTitle(_selectedVariation!),style: _textStyle,),
                                                      Icon(Icons.keyboard_arrow_down, size: 16, color: Theme.of(context).textTheme.caption!.color)
                                                    ],
                                                  ),
                                                ),
                                                onPressed: (){
                                                  _selectVariant(context);
                                                },
                                              ),
                                            ),
                                          ],
                                        ) : Align(alignment: AlignmentDirectional.centerStart, child: PriceWidget(product: widget.product)),
                                        SizedBox(height: 16),
                                        AddToCart(product: widget.product, model: model, variation: _selectedVariation),
                                      ],
                                    ) : Align(alignment: AlignmentDirectional.centerStart, child: PriceWidget(product: widget.product)),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 30,
                        left: 0,
                        child: ProductLabel(widget.product.tags)
                    ),
                    WishListIconPositioned(id: widget.product.id)
                  ],
                ),
              );
            }
        ),
        PercentOff(percentOff: percentOff)
      ],
    );
  }

  Future<Product?> _selectVariant(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            //backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
            titlePadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            elevation: 4,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    //color: Colors.black,
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
        element.isInStock ? buildSimpleDialog(context, element) : Container(),
      );
    });
    return list;
  }

  Widget buildSimpleDialog(BuildContext context, AvailableVariation? variation) {
    return variation != null ? Container(
      color: _selectedVariation == variation ? Theme.of(context).colorScheme.secondary : Colors.transparent,
      child: Center(
        child: SimpleDialogOption(
          onPressed: () {
            setState(() {
              _selectedVariation = variation;
            });
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTitle(variation) , style:TextStyle(
                      fontSize: 12,
                      color: _selectedVariation == variation ? Theme.of(context).colorScheme.onSecondary : null
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
        color: _selectedVariation == variation ? Theme.of(context).colorScheme.onSecondary : Colors.black38,
      ));
    } else if(variation.formattedPrice != null && variation.formattedSalesPrice != null) {
      return Row(
        children: [
          Text(parseHtmlString(variation.formattedSalesPrice!), style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _selectedVariation == variation ? Theme.of(context).colorScheme.onSecondary : Colors.black
          )),
          SizedBox(width: 4),
          Text(parseHtmlString(variation.formattedPrice!), style: TextStyle(
            fontSize: 10,
            decoration: TextDecoration.lineThrough,
            color: _selectedVariation == variation ? Theme.of(context).colorScheme.onSecondary.withOpacity(0.7) : Colors.black38,
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