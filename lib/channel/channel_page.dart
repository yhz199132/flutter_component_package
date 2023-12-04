import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 作者：袁汉章 on 2023年10月31日 10:00
/// 邮箱：yhz199132@163.com
/// 平台通道测试
/// 1.查询设备信息
/// 2.原生端每3秒通知flutter当前时间
/// 通道的客户端和宿主端通过传递给通道构造函数的通道名称进行连接。一个应用中所使用的所有通道名称必须是唯一的；使用唯一的 域前缀 为通道名称添加前缀
class ChannelPage extends StatefulWidget {
  const ChannelPage({super.key});

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  //1.构建方法通道，获取方法通道实例 与原生互相进行方法调用，用于方法调用（双向）
  final MethodChannel methodChannel = const MethodChannel("MyMethodChannel");

  //2.获取事件通道实例 Flutter 接收，用于数据流通信（单向）
  final EventChannel eventChannel = const EventChannel("MyEventChannel");

  //3.获取消息通道实例 与原生互相发送消息，用于数据传输（双向）
  final BasicMessageChannel basicMessageChannel = const BasicMessageChannel(
      "MyBasicMessageChannel", StandardMessageCodec());
  final textStyle = const TextStyle(fontSize: 28);
  StreamSubscription? subscription;

  @override
  void initState() {
    addChannelListener();
    super.initState();
  }

  String? deviceModel = "";
  String? timeNow = "";
  StringBuffer receive = StringBuffer();
  StringBuffer send = StringBuffer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('平台通道测试'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 29),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.blue,
              child: Column(
                children: [
                  Text(
                    'MethodChannel',
                    style: textStyle,
                  ),
                  TextButton(
                    onPressed: () {
                      getDeviceModel();
                    },
                    child: const Text('获取设备信息'),
                  ),
                  Text(
                    '设备信息返回结果:$deviceModel',
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.green,
              child: Column(
                children: [
                  Text(
                    'EventChannel',
                    style: textStyle,
                  ),
                  Text(
                    '当前时间:$timeNow',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                color: Colors.orange,
                child: Column(
                  children: [
                    Text(
                      'BasicMessageChannel',
                      style: textStyle,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  final timeNow = DateTime.now().toString();
                                  send.write("你好：$timeNow\n");
                                  basicMessageChannel.send(timeNow);
                                },
                                child: Text(
                                  '发送消息',
                                  style: textStyle,
                                ),
                              ),
                              Text(
                                send.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                '接收消息',
                                style: textStyle,
                              ),
                              Text(
                                receive.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addChannelListener() {
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "DeviceInfo":
          setState(() {
            deviceModel = call.arguments['data'];
          });
          break;
      }
      return "";
    });
    //建立监听
    subscription = eventChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        timeNow = event;
      });
    });
    basicMessageChannel.setMessageHandler((message) async {
      if (mounted) {
        setState(() {
          receive.write("${message.toString()}\n");
        });
      }
      return "flutter收到消息了";
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  //获取设备型号
  void getDeviceModel() async {
    deviceModel = await methodChannel
        // .invokeMethod<String>("DeviceInfo", {"message": "flutter传过来的参数"});
        .invokeMethod<String>("DeviceInfo", "flutter传过来的参数");
    if (mounted) {
      setState(() {});
    }
  }
}
