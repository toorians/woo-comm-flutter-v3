import 'package:app/src/functions.dart';
import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/ui/pages/webview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import '../../blocs/post_detail_bloc.dart';
import '../../models/post_model.dart';

class WPPostPage extends StatefulWidget {
  final Child child;
  final postBloc = PostBloc();
  WPPostPage({Key? key, required this.child}) : super(key: key);
  @override
  _WPPostPageState createState() => _WPPostPageState();
}

class _WPPostPageState extends State<WPPostPage> {

  @override
  void initState() {
    widget.postBloc.fetchData(widget.child.linkId, widget.child.linkType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parseHtmlString(widget.child.title)),
      ),
      body: StreamBuilder<Post>(
          stream: widget.postBloc.post,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null ? ListView(
              shrinkWrap: true,
              children: [
                if(snapshot.data!.image.src.isNotEmpty)
                  Container(
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data!.image.src.isNotEmpty ? snapshot.data!.image.src : '',
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
                  child: Text(parseHtmlString(snapshot.data!.title.rendered), style: Theme.of(context).textTheme.headline5),
                ),
                /*Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16),
                  child: Text(parseHtmlString(snapshot.data!.excerpt.rendered), style: Theme.of(context).textTheme.subtitle1),
                ),*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16),
                  child: Html(
                      data: snapshot.data!.content.rendered,
                      onLinkTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) {
                        if(url != null)
                          _launchUrl(url, context);
                      },
                      onImageTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) {
                        //print(url);
                      }
                  ),
                ),
              ],
            ) : Center(child: CircularProgressIndicator());
          }
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