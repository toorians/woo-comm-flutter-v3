import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../models/blocks_model.dart';
import '../banners/banner_title.dart';

class TextList extends StatefulWidget {
  final Block block;
  const TextList({Key? key, required this.block}) : super(key: key);
  @override
  _TextListState createState() => _TextListState();
}

class _TextListState extends State<TextList> {
  @override
  Widget build(BuildContext context) {


    bool isDark = Theme.of(context).brightness == Brightness.dark;
    int count = widget.block.children.length;

    if(widget.block.children.length > 0 && widget.block.headerAlign != 'none') {
      count = widget.block.children.length + 1;
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {

              double paddingTop = index == 0 ? widget.block.blockPadding.top : 0;
              double paddingBottom = (index + 1) == widget.block.children.length ? widget.block.blockPadding.bottom : 0;

              double marginLast = (index + 1) == widget.block.children.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
              double marginFirst = index == 0 ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;

              if(widget.block.headerAlign != 'none') {
                marginLast = index == widget.block.children.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
                marginFirst = index == 1 ? widget.block.mainAxisSpacing / 2 : widget.block.mainAxisSpacing / 2;
                paddingTop = index == 1 ? widget.block.blockPadding.top : 0;
                paddingBottom = index == widget.block.children.length ? widget.block.blockPadding.bottom : 0;
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


              return GestureDetector(
                onTap: () async {
                  onItemClick(widget.block.children[index], context);
                },
                child: Container(
                  color: isDark ? Colors.transparent : widget.block.backgroundColor,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(widget.block.blockPadding.left, paddingTop, widget.block.blockPadding.right, paddingBottom),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.block.children[index].image,
                          placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                          errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                          fit: BoxFit.cover,
                        ),
                        Card(
                          color: Colors.transparent,
                          clipBehavior: Clip.antiAlias,
                          elevation: widget.block.elevation,
                          margin: EdgeInsets.fromLTRB(widget.block.crossAxisSpacing, marginFirst, widget.block.crossAxisSpacing, marginLast),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(widget.block.borderRadius),
                          ),
                          child: InkWell(
                            radius: widget.block.borderRadius,
                            onTap: () async {
                              onItemClick(widget.block.children[index], context);
                            },
                            child: Container(
                              width: double.infinity,
                              child: Text(widget.block.children[index].description, style: widget.block.children[index].textStyle, textAlign: widget.block.headerAlign == 'top_center' ? TextAlign.center : null),
                            ),
                          ),
                        ),
                      ],
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
