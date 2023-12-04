//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <y_storage/y_storage_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) y_storage_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "YStoragePlugin");
  y_storage_plugin_register_with_registrar(y_storage_registrar);
}
