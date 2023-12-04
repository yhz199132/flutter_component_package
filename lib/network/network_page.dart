import 'package:flutter/material.dart';
import 'package:y_network/http/y_response.dart';
import 'package:y_network/y_network.dart';

/// 作者：袁汉章 on 2023年10月20日 14:09
/// 邮箱：yhz199132@163.com
class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                userLogin();
                // queryAppInfo();
                // queryAppInfo2();
              },
              child: Text('查看版本信息'),
            )
          ],
        ),
      ),
    );
  }

  void queryAppInfo() async {
    // try {
    //   final startTime = DateTime.now().millisecondsSinceEpoch;
    //   await YHttpUtil.getInstance().post(
    //       'https://www.leanpay.cn/api/app/lastversion',
    //       queryParameters: {'appid': 'LEANTECH-DOCTOR-APP-V2-TEST'});
    //   final endTime = DateTime.now().millisecondsSinceEpoch;
    //   print("queryAppInfo用时${endTime - startTime}毫秒");
    // } catch (e) {
    //   print(e);
    // }
  }

  void userLogin() async {
    try {
      final responses = await YHttpUtil.getInstance().post(
          'http://127.0.0.1:8080/userLogin',
          body: {"phone": "13096905682", "password": "123456"});
      if (responses.isSuccessful) {
        print(responses.response?.data);
      } else {
        print(responses.isExtension
            ? responses.dioException?.toString()
            : responses.response?.statusMessage);
      }
    } catch (e) {
      print(e);
    }
  }

  void queryAppInfo2() async {
    // try {
    //   final startTime = DateTime.now().millisecondsSinceEpoch;
    //   final responses = await YHttpUtil.getInstance().multipleRequest([
    //     YHttpUtil.getInstance().post(
    //         'https://www.leanpay.cn/api/app/lastversion',
    //         queryParameters: {'appid': 'LEANTECH-DOCTOR-APP-V2-TEST'}),
    //     YHttpUtil.getInstance().post(
    //         'https://www.leanpay.cn/api/app/lastversion',
    //         queryParameters: {'appid': 'LEANTECH-DOCTOR-APP-V2-TEST'}),
    //     YHttpUtil.getInstance().post(
    //         'https://www.leanpay.cn/api/app/lastversion',
    //         queryParameters: {'appid': 'LEANTECH-DOCTOR-APP-V2-TEST'})
    //   ]);
    //   final endTime = DateTime.now().millisecondsSinceEpoch;
    //   print("queryAppInfo2用时${endTime - startTime}毫秒");
    // } catch (e) {
    //   print(e);
    // }
  }
}
