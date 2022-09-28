import 'package:app/src/ui/blocks/products/percent_off.dart';
import 'package:app/src/ui/blocks/products/product_image.dart';
import 'package:app/src/ui/blocks/products/wishlist_icon.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import './../../../ui/products/product_grid/products_widgets/price_widget.dart';
import './../../../models/blocks_model.dart';
import './../../../models/product_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:flutter/material.dart';
import '../../../functions.dart';
import '../banners/on_click.dart';
import 'product_ratting.dart';

class ProductBlockGrid extends StatefulWidget {
  final Block block;
  final List<Product> products;
  const ProductBlockGrid({Key? key, required this.block, required this.products}) : super(key: key);
  @override
  _ProductBlockGridState createState() => _ProductBlockGridState();
}

class _ProductBlockGridState extends State<ProductBlockGrid> {
  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color captionColor = theme.textTheme.caption!.color!;
    TextStyle subtitleTextStyle =
    style.copyWith(color: captionColor, fontSize: 12.0);

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    double mainAxisSpacingTop = widget.block.mainAxisSpacing;
    if(widget.block.headerAlign != 'none') {
      mainAxisSpacingTop = 0;
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
        child: widget.block.horizontal ? Container(
          margin: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
          child: Container(
            color: isDark ? Colors.transparent : widget.block.backgroundColor,
            padding: EdgeInsets.only(top: widget.block.blockPadding.top, bottom: widget.block.blockPadding.bottom),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: widget.block.blockPadding.left, right: widget.block.blockPadding.right),
                    child: BannerTitle(block: widget.block)),
                Container(
                  height: widget.block.childHeight,
                  child: GridView.count(
                    primary: false,
                    crossAxisSpacing: widget.block.crossAxisSpacing,
                    mainAxisSpacing: widget.block.mainAxisSpacing,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    childAspectRatio: widget.block.childAspectRatio,
                    padding: EdgeInsets.only(left: widget.block.blockPadding.left, right: widget.block.blockPadding.right),
                    crossAxisCount: widget.block.crossAxisCount,
                    children: _buildBlockList(),
                  ),
                )
              ],
            ),
          ),
        ) : Container(
          color: isDark ? Colors.transparent : widget.block.backgroundColor,
          padding: EdgeInsets.fromLTRB(widget.block.mainAxisSpacing, mainAxisSpacingTop, widget.block.mainAxisSpacing, widget.block.mainAxisSpacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BannerTitle(block: widget.block),
              GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(widget.block.blockPadding.left, widget.block.blockPadding.top, widget.block.blockPadding.right, widget.block.blockPadding.bottom),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: widget.block.maxCrossAxisExtent,
                    mainAxisSpacing: widget.block.mainAxisSpacing,
                    crossAxisSpacing: widget.block.crossAxisSpacing,
                    childAspectRatio: widget.block.childWidth/widget.block.childHeight,
                  ),
                  itemCount: widget.products.length,
                  itemBuilder: (BuildContext ctx, index) {

                    int percentOff = 0;
                    if ((widget.products[index].salePrice != 0)) {
                      percentOff = (((widget.products[index].regularPrice - widget.products[index].salePrice) / widget.products[index].regularPrice) * 100).round();
                    }

                    return InkWell(
                      onTap: () async {
                        onProductClick(widget.products[index], context);
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Card(
                                color: Colors.transparent,
                                clipBehavior: Clip.antiAlias,
                                margin: EdgeInsets.all(0),
                                elevation: widget.block.elevation,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(widget.block.borderRadius),
                                ),
                                child: ProductCachedImage(imageUrl: widget.products[index].images[0].src),
                              ),
                              WishListIconPositioned(id: widget.products[index].id),
                              PercentOff(percentOff: percentOff)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(parseHtmlString(widget.products[index].name), maxLines: 2, style: Theme.of(context).textTheme.bodyText2),
                              SizedBox(height: 4),
                              /*Text(parseHtmlString(widget.products[index].description), maxLines: 1, style: subtitleTextStyle),
                              SizedBox(height: 4),*/
                              ProductRating(ratingCount: widget.products[index].ratingCount, averageRating: widget.products[index].averageRating),
                              PriceWidget(product: widget.products[index])
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _buildBlockList() {
    List<Widget> list = [];

    ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color captionColor = theme.textTheme.caption!.color!;
    TextStyle subtitleTextStyle =
    style.copyWith(color: captionColor, fontSize: 12.0);

    widget.products.forEach((element) {
      list.add(Card(
        //color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(0),
        elevation: widget.block.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.block.borderRadius),
        ),
        child: InkWell(
          radius: widget.block.borderRadius,
          onTap: () async {
            onProductClick(element, context);
          },
          child: Column(
            children: [
              ProductCachedImage(imageUrl: element.images[0].src),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(parseHtmlString(element.name), maxLines: 1,),
                    SizedBox(height: 4),
                    /*Text(parseHtmlString(element.description), maxLines: 1, style: subtitleTextStyle),
                    SizedBox(height: 4),*/
                    RatingBar.builder(
                      initialRating: double.parse(element.averageRating),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 12,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      unratedColor: captionColor.withOpacity(0.3),
                      onRatingUpdate: (value) {},
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 4,
                      ),
                    ),
                    if(element.ratingCount > 0)
                      Text(element.ratingCount.toString() + ' Review', style: Theme.of(context).textTheme.caption),
                    SizedBox(width: 8),
                    PriceWidget(product: element)
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    });

    return list;
  }
}
