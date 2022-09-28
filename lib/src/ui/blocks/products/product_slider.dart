import 'package:app/src/ui/blocks/products/percent_off.dart';
import 'package:app/src/ui/blocks/products/product_image.dart';
import 'package:app/src/ui/blocks/products/wishlist_icon.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import '../../../../src/ui/products/product_grid/products_widgets/price_widget.dart';
import '../banners/on_click.dart';
import './../../../models/product_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../src/models/blocks_model.dart';
import '../../../functions.dart';
import 'product_ratting.dart';

class ProductSlider extends StatefulWidget {
  final Block block;
  final List<Product> products;
  ProductSlider({Key? key, required this.block, required this.products}) : super(key: key);
  @override
  _ProductSliderState createState() => _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double padding = widget.block.mainAxisSpacing == 0 ? 16 : widget.block.mainAxisSpacing;

    ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color captionColor = theme.textTheme.caption!.color!;
    TextStyle subtitleTextStyle =
    style.copyWith(color: captionColor, fontSize: 12.0);

    //final tileTheme = ListTileTheme.of(context);
    //final Color color = tileTheme.textColor!;
    TextStyle titleStyle = theme.textTheme.subtitle1!;

    double mainAxisSpacingTop = widget.block.mainAxisSpacing;
    if(widget.block.headerAlign != 'none') {
      mainAxisSpacingTop = 0;
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Container(
              color: isDark ? Colors.transparent : widget.block.backgroundColor,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                      child: BannerTitle(block: widget.block)),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, widget.block.blockPadding.top, 0, widget.block.blockPadding.bottom),
                    height: widget.block.childHeight + widget.block.blockPadding.top + widget.block.blockPadding.bottom,
                    child: Swiper(
                      containerHeight: widget.block.childHeight,
                      itemBuilder: (BuildContext context, int index) {

                        Widget title = Text(parseHtmlString(widget.products[index].name), maxLines: 2, style: Theme.of(context).textTheme.bodyText2);


                        double marginLast = (index + 1) == widget.block.children.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
                        double marginFirst = index == 0 ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;

                        int percentOff = 0;
                        if ((widget.products[index].salePrice != 0)) {
                          percentOff = (((widget.products[index].regularPrice - widget.products[index].salePrice) / widget.products[index].regularPrice) * 100).round();
                        }

                        final Widget titleText = AnimatedDefaultTextStyle(
                          style: titleStyle,
                          duration: kThemeChangeDuration,
                          child: title,
                        );

                        return Container(
                          width: widget.block.childWidth,
                          child: Card(
                            elevation: widget.block.elevation,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(widget.block.borderRadius),
                            ),
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.fromLTRB(marginFirst, mainAxisSpacingTop, marginLast, widget.block.mainAxisSpacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    onProductClick(widget.products[index], context);
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 160,
                                        width: double.infinity,
                                        child: ProductCachedImage(imageUrl:  widget.products[index].images[0].src),
                                      ),
                                      WishListIconPositioned(id: widget.products[index].id),
                                      PercentOff(percentOff: percentOff)
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      titleText,
                                      /*widget.products[index].description.isNotEmpty ? Column(
                                        children: [
                                          SizedBox(height: 4),
                                          Text(parseHtmlString(widget.products[index].description),
                                              maxLines: 1,
                                              style: subtitleTextStyle),
                                        ],
                                      ) : Container(),
                                      SizedBox(height: 4),*/
                                      ProductRating(ratingCount: widget.products[index].ratingCount, averageRating: widget.products[index].averageRating),
                                      //SizedBox(height: 8),
                                      PriceWidget(product: widget.products[index])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: widget.products.length,
                      autoplay: true, viewportFraction: 0.5
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
