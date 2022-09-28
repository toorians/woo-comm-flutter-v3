import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IframePage extends StatefulWidget {
  final String url;
  final String title;
  const IframePage({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  _IframePageState createState() => _IframePageState();
}

class _IframePageState extends State<IframePage> {

  bool _isLoadingPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        child: Stack(
          children: [
            WebView(
              initialUrl: Uri.dataFromString('<html><body>'+ widget.url +'</body></html>', mimeType: 'text/html').toString(),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: updateLoader(),
              onPageFinished: (value) {
                setState(() {
                  _isLoadingPage = false;
                });
              },
            ),
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

  updateLoader() {}

}
