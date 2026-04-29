import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/core/theme/app_colors.dart';

class ZinkoWebViewScreen extends StatefulWidget {
  static const String routeName = '/webview';
  final String title;
  final String url;

  const ZinkoWebViewScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<ZinkoWebViewScreen> createState() => _ZinkoWebViewScreenState();
}

class _ZinkoWebViewScreenState extends State<ZinkoWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: ZinkoAppBar(title: widget.title.toUpperCase()),
      body: ZinkoBackground(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
