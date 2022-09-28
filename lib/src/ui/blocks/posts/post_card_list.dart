import 'package:app/src/models/post_model.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';

import './../../../models/blocks_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../functions.dart';

class PostCard extends StatefulWidget {
  final List<Post> posts;
  final Block block;
  const PostCard({Key? key, required this.posts, required this.block}) : super(key: key);
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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

    int count = widget.posts.length;

    if(widget.posts.length > 0 && widget.block.headerAlign != 'none') {
      count = widget.posts.length + 1;
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {

            double paddingTop = index == 0 ? widget.block.blockPadding.top : 0;
            double paddingBottom = (index + 1) == widget.posts.length ? widget.block.blockPadding.bottom : 0;

            double marginLast = (index + 1) == widget.posts.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
            double marginFirst = index == 0 ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;

            if(widget.block.headerAlign != 'none') {
              marginLast = index == widget.posts.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
              marginFirst = index == 1 ? widget.block.mainAxisSpacing / 2 : widget.block.mainAxisSpacing / 2;
              paddingTop = index == 1 ? widget.block.blockPadding.top : 0;
              paddingBottom = index == widget.posts.length ? widget.block.blockPadding.bottom : 0;
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

            Widget title = Text(parseHtmlString(widget.posts[index].title.rendered), maxLines: 1, style: titleStyle);

            final Widget titleText = AnimatedDefaultTextStyle(
              style: titleStyle,
              duration: kThemeChangeDuration,
              child: title,
            );

            return GestureDetector(
              onTap: () async {
                onPostClick(widget.posts[index], context);
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            onPostClick(widget.posts[index], context);
                          },
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.all(0),
                            elevation: widget.block.elevation,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(widget.block.borderRadius),
                            ),
                            child: Container(
                              height: widget.block.childHeight,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: widget.posts[index].image.src.isNotEmpty ? widget.posts[index].image.src : '',
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
                              Text(parseHtmlString(widget.posts[index].excerpt.rendered),
                                  style: subtitleTextStyle),
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
