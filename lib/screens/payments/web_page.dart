import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String url;
  const WebPage({super.key, required this.url});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    if (mounted) {
      controller.loadRequest(Uri.parse(widget.url));
      controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
