import 'package:app/src/models/post_model.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../src/models/blocks_model.dart';

class PostSlider extends StatefulWidget {
  final Block block;
  final List<Post> posts;
  PostSlider({Key? key, required this.block, required this.posts}) : super(key: key);
  @override
  _PostSliderState createState() => _PostSliderState();
}

class _PostSliderState extends State<PostSlider> {
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
                      child: BannerTitle(block: widget.block)),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, widget.block.blockPadding.top, 0, widget.block.blockPadding.bottom),
                    height: widget.block.childHeight + widget.block.blockPadding.top + widget.block.blockPadding.bottom,
                    child: Swiper(
                      containerHeight: widget.block.childHeight,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          splashColor: widget.block.backgroundColor,
                          onTap: () async {
                            onPostClick(widget.posts[index], context);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(widget.block.borderRadius)),
                            ),
                            margin: EdgeInsets.all(widget.block.mainAxisSpacing),
                            elevation: widget.block.elevation.toDouble(),
                            clipBehavior: Clip.antiAlias,
                            child:  CachedNetworkImage(
                              imageUrl: widget.posts[index].image.src.isNotEmpty ? widget.posts[index].image.src : '',
                              imageBuilder: (context, imageProvider) => Ink.image(
                                child: InkWell(
                                  splashColor: widget.block.backgroundColor.withOpacity(0.1),
                                  onTap: () async {
                                    onPostClick(widget.posts[index], context);
                                  },
                                ),
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
                      itemCount: widget.posts.length,
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
