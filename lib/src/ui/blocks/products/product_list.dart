import 'package:app/src/ui/blocks/products/product_image.dart';
import './../../../ui/products/product_grid/products_widgets/price_widget.dart';
import './../../../models/blocks_model.dart';
import './../../../models/product_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:flutter/material.dart';
import '../../../functions.dart';
import '../banners/on_click.dart';
import 'product_ratting.dart';

class ProductList extends StatefulWidget {
  final List<Product> products;
  final Block block;
  const ProductList({Key? key, required this.products, required this.block}) : super(key: key);
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color captionColor = theme.textTheme.caption!.color!;
    TextStyle subtitleTextStyle =
    style.copyWith(color: captionColor, fontSize: 12.0);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    int count = widget.block.children.length;

    if(widget.block.products.length > 0 && widget.block.headerAlign != 'none') {
      count = widget.block.products.length + 1;
    }
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {

              if(index == 0 && widget.block.headerAlign != 'none') {
                double padding = widget.block.mainAxisSpacing == 0 ? 16 : widget.block.mainAxisSpacing;
                return Container(
                    padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                    color: isDark ? Colors.transparent : widget.block.backgroundColor,
                    child: BannerTitle(block: widget.block)
                );
              }

              if(index != 0 && widget.block.headerAlign != 'none') {
                index = index - 1;
              }

            return GestureDetector(
              onTap: () {
                onProductClick(widget.products[index], context);
              },
              child: Column(
                children: [
                  ListTile(
                    tileColor: isDark ? Colors.transparent : widget.block.backgroundColor,
                    minLeadingWidth: 56,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    onTap: () {
                      onProductClick(widget.products[index], context);
                    },
                    dense: false,
                    leading: Container(
                        width: 56,
                        height: 56,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.all(0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(widget.block.borderRadius),
                          ),
                          child: ProductCachedImage(imageUrl: widget.products[index].images[0].src),
                        )
                    ),
                    title: Text(parseHtmlString(widget.products[index].name), maxLines: 2),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*widget.products[index].description.isNotEmpty ? Column(
                          children: [
                            SizedBox(height: 4),
                            Text(parseHtmlString(widget.products[index].description), maxLines: 1, style: subtitleTextStyle),
                          ],
                        ) : Container(),*/
                        SizedBox(height: 4),
                        ProductRating(ratingCount: widget.products[index].ratingCount, averageRating: widget.products[index].averageRating),
                        PriceWidget(product: widget.products[index])
                      ],
                    ),
                  ),
                  Divider(height: 0)
                ],
              ),
            );
          },
          childCount: count,
        ),
      ),
    );
  }
}
