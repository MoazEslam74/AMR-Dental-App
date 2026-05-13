import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AntibioticWebViewScreen extends StatefulWidget {
  final String url;
  const AntibioticWebViewScreen({super.key, required this.url});

  @override
  State<AntibioticWebViewScreen> createState() =>
      _AntibioticWebViewScreenState();
}

class _AntibioticWebViewScreenState extends State<AntibioticWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Images'),
        backgroundColor: Color.fromARGB(255, 12, 172, 196),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
