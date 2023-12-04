import 'package:flutter_test/flutter_test.dart';
import 'package:y_storage/y_storage.dart';
import 'package:y_storage/y_storage_platform_interface.dart';
import 'package:y_storage/y_storage_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockYStoragePlatform
    with MockPlatformInterfaceMixin
    implements YStoragePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final YStoragePlatform initialPlatform = YStoragePlatform.instance;

  test('$MethodChannelYStorage is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelYStorage>());
  });

  test('getPlatformVersion', () async {
    YStorage yStoragePlugin = YStorage();
    MockYStoragePlatform fakePlatform = MockYStoragePlatform();
    YStoragePlatform.instance = fakePlatform;

    expect(await yStoragePlugin.getPlatformVersion(), '42');
  });
}
