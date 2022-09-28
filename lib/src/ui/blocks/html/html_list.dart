import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:app/src/ui/pages/webview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../../models/blocks_model.dart';
import '../banners/banner_title.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class HtmlTextList extends StatefulWidget {
  final Block block;
  const HtmlTextList({Key? key, required this.block}) : super(key: key);
  @override
  _HtmlTextListState createState() => _HtmlTextListState();
}

class _HtmlTextListState extends State<HtmlTextList> {
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
                  child: Card(
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
                        child: Html(
                            data: widget.block.children[index].description,
                            onLinkTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) {
                                 if(url != null) {
                                   _launchUrl(url, context);
                                 }
                            },
                            onImageTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) {
                              //print(url);
                            }
                        ),
                      ),
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
  void _launchUrl(String url, BuildContext context) {
    if(url.contains('https://wa.me/') || url.contains('mailto:') || url.contains('sms:') || url.contains('tel:') || url.contains('https://m.me/')) {
      launchUrl(Uri.parse(url));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebViewPage(url: url)));
    }
  }
}
