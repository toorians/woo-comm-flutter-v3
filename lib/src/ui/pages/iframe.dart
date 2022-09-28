import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config.dart';
import '../../resources/api_provider.dart';


class IframePage extends StatefulWidget {
  final String url;
  final String? title;
  const IframePage({Key? key, required this.url, this.title}) : super(key: key);

  @override
  _IframePageState createState() => _IframePageState();
}

class _IframePageState extends State<IframePage> {
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
      appBar: widget.title != null ? AppBar(title: Text(widget.title!)) : AppBar(),
      body: Container(
        child: Stack(
          children: <Widget>[
            injectCookies ? WebView(
              onPageStarted: (String url) {
                //
              },
              initialUrl: Uri.dataFromString('<html><body><iframe src="${widget.url}"></iframe></body></html>', mimeType: 'text/html').toString(),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController wvc) {
                _wvController = wvc;
              },
              onPageFinished: (value) async {
                //Used for hiding html tag
                _wvController.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none';");
                _wvController.evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none';");
                setState(() {
                  _isLoadingPage = false;
                });
              },
            ) : Container(),
            _isLoadingPage
                ? Container(
                    color: Colors.white,
                    alignment: FractionalOffset.center,
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ),
      ),
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
