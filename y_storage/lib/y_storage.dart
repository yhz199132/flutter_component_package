
import 'y_storage_platform_interface.dart';

class YStorage {
  Future<String?> getPlatformVersion() {
    return YStoragePlatform.instance.getPlatformVersion();
  }
}
