import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../src/models/blocks_model.dart';
import 'banner_title.dart';
import 'on_click.dart';

class BannerScroll extends StatefulWidget {
  final Block block;
  const BannerScroll({Key? key, required this.block}) : super(key: key);
  @override
  _BannerScrollState createState() => _BannerScrollState();
}

class _BannerScrollState extends State<BannerScroll> {
  @override
  Widget build(BuildContext context) {

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
                    child: BannerTitle(block: widget.block)
                ),
                Container(
                  height: widget.block.childHeight,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {


                      double marginLast = (index + 1) == widget.block.children.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
                      double marginFirst = index == 0 ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;


                      return Container(
                        width: widget.block.childWidth,
                        margin: EdgeInsets.fromLTRB(marginFirst, 0, marginLast, 0),
                        child: Card(
                          color: Colors.transparent,
                          clipBehavior: Clip.antiAlias,
                          elevation: widget.block.elevation,
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(widget.block.borderRadius),
                          ),
                          child: InkWell(
                            radius: widget.block.borderRadius,
                            onTap: () {
                              onItemClick(widget.block.children[index], context);
                            },
                            child: Container(
                              height: widget.block.childHeight,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: widget.block.children[index].image,
                                placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: widget.block.children.length,
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
