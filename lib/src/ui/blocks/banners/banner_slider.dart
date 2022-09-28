import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../src/models/blocks_model.dart';

import 'on_click.dart';

class BannerSlider extends StatefulWidget {
  final Block block;
  BannerSlider({Key? key, required this.block}) : super(key: key);
  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double padding = widget.block.mainAxisSpacing == 0 ? 16 : widget.block.mainAxisSpacing;
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Container(
              color: isDark ? Colors.transparent : widget.block.backgroundColor,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                      child: BannerTitle(block: widget.block)
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, widget.block.blockPadding.top, 0, widget.block.blockPadding.bottom),
                    height: widget.block.childHeight + widget.block.blockPadding.top + widget.block.blockPadding.bottom,
                    child: Swiper(
                      containerHeight: widget.block.childHeight,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          splashColor: widget.block.backgroundColor,
                          onTap: () {
                            onItemClick(widget.block.children[index], context);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(widget.block.borderRadius)),
                            ),
                            margin: EdgeInsets.all(widget.block.mainAxisSpacing),
                            elevation: widget.block.elevation.toDouble(),
                            clipBehavior: Clip.antiAlias,
                            child:  CachedNetworkImage(
                              imageUrl: widget.block.children[index].image,
                              imageBuilder: (context, imageProvider) => Ink.image(
                                child: InkWell(
                                    splashColor: widget.block.backgroundColor.withOpacity(0.1),
                                    onTap: () {
                                      onItemClick(widget.block.children[index], context);
                                    }),
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              placeholder: (context, url) =>
                                  Container(color: Colors.black12),
                              errorWidget: (context, url, error) => Container(color: Colors.black12),
                            ),
                          ),
                        );
                      },
                      itemCount: widget.block.children.length,
                      pagination: new SwiperPagination(
                          margin: EdgeInsets.fromLTRB(0,0,0,widget.block.mainAxisSpacing + 10)
                      ),
                      autoplay: true,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
