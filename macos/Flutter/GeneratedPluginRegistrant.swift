//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import blue_thermal_printer
import device_info_plus
import geolocator_apple
import location
import package_info_plus
import path_provider_foundation
import printing
import share_plus
import shared_preferences_foundation
import sqflite
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  BlueThermalPrinterPlugin.register(with: registry.registrar(forPlugin: "BlueThermalPrinterPlugin"))
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  GeolocatorPlugin.register(with: registry.registrar(forPlugin: "GeolocatorPlugin"))
  LocationPlugin.register(with: registry.registrar(forPlugin: "LocationPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  PrintingPlugin.register(with: registry.registrar(forPlugin: "PrintingPlugin"))
  SharePlusMacosPlugin.register(with: registry.registrar(forPlugin: "SharePlusMacosPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
}
