// import 'package:flutter/services.dart';

// class AppBlockerService {
//   static const _channel = MethodChannel('com.example.safeapp/app_blocker');

//   static Future<void> requestAdmin() async {
//     await _channel.invokeMethod('requestAdmin');
//   }

//   static Future<void> startBlocking() async {
//     await _channel.invokeMethod('startBlocking');
//   }

//   static Future<void> stopBlocking() async {
//     await _channel.invokeMethod('stopBlocking');
//   }

//   static Future<void> setBlockedApps(List<String> apps) async {
//     await _channel.invokeMethod('setBlockedApps', {'apps': apps});
//   }

//   static Future<List<String>> getBlockedApps() async {
//     final apps = await _channel.invokeMethod<List<dynamic>>('getBlockedApps');
//     return apps?.cast<String>() ?? [];
//   }

//   static Future<void> requestUsageStatsPermission() async {
//     await _channel.invokeMethod('requestUsageStats');
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBlockerService {
  static const _channel = MethodChannel('com.example.safeapp/app_blocker');

  // static Future<bool> forceStopApp(String packageName) async {
  //   try {
  //     return await _channel.invokeMethod(
  //       'forceStopApp',
  //       {'packageName': packageName},
  //     ) ?? false;
  //   } on PlatformException catch (e) {
  //     print("Failed to force stop app 2: ${e.message}");
  //     return false;
  //   }
  // }

  static Future<bool> forceStopApp(String packageName) async {
  try {
    final result = await _channel.invokeMethod<bool>(
      'forceStopApp',
      {'packageName': packageName},
    );
    return result ?? false;
  } on PlatformException catch (e) {
    debugPrint("Force stop error 2: ${e.message}");
    return false;
  }
}
  
  static Future<void> requestAdmin() async {
    try {
      await _channel.invokeMethod('requestAdmin');
    } on PlatformException catch (e) {
      print("Failed to request admin: ${e.message}");
      rethrow;
    }
  }

  static Future<void> startBlocking() async {
    try {
      await _channel.invokeMethod('startBlocking');
    } on PlatformException catch (e) {
      print("Failed to start blocking: ${e.message}");
      rethrow;
    }
  }

  static Future<void> stopBlocking() async {
    try {
      await _channel.invokeMethod('stopBlocking');
    } on PlatformException catch (e) {
      print("Failed to stop blocking: ${e.message}");
      rethrow;
    }
  }

  static Future<void> setBlockedApps(List<String> apps) async {
    try {
      await _channel.invokeMethod('setBlockedApps', {'apps': apps});
    } on PlatformException catch (e) {
      print("Failed to set blocked apps: ${e.message}");
      rethrow;
    }
  }

  // static Future<List<String>> getBlockedApps() async {
  //   try {
  //     final apps = await _channel.invokeMethod<List<dynamic>>('getBlockedApps');
  //     return apps?.cast<String>() ?? [];
  //   } on PlatformException catch (e) {
  //     print("Failed to get blocked apps: ${e.message}");
  //     return [];
  //   }
  // }

  static Future<List<String>> getBlockedApps() async {
  try {
    final apps = await _channel.invokeMethod<List<dynamic>>('getBlockedApps');
    return apps?.cast<String>().toList() ?? []; // Convert to mutable list
  } on PlatformException catch (e) {
    print("Failed to get blocked apps: ${e.message}");
    return [];
  }
}

  static Future<void> requestUsageStatsPermission() async {
    try {
      await _channel.invokeMethod('requestUsageStats');
    } on PlatformException catch (e) {
      print("Failed to request usage stats: ${e.message}");
      rethrow;
    }
  }
}