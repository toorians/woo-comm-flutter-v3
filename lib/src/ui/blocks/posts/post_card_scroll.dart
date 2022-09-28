import 'package:app/src/models/post_model.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';

import './../../../models/blocks_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../functions.dart';

class PostCardScroll extends StatefulWidget {
  final List<Post> posts;
  final Block block;
  const PostCardScroll({Key? key, required this.posts, required this.block}) : super(key: key);
  @override
  _PostCardScrollState createState() => _PostCardScrollState();
}

class _PostCardScrollState extends State<PostCardScroll> {
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
                    child: BannerTitle(block: widget.block)),
                Container(
                  height: 270.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Widget title = Text(parseHtmlString(widget.posts[index].title.rendered), maxLines: 1, style: titleStyle);

                      double marginLast = (index + 1) == widget.block.children.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
                      double marginFirst = index == 0 ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;


                      final Widget titleText = AnimatedDefaultTextStyle(
                        style: titleStyle,
                        duration: kThemeChangeDuration,
                        child: title,
                      );
                      return Container(
                        width: 330,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.transparent,
                          elevation: 0,
                          margin: EdgeInsets.fromLTRB(marginFirst, 0, marginLast, 0),
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
                                    height: 160,
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
                      );
                    },
                    itemCount: widget.posts.length,
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
