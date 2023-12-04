#include "include/y_storage/y_storage_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "y_storage_plugin.h"

void YStoragePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  y_storage::YStoragePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
