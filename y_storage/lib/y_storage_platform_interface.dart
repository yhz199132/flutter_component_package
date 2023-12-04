import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'y_storage_method_channel.dart';

abstract class YStoragePlatform extends PlatformInterface {
  /// Constructs a YStoragePlatform.
  YStoragePlatform() : super(token: _token);

  static final Object _token = Object();

  static YStoragePlatform _instance = MethodChannelYStorage();

  /// The default instance of [YStoragePlatform] to use.
  ///
  /// Defaults to [MethodChannelYStorage].
  static YStoragePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YStoragePlatform] when
  /// they register themselves.
  static set instance(YStoragePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
