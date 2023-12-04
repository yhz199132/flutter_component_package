import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'y_storage_platform_interface.dart';

/// An implementation of [YStoragePlatform] that uses method channels.
class MethodChannelYStorage extends YStoragePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('y_storage');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
