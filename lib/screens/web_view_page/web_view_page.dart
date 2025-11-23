import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final String? successUrlContains;
  final Future<void> Function()? onSuccess;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
    this.successUrlContains,
    this.onSuccess,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _controller;
  bool _successDetected = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        // Allow navigation to proceed so the payment gateway and backend
        // can complete the redirect. We detect success when the page has
        // finished loading (onPageFinished) to ensure the backend had a
        // chance to process the redirect and credit the account.
        onNavigationRequest: (request) {
          return NavigationDecision.navigate;
        },
        onPageFinished: (url) {
          try {
            if (!_successDetected && _isSuccessUrl(url)) {
              // small delay to make sure backend finalizes
              Future.delayed(const Duration(milliseconds: 600), () {
                _handleSuccess();
              });
            }
          } catch (_) {}
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  bool _isSuccessUrl(String url) {
    final detector = widget.successUrlContains ?? 'success';

    try {
      return url.toLowerCase().contains(detector.toLowerCase());
    } catch (_) {
      return false;
    }
  }

  Future<void> _handleSuccess() async {
    if (_successDetected) return;
    _successDetected = true;

    if (widget.onSuccess != null) {
      try {
        await widget.onSuccess!();
      } catch (_) {}
    }

    if (mounted) Navigator.of(context).pop(true); // SUCCESS
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false); // USER BACK -> FAIL/EXIT
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(false); // SAME AS ANDROID BACK
            },
          ),
        ),
        body: _controller == null
            ? const Center(child: CircularProgressIndicator())
            : WebViewWidget(controller: _controller!),
      ),
    );
  }
}
