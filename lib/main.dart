import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
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
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DivarLauncherScreen(),
    );
  }
}

class DivarLauncherScreen extends StatefulWidget {
  const DivarLauncherScreen({super.key});

  @override
  State<DivarLauncherScreen> createState() => _DivarLauncherScreenState();
}

class _DivarLauncherScreenState extends State<DivarLauncherScreen> {
  @override
  void initState() {
    super.initState();
    // فراخوانی خودکار مرورگر داخلی به محض اجرای برنامه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _launchInAppBrowser();
    });
  }

  Future<void> _launchInAppBrowser() async {
    // آدرس جدید: دیوار
    final Uri url = Uri.parse('https://divar.ir/');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          // باز شدن در حالت In-App Browser (مشابه تجربه کاربری اپلیکیشن‌های حرفه‌ای)
          mode: LaunchMode.inAppBrowserView,
          browserConfiguration: const BrowserConfiguration(showTitle: true),
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      }
    } catch (e) {
      debugPrint("خطا در باز کردن سایت دیوار: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // صفحه کاملاً سفید بدون لودینگ (مشابه درخواست قبلی شما)
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(),
    );
  }
}
