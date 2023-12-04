import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

typedef CallbackConnectivityResult = Function(ConnectivityResult result)?;
typedef CallbackNetworkStatus = Function(NetworkStatus status)?;

/// 作者：袁汉章 on 2023年06月30日 18:00
/// 邮箱：yhz199132@163.com
/// 网络连接检查工具
class NetworkConnectivity {
  factory NetworkConnectivity() {
    _singleton ??= NetworkConnectivity._();
    return _singleton!;
  }

  NetworkConnectivity._();

  static NetworkConnectivity? _singleton;

  StreamSubscription<ConnectivityResult>? subscription;

  //检查网络连接类型
  Future<ConnectivityResult> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult;
  }

  //检查网络连接状态
  Future<NetworkStatus> checkNetworkStatus() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return _getNetworkStatus(connectivityResult);
  }

  //网络是否连接
  Future<bool> hasConnected() async {
    return await checkNetworkStatus() == NetworkStatus.connected;
  }

  ///添加订阅
  ///Function(ConnectivityResult result):连接结果回调
  ///Function(NetworkStatus status)：连接状态回调
  void addSubscription({
    CallbackConnectivityResult? callbackResult,
    CallbackNetworkStatus? callbackStatus,
  }) {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      callbackResult?.call(connectivityResult);
      callbackStatus?.call(_getNetworkStatus(connectivityResult));
    });
  }

  //取消订阅
  void cancelSubscription() {
    subscription?.cancel();
  }

  ///判断网络连接状态
  ///ConnectivityResult : 连接结果
  NetworkStatus _getNetworkStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi ||
            ConnectivityResult.ethernet ||
            ConnectivityResult.mobile ||
            ConnectivityResult.vpn ||
            ConnectivityResult.bluetooth:
        return NetworkStatus.connected;
      case ConnectivityResult.none:
        return NetworkStatus.unconnected;
      case ConnectivityResult.other:
        return NetworkStatus.unknown; //将other归入到unknown
    }
  }
}

///网络状态 connected：连接正常，unconnected：未连接，unknown：未知情况
enum NetworkStatus { connected, unconnected, unknown }
