import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // برای خروج کامل از اپلیکیشن
import 'package:webview_flutter/webview_flutter.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, // هماهنگی پس‌زمینه با سایت
      ),
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
  late final WebViewController _controller;
  // آدرس جدید سایت شما
  final String _targetUrl = 'https://mazoshah.com/';

  @override
  void initState() {
    super.initState();
    // تنظیمات بهینه برای باز شدن سریع و بدون حاشیه
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(_targetUrl));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // مدیریت دستی دکمه برگشت برای خروج کامل
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // طبق خواسته شما: با یک کلیک روی برگشت، کلا از برنامه خارج می‌شود
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: SafeArea(
          // نمایش مستقیم سایت بدون هیچ المان اضافه (لودینگ یا خطا)
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
