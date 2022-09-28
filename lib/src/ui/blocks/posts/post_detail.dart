import 'package:app/src/functions.dart';
import 'package:app/src/models/post_model.dart';
import 'package:app/src/ui/pages/webview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetail extends StatefulWidget {
  final Post post;
  PostDetail({Key? key, required this.post}) : super(key: key);
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {

  final DateFormat formatter = DateFormat('E, d MMM yyyy - h:m a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(parseHtmlString(widget.post.title.rendered)),
        actions: [
          IconButton(onPressed: () {
            Share.share('Check out this article ' + widget.post.link);
          }, icon: Icon(CupertinoIcons.share))
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          if(widget.post.image.src.isNotEmpty)
            Container(
              child: CachedNetworkImage(
                imageUrl: widget.post.image.src.isNotEmpty ? widget.post.image.src : '',
                placeholder: (context, url) => Container(
                  color: Colors.grey.withOpacity(0.2),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.withOpacity(0.2),
                ),
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4),
            child: Text(parseHtmlString(widget.post.title.rendered), style: Theme.of(context).textTheme.headline5),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                /*Text(
                  widget.post.authorDetails.name + ' | ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),*/
                Text(
                  formatter.format(widget.post.date),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16),
            child: Text(parseHtmlString(widget.post.excerpt.rendered), style: Theme.of(context).textTheme.subtitle1),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16),
            child: Html(
                data: widget.post.content.rendered,
                onLinkTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) {
                  //TODO ADD Whatsapp lancunc if url contains https://wa.me
                  if(url != null)
                    _launchUrl(url, context);
                },
                onImageTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) {
                  //print(url);
                }
            ),
          ),
        ],
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
