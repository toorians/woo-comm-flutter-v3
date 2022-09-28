import 'package:app/src/ui/blocks/banners/on_click.dart';
import '../../../functions.dart';
import '../../../../src/models/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../src/models/blocks_model.dart';
import '../banners/banner_title.dart';


class CategoryPresets extends StatefulWidget {
  final Block block;
  final List<Category> categories;
  final String? type;
  const CategoryPresets({Key? key, required this.block, required this.categories, this.type}) : super(key: key);
  @override
  _CategoryPresetsState createState() => _CategoryPresetsState();
}

class _CategoryPresetsState extends State<CategoryPresets> {
  @override
  Widget build(BuildContext context) {
    if(widget.block.style == 'STYLE2') {
      return _buildStyle2();
    }
    return _buildStyle1();
  }

  Widget _buildStyle1() {

    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    final TextStyle style = theme.textTheme.bodyText1!;
    final Color captionColor = theme.textTheme.bodyText1!.color!;
    TextStyle subtitleTextStyle = style.copyWith(color: captionColor, fontSize: 12.0);

    double mainAxisSpacingTop = widget.block.mainAxisSpacing;
    if(widget.block.headerAlign != 'none') {
      mainAxisSpacingTop = 0;
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.block.borderRadius),
            color: isDark ? Colors.transparent : widget.block.backgroundColor,
          ),
          padding: EdgeInsets.fromLTRB(widget.block.mainAxisSpacing, mainAxisSpacingTop, widget.block.mainAxisSpacing, widget.block.mainAxisSpacing),
          child: Column(
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

                    return InkWell(
                      onTap: () {
                        if(widget.type == 'brand') {
                          onBrandClick(widget.categories[index], context);
                        } else {
                          onCategoryClick(widget.categories[index], context);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              margin: EdgeInsets.all(0),
                              elevation: widget.block.elevation,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(200),
                              ),
                              child: InkWell(
                                child: CachedNetworkImage(
                                  imageUrl: widget.categories[index].image,
                                  placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                  errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(parseHtmlString(widget.categories[index].name), maxLines: 3, style: subtitleTextStyle, textAlign: TextAlign.center,)
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

  Widget _buildStyle2() {

    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    final TextStyle style = theme.textTheme.headline6!;
    final Color captionColor = theme.textTheme.bodyText1!.color!;
    TextStyle subtitleTextStyle = style.copyWith(color: captionColor, fontSize: 18.0);


    double mainAxisSpacingTop = widget.block.mainAxisSpacing;
    if(widget.block.headerAlign != 'none') {
      mainAxisSpacingTop = 0;
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
        child: Container(
          color: isDark ? Colors.transparent : widget.block.backgroundColor,
          padding: EdgeInsets.fromLTRB(widget.block.mainAxisSpacing, mainAxisSpacingTop, widget.block.mainAxisSpacing, widget.block.mainAxisSpacing),
          child: Column(
            children: [
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
                  itemCount: widget.categories.length > 4 ? 4 : widget.categories.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        onCategoryClick(widget.categories[index], context);
                      },
                      child: Card(
                        elevation: widget.block.elevation,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(widget.block.borderRadius),
                        ),
                        color: isDark ? Colors.transparent : lightColorList[index],
                        child: Stack(
                          children: [
                            Positioned(
                              right: -10,
                              bottom: -10,
                              child: Container(
                                height: 100,
                                width: 100,
                                child: CachedNetworkImage(
                                  imageUrl: widget.categories[index].image,
                                  placeholder: (context, url) => Container(color: Colors.transparent,),
                                  errorWidget: (context, url, error) => Container(color: Colors.transparent,),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(parseHtmlString(widget.categories[index].name), maxLines: 3, style: subtitleTextStyle, textAlign: TextAlign.left),
                            ),
                          ],
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
}

List<Color> lightColorList = [
  Color(0xffffd0b0),
  Color(0xffe6ceff),
  Color(0xffe6ffff),
  Color(0xffffc1e3),
  Colors.red[300]!,
  Colors.green[300]!,
  Colors.grey[300]!,
  Colors.grey[300]!,
  Colors.grey[300]!,
  Colors.grey[300]!,
  Colors.grey[300]!,
  Colors.grey[300]!,
  Colors.grey[300]!,
];