import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../src/models/blocks_model.dart';
import 'banner_title.dart';
import 'on_click.dart';

class BannerGrid extends StatefulWidget {
  final Block block;
  const BannerGrid({Key? key, required this.block}) : super(key: key);
  @override
  _BannerGridState createState() => _BannerGridState();
}

class _BannerGridState extends State<BannerGrid> {
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
                    crossAxisCount: widget.block.crossAxisCount,
                    padding: EdgeInsets.only(left: widget.block.blockPadding.left, right: widget.block.blockPadding.right),
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
                  itemCount: widget.block.children.length,
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
                          onItemClick(widget.block.children[index], context);
                        },
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: widget.block.children[index].image,
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

    widget.block.children.forEach((element) {
      list.add(Card(
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
            onItemClick(element, context);
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: element.image,
              placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
              errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ));
    });

    return list;
  }
}
