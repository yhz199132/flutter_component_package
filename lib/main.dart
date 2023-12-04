import 'package:common_tools/sp/sp_util.dart';
import 'package:common_ui/text/nullable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_component_package/network/network_page.dart';
import 'package:flutter_component_package/sp/sp_page.dart';
import 'package:flutter_component_package/sql/my_sql_page.dart';
import 'package:flutter_component_package/web/web_view_page.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:y_network/http/interceptors/loading_interceptor.dart';
import 'package:y_network/y_network.dart';

import 'channel/channel_page.dart';
import 'scroll/scroll_page.dart';
import 'skeleton/skeleton.dart';
import 'tools_test/tools_test_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil().init();
  //请求工具类初始化
  YHttpUtil.getInstance().init(
      baseOptions: BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15)));
  YHttpUtil.getInstance().addInterceptorsList([
    LoadingInterceptor(loadingCallback: (isOpenView) {
      print("Loading开启状态：$isOpenView");
      if (isOpenView) {
        SmartDialog.showLoading(msg: "加载中请稍后");
      } else {
        SmartDialog.dismiss();
      }
    }),
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseMessage: true,
      ),
    )
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter组件包'),
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textStyle = const TextStyle(fontSize: 28);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NetworkPage()));
              },
              child: NullableText('y_network测试', style: textStyle),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SpPage()));
              },
              child: Text('sp测试', style: textStyle),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScrollPage()));
              },
              child: Text('ScrollPage测试', style: textStyle),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MySqlPage()));
              },
              child: Text('MySQL测试', style: textStyle),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChannelPage()));
              },
              child: Text('通道测试', style: textStyle),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ToolsTestPage()));
              },
              child: Text('工具类测试', style: textStyle),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WebViewPage()));
              },
              child: Text('H5', style: textStyle),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoadingListPage()));
              },
              child: Text('骨架屏', style: textStyle),
            )
          ],
        ),
      ),
    );
  }
}
