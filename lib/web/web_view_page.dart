import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 作者：袁汉章 on 2023年11月06日 11:29
/// 邮箱：yhz199132@163.com
class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('http://nethospital5.test.winexmy.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        'http://nethospital5.test.winexmy.com/#/?hospitalID=33233986000&hospitalName=上海天佑医院测试&visitNo=1828528&doctorID=2055&doctorName=叶建兰&deptID=9999&deptName=互联网-神经内科&dest=applyform-open'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('处方开具'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
