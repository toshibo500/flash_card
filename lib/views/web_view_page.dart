import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WevViewPageParameters {
  WevViewPageParameters({required this.title, required this.url});
  String title;
  String url;
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key, required this.params}) : super(key: key);
  final WevViewPageParameters params;

  @override
  _WebViewPage createState() => _WebViewPage();
}

class _WebViewPage extends State<WebViewPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.params.title),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => {Navigator.of(context).pop()},
        ),
      ),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: _buildWebView(),
          ),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    return WebView(
        initialUrl: widget.params.url,
        javascriptMode: JavascriptMode.unrestricted,
        // ページの読み込み開始
        onPageStarted: (String url) {
          // ローディング開始
          setState(() {
            _isLoading = true;
          });
        },
        // ページ読み込み終了
        onPageFinished: (String url) async {
          // ローディング終了
          setState(() {
            _isLoading = false;
          });
        });
  }
}
