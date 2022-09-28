import 'package:app/src/models/post_model.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';
import './../../../models/blocks_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../functions.dart';

class PostList extends StatefulWidget {
  final List<Post> posts;
  final Block block;
  const PostList({Key? key, required this.posts, required this.block}) : super(key: key);
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color captionColor = theme.textTheme.caption!.color!;
    TextStyle subtitleTextStyle =
    style.copyWith(color: captionColor, fontSize: 12.0);
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
              onTap: () async {

              },
              child: Column(
                children: [
                  ListTile(
                    tileColor: isDark ? Colors.transparent : widget.block.backgroundColor,
                    minLeadingWidth: 56,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    onTap: () async {
                      onPostClick(widget.posts[index], context);
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
                            imageUrl: widget.posts[index].image.src.isNotEmpty ? widget.posts[index].image.src : '',
                            placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                            errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                            fit: BoxFit.cover,
                          ),
                        )
                    ),
                    title: Text(parseHtmlString(widget.posts[index].title.rendered)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(parseHtmlString(widget.posts[index].excerpt.rendered), maxLines: 2, style: subtitleTextStyle),
                        SizedBox(height: 4),
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
