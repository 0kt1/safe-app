// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:device_apps/device_apps.dart';
// import '../utils/app_detector.dart';
// import '../models/financial_app.dart';

// class SafeAppScreen extends StatefulWidget {
//   @override
//   _SafeAppScreenState createState() => _SafeAppScreenState();
// }

// class _SafeAppScreenState extends State<SafeAppScreen> {
//   List<FinancialApp> safeApps = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadSafeApps();
//   }

//   Future<void> loadSafeApps() async {
//     List<FinancialApp> apps = await AppDetector.getInstalledFinancialApps();
//     setState(() {
//       safeApps = apps;
//       isLoading = false;
//     });
//   }

//   void openApp(String packageName) {
//     DeviceApps.openApp(packageName);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Safe Financial Apps")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : safeApps.isEmpty
//               ? Center(child: Text("No financial apps detected."))
//               : ListView.builder(
//                   itemCount: safeApps.length,
//                   itemBuilder: (context, index) {
//                     FinancialApp app = safeApps[index];

//                     return Card(
//                       child: ListTile(
//                         leading: app.iconPath.isNotEmpty
//                             ? Image.memory(
//                                 Uint8List.fromList(app.iconPath.codeUnits),
//                                 width: 40,
//                                 height: 40,
//                               )
//                             : Icon(Icons.security),
//                         title: Text(app.appName),
//                         trailing: IconButton(
//                           icon: Icon(Icons.open_in_new),
//                           onPressed: () => openApp(app.packageName),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_detector.dart';
import '../models/financial_app.dart';

List<String> trustedApps = [];
List<Application> installedApps = [];

class SafeAppScreen extends StatefulWidget {
  const SafeAppScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SafeAppScreenState createState() => _SafeAppScreenState();
}

class _SafeAppScreenState extends State<SafeAppScreen> {
  // List<FinancialApp> safeApps = [];
  bool isLoading = true;

  // static const MethodChannel _screenProtectionChannel = MethodChannel('safeapp/screen_protection');

  // Future<void> enableScreenProtection() async {
  //   await _screenProtectionChannel.invokeMethod('enableScreenProtection');
  // }

  // Future<void> disableScreenProtection() async {
  //   await _screenProtectionChannel.invokeMethod('disableScreenProtection');
  // }

  @override
  void initState() {
    super.initState();
    // loadSafeApps();
    loadApps();
  }

  // Future<void> loadSafeApps() async {
  //   List<FinancialApp> apps = await AppDetector.getInstalledFinancialApps();
  //   setState(() {
  //     safeApps = apps;
  //     isLoading = false;
  //   });
  // }

  
  // Fetch installed apps
  Future<void> loadApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
    );
    List<String> savedApps = await getTrustedApps();
    
    setState(() {
      installedApps = apps;
      trustedApps = savedApps;
    });
  }

  // Save trusted apps
  Future<void> saveTrustedApps(List<String> apps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('trusted_apps', apps);
  }

  // Get trusted apps
  Future<List<String>> getTrustedApps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('trusted_apps') ?? [];
  }

  // Toggle trusted status
  void toggleApp(String packageName) {
    setState(() {
      if (trustedApps.contains(packageName)) {
        trustedApps.remove(packageName);
        Fluttertoast.showToast(msg: "Removed from trusted list");
      } else {
        trustedApps.add(packageName);
        Fluttertoast.showToast(msg: "Added to trusted list");
      }
      saveTrustedApps(trustedApps);
    });
  }

  void openApp(String packageName) {
    // await enableScreenProtection(); // Enable security
    // SecurityService.enableScreenSecurity(); // Block screenshots & screen recording
    DeviceApps.openApp(packageName);
  }

  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     disableScreenProtection(); // Disable security when user returns
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Trusted Apps')),
      body: ListView.builder(
        itemCount: installedApps.length,
        itemBuilder: (context, index) {
          final app = installedApps[index];
          bool isTrusted = trustedApps.contains(app.packageName);

          return ListTile(
            leading: app is ApplicationWithIcon
                ? Image.memory(app.icon, width: 40, height: 40)
                : const Icon(Icons.apps),
            title: Text(app.appName),
            trailing: Switch(
              value: isTrusted,
              onChanged: (value) => toggleApp(app.packageName),
            ),
          );
        },
      ),
    );
  }

  

}
