import 'package:app/src/functions.dart';
import '../banners/on_click.dart';
import '../../../../src/models/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../src/models/blocks_model.dart';
import '../banners/banner_title.dart';


class CategoryGrid extends StatefulWidget {
  final Block block;
  final List<Category> categories;
  final String? type;
  const CategoryGrid({Key? key, required this.block, required this.categories, this.type}) : super(key: key);
  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {

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
            padding: EdgeInsets.only(top: widget.block.blockPadding.top),
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
                    padding: EdgeInsets.only(bottom: widget.block.blockPadding.bottom, left: widget.block.blockPadding.left, right: widget.block.blockPadding.right),
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
                  itemCount: widget.categories.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Card(
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.all(0),
                      elevation: widget.block.elevation,
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
                          height: double.infinity,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: widget.categories[index].image,
                            placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                            errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                            fit: BoxFit.cover,
                          ),
                        ),
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
    bool isDark = theme.brightness == Brightness.dark;
    final TextStyle style = theme.textTheme.bodyText1!;
    final Color captionColor = theme.textTheme.bodyText1!.color!;
    TextStyle subtitleTextStyle = style.copyWith(color: captionColor, fontSize: 12.0);

    widget.categories.forEach((element) {
      list.add(Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(0),
        elevation: widget.block.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.block.borderRadius),
        ),
        child: InkWell(
          radius: widget.block.borderRadius,
          onTap: () {
            if(widget.type == 'brand') {
              onBrandClick(element, context);
            } else {
              onCategoryClick(element, context);
            }
          },
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: element.image,
                placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                fit: BoxFit.cover,
              ),
              //SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(parseHtmlString(element.name), maxLines: 3, style: subtitleTextStyle, textAlign: TextAlign.center),
              ),
              //SizedBox(height: 4),
            ],
          ),
        ),
      ));
    });

    return list;
  }
}
