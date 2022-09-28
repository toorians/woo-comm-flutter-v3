import './../../../models/blocks_model.dart';
import './../../../models/vendor/store_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../functions.dart';
import '../banners/on_click.dart';

class StoreCardScroll extends StatefulWidget {
  final List<StoreModel> stores;
  final Block block;
  const StoreCardScroll({Key? key, required this.stores, required this.block}) : super(key: key);
  @override
  _StoreCardScrollState createState() => _StoreCardScrollState();
}

class _StoreCardScrollState extends State<StoreCardScroll> {
  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color captionColor = theme.textTheme.caption!.color!;
    TextStyle subtitleTextStyle =
    style.copyWith(color: captionColor, fontSize: 12.0);

    //final tileTheme = ListTileTheme.of(context);
    //final Color color = tileTheme.textColor!;
    TextStyle titleStyle = theme.textTheme.subtitle1!;
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
                  height: 270.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Widget title = Text(parseHtmlString(widget.stores[index].name), maxLines: 1, style: titleStyle);

                      double marginLast = (index + 1) == widget.block.children.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
                      double marginFirst = index == 0 ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;


                      final Widget titleText = AnimatedDefaultTextStyle(
                        style: titleStyle,
                        duration: kThemeChangeDuration,
                        child: title,
                      );
                      return Container(
                        width: 330,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.transparent,
                          elevation: 0,
                          margin: EdgeInsets.fromLTRB(marginFirst, 0, marginLast, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  onStoreClick(widget.stores[index], context);
                                },
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.all(0),
                                  elevation: widget.block.elevation,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(widget.block.borderRadius),
                                  ),
                                  child: Container(
                                    height: 160,
                                    width: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.stores[index].banner,
                                      placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                      errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    titleText,
                                    SizedBox(height: 4),
                                    Text(parseHtmlString(widget.stores[index].description),
                                        style: subtitleTextStyle),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          initialRating: widget.stores[index].averageRating,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          ignoreGestures: true,
                                          itemCount: 5,
                                          itemSize: 12,
                                          itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0.0),
                                          onRatingUpdate: (value) {},
                                          unratedColor: captionColor.withOpacity(0.3),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 4,
                                          ),
                                        ),
                                        if(widget.stores[index].ratingCount > 0)
                                        Text( ' ' + widget.stores[index].ratingCount.toString() + ' Review', style: Theme.of(context).textTheme.caption),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: widget.stores.length,
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
