import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalWebViewScreen extends StatefulWidget {
  const LocalWebViewScreen({super.key});

  @override
  State<LocalWebViewScreen> createState() => _LocalWebViewScreenState();
}

class _LocalWebViewScreenState extends State<LocalWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('http://192.168.1.90:3000'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local WebView'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
