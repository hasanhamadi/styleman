import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  // ۱. کلمه late حذف شد و به جاش از ? استفاده کردیم تا نال‌تولرنت باشه
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  final String _targetUrl = 'https://www.digikala.com/';

  @override
  void initState() {
    super.initState();
    _checkInternetAndLoad();
  }

  Future<void> _checkInternetAndLoad() async {
    try {
      // یه تاخیر خیلی کوتاه برای پایداری بیشتر در اجرای اولیه
      await Future.delayed(Duration.zero);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _initializeController();
      }
    } on SocketException catch (_) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _initializeController() {
    // ۲. مقداردهی مستقیم به متغیر
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => _isLoading = true),
          onPageFinished: (url) => setState(() => _isLoading = false),
          onWebResourceError: (error) => setState(() {
            _hasError = true;
            _isLoading = false;
          }),
        ),
      )
      ..loadRequest(Uri.parse(_targetUrl));

    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        // ۳. بررسی می‌کنیم که کنترلر نال نباشد
        if (_controller != null && await _controller!.canGoBack()) {
          await _controller!.goBack();
        } else {
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // ۴. شرط اصلی: اگر خطا داشتیم نمایش خطا، اگر کنترلر آماده بود نمایش وب‌ویو، وگرنه لودینگ
              if (_hasError)
                _buildErrorWidget()
              else if (_controller != null)
                WebViewWidget(controller: _controller!)
              else
                const Center(child: CircularProgressIndicator()),

              // نمایش لودینگ روی صفحه وب‌ویو در حین جابجایی بین صفحات سایت
              if (_isLoading && !_hasError && _controller != null)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 50, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('اتصال به اینترنت برقرار نیست'),
          TextButton(
            onPressed: () {
              setState(() {
                _hasError = false;
                _isLoading = true;
                _controller = null; // ریست کردن برای تلاش مجدد
              });
              _checkInternetAndLoad();
            },
            child: const Text('تلاش مجدد'),
          ),
        ],
      ),
    );
  }
}
