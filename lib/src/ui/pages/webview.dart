import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config.dart';
import '../../resources/api_provider.dart';


class WebViewPage extends StatefulWidget {
  final String url;
  final String? title;
  const WebViewPage({Key? key, required this.url, this.title}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isLoadingPage = true;
  final config = Config();
  final cookieManager = WebviewCookieManager();
  bool injectCookies = false;

  late WebViewController _wvController;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    _seCookies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title != null ? Text(widget.title!) : Container(),
        bottom: _isLoadingPage ? PreferredSize(
            preferredSize: Size.fromHeight(2.0),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>
                (Theme.of(context).primaryColorDark),
            )
        ) : null,
      ),
      body: injectCookies ? WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController wvc) {
          _wvController = wvc;
        },
        onPageFinished: (value) async {
          _wvController.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none';");
          _wvController.evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none';");
          _wvController.evaluateJavascript("document.getElementById('header').style.display='none';");
          _wvController.evaluateJavascript("document.getElementById('footer').style.display='none';");
          setState(() {
            _isLoadingPage = false;
          });
        },
      ) : Container(),
    );
  }

  _seCookies() async {
    Uri uri = Uri.parse(config.url);
    String domain = uri.host;
    ApiProvider apiProvider = ApiProvider();
    List<Cookie> cookies = apiProvider.generateCookies();
    apiProvider.cookieList.forEach((element) async {
      await cookieManager.setCookies([
        Cookie(element.name, element.value)
          ..domain = domain
        //..expires = DateTime.now().add(Duration(days: 10))
        //..httpOnly = true
      ]);
    });
    setState(() {
      injectCookies = true;
    });
  }

}
