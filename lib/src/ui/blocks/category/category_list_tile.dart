import 'package:app/src/models/category_model.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';
import './../../../models/blocks_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../functions.dart';

class CategoryListTile extends StatefulWidget {
  final Block block;
  final List<Category> categories;
  final String? type;
  const CategoryListTile({Key? key, required this.block, required this.categories, this.type}) : super(key: key);
  @override
  _CategoryListTileState createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color captionColor = theme.textTheme.caption!.color!;
    TextStyle subtitleTextStyle =
    style.copyWith(color: captionColor, fontSize: 12.0);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    int count = widget.categories.length;

    if(widget.categories.length > 0 && widget.block.headerAlign != 'none') {
      count = widget.categories.length + 1;
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

            return Column(
              children: [
                ListTile(
                  tileColor: isDark ? Colors.transparent : widget.block.backgroundColor,
                  minLeadingWidth: 56,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  onTap: () {
                    if(widget.type == 'brand') {
                      onBrandClick(widget.categories[index], context);
                    } else {
                      onCategoryClick(widget.categories[index], context);
                    }
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
                          imageUrl: widget.categories[index].image,
                          placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                          errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                          fit: BoxFit.cover,
                        ),
                      )
                  ),
                  title: Text(parseHtmlString(widget.categories[index].name), maxLines: 2),
                  subtitle: (widget.categories[index].description == null || widget.categories[index].description.isEmpty) ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2),
                      Text(parseHtmlString(widget.categories[index].description), maxLines: 2),
                      SizedBox(height: 2),
                      widget.categories[index].count > 0 ? Text(widget.categories[index].count.toString() + ' Products', style: subtitleTextStyle,) : Container()
                    ],
                  ),
                ),
                Divider(height: 0)
              ],
            );
          },
          childCount: count,
        ),
      ),
    );
  }
}
