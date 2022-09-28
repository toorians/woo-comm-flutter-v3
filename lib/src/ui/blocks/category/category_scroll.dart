import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../src/models/category_model.dart';
import '../../../../src/functions.dart';
import '../../../../src/models/blocks_model.dart';
import '../banners/banner_title.dart';
import '../banners/on_click.dart';

class CategoryScroll extends StatefulWidget {
  final Block block;
  final List<Category> categories;
  final String? type;
  const CategoryScroll({Key? key, required this.block, required this.categories, this.type}) : super(key: key);
  @override
  _CategoryScrollState createState() => _CategoryScrollState();
}

class _CategoryScrollState extends State<CategoryScroll> {
  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    final Color captionColor = theme.textTheme.caption!.color!;

    //final tileTheme = ListTileTheme.of(context);
    //final Color color = tileTheme.textColor!;
    TextStyle titleStyle = theme.textTheme.subtitle1!.copyWith(fontSize: 12);
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    double padding = widget.block.mainAxisSpacing == 0 ? 16 : widget.block.mainAxisSpacing;

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
      sliver: SliverToBoxAdapter(
        child: Card(
          elevation: 0,
          color: isDark ? Colors.transparent : widget.block.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(widget.block.blockPadding.left, widget.block.blockPadding.top, widget.block.blockPadding.right, widget.block.blockPadding.bottom),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                    child: BannerTitle(block: widget.block)),
                Container(
                  height: widget.block.childHeight + 34,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {

                      Widget title = Text(parseHtmlString(widget.categories[index].name), maxLines: 1, style: titleStyle);

                      double marginLast = (index + 1) == widget.categories.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
                      double marginFirst = index == 0 ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;

                      final Widget titleText = AnimatedDefaultTextStyle(
                        style: titleStyle,
                        duration: kThemeChangeDuration,
                        maxLines: 2,
                        child: title,
                        textAlign: TextAlign.center,
                      );

                      return Container(
                        width: widget.block.childWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              elevation: widget.block.elevation,
                              margin: EdgeInsets.fromLTRB(marginFirst, 0, marginLast, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(widget.block.borderRadius),
                              ),
                              child: InkWell(
                                radius: widget.block.borderRadius,
                                onTap: () {
                                  if(widget.type == 'brand') {
                                    onBrandClick(widget.categories[index], context);
                                  } else {
                                    onCategoryClick(widget.categories[index], context);
                                  }
                                },
                                child: Container(
                                  height: widget.block.childHeight,
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.categories[index].image,
                                    placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.05),),
                                    errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.05),),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: widget.block.childWidth,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: titleText,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                      );
                    },
                    itemCount: widget.categories.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
