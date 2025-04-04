import 'package:flutter/services.dart';

class DeviceAdminService {
  static const _channel = MethodChannel('device_admin_channel');

  Future<bool> requestAdminPrivileges() async {
    try {
      await _channel.invokeMethod('requestDeviceAdmin');
      return true;
    } on PlatformException catch (e) {
      print('Failed to request admin: ${e.message}');
      return false;
    }
  }

  Future<bool> blockApplication(String packageName) async {
    try {
      await _channel.invokeMethod('admin:blockApplication', {
        'targetPackage': packageName,
      });
      return true;
    } on PlatformException catch (e) {
      print('Failed to block app: ${e.message}');
      return false;
    }
  }

  Future<bool> forceStopApplication(String packageName) async {
    try {
      await _channel.invokeMethod('admin:forceStopApplication', {
        'targetPackage': packageName,
      });
      return true;
    } on PlatformException catch (e) {
      print('Failed to force stop app: ${e.message}');
      return false;
    }
  }
}