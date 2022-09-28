import './../../../models/blocks_model.dart';
import './../../../models/vendor/store_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../functions.dart';
import '../banners/on_click.dart';

class StoreList extends StatefulWidget {
  final List<StoreModel> stores;
  final Block block;
  const StoreList({Key? key, required this.stores, required this.block}) : super(key: key);
  @override
  _StoreListState createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color captionColor = theme.textTheme.caption!.color!;
    TextStyle subtitleTextStyle =
    style.copyWith(color: captionColor, fontSize: 12.0);
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
                onStoreClick(widget.stores[index], context);
              },
              child: Column(
                children: [
                  ListTile(
                    tileColor: isDark ? Colors.transparent : widget.block.backgroundColor,
                    minLeadingWidth: 56,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    onTap: () {
                      onStoreClick(widget.stores[index], context);
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
                          child: CachedNetworkImage(
                            imageUrl: widget.stores[index].icon,
                            placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                            errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                            fit: BoxFit.cover,
                          ),
                        )
                    ),
                    title: Text(parseHtmlString(widget.stores[index].name), maxLines: 2),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(parseHtmlString(widget.stores[index].description), maxLines: 1, style: subtitleTextStyle),
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
                              itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
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
                            SizedBox(width: 8),
                          ],
                        ),
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
