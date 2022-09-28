import '../banners/on_click.dart';
import './../../../models/blocks_model.dart';
import './../../../models/vendor/store_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../functions.dart';

class StoreCard extends StatefulWidget {
  final List<StoreModel> stores;
  final Block block;
  const StoreCard({Key? key, required this.stores, required this.block}) : super(key: key);
  @override
  _StoreCardState createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
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

    int count = widget.block.stores.length;

    if(widget.block.stores.length > 0 && widget.block.headerAlign != 'none') {
      count = widget.block.stores.length + 1;
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {

            double paddingTop = index == 0 ? widget.block.blockPadding.top : 0;
            double paddingBottom = (index + 1) == widget.stores.length ? widget.block.blockPadding.bottom : 0;

            double marginLast = (index + 1) == widget.stores.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
            double marginFirst = index == 0 ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;

            if(widget.block.headerAlign != 'none') {
              marginLast = index == widget.stores.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
              marginFirst = index == 1 ? widget.block.mainAxisSpacing / 2 : widget.block.mainAxisSpacing / 2;
              paddingTop = index == 1 ? widget.block.blockPadding.top : 0;
              paddingBottom = index == widget.stores.length ? widget.block.blockPadding.bottom : 0;
            }

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

            Widget title = Text(parseHtmlString(widget.stores[index].name), maxLines: 1, style: titleStyle);

            final Widget titleText = AnimatedDefaultTextStyle(
              style: titleStyle,
              duration: kThemeChangeDuration,
              child: title,
            );

            return GestureDetector(
              onTap: () {
                onStoreClick(widget.stores[index], context);
              },
              child: Container(
                color: isDark ? Colors.transparent : widget.block.backgroundColor,
                child: Container(
                  margin: EdgeInsets.fromLTRB(widget.block.blockPadding.left, paddingTop, widget.block.blockPadding.right, paddingBottom),
                  child: Card(
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    margin: EdgeInsets.fromLTRB(widget.block.mainAxisSpacing, marginFirst, widget.block.mainAxisSpacing, marginLast),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.block.borderRadius),
                    ),
                    child: Column(
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
                            child: Stack(
                              children: [
                                Container(
                                  height: widget.block.childHeight,
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.stores[index].banner,
                                    placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                    errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  left: 10.0,
                                  bottom: 10.0,
                                  child: Row(
                                    children: <Widget>[
                                      widget.stores[index].icon.isNotEmpty ? CircleAvatar(
                                        backgroundImage: CachedNetworkImageProvider(widget.stores[index].icon),
                                        backgroundColor: Colors.black12,
                                      ) : CircleAvatar(
                                        //TODO ADD AssetImage as placeholder
                                        backgroundImage: CachedNetworkImageProvider(widget.stores[index].icon),
                                        backgroundColor: Colors.black12,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    right: 10,
                                    top: 10,
                                    child: Card(
                                        color: widget.stores[index].isClosed ? Colors.red : Colors.green,
                                        clipBehavior: Clip.antiAlias,
                                        margin: EdgeInsets.zero,
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                                          child: Text( widget.stores[index].isClosed ? 'CLOSED' : 'OPEN', style: TextStyle(color: Colors.white),),
                                        )
                                    )
                                ),
                                widget.stores[index].deliveryTime.isNotEmpty ? Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: Card(
                                        color: Colors.white,
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                                          child: Text(widget.stores[index].deliveryTime, style: TextStyle(color: Colors.black),),
                                        )
                                    )
                                ) : Container(),
                              ],
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
                                    unratedColor: captionColor.withOpacity(0.3),
                                    onRatingUpdate: (value) {},
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
                ),
              ),
            );
          },
          childCount: count,
        ),
      ),
    );
  }
}
