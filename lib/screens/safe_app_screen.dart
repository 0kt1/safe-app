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

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart';
import '../utils/app_detector.dart';
import '../models/financial_app.dart';
import '../services/security_service.dart';

class SafeAppScreen extends StatefulWidget {
  @override
  _SafeAppScreenState createState() => _SafeAppScreenState();
}

class _SafeAppScreenState extends State<SafeAppScreen> {
  List<FinancialApp> safeApps = [];
  bool isLoading = true;

  static const MethodChannel _screenProtectionChannel =
      MethodChannel('safeapp/screen_protection');

  // Future<void> enableScreenProtection() async {
  //   await _screenProtectionChannel.invokeMethod('enableScreenProtection');
  // }

  Future<void> disableScreenProtection() async {
    await _screenProtectionChannel.invokeMethod('disableScreenProtection');
  }

  @override
  void initState() {
    super.initState();
    loadSafeApps();
  }

  Future<void> loadSafeApps() async {
    List<FinancialApp> apps = await AppDetector.getInstalledFinancialApps();
    setState(() {
      safeApps = apps;
      isLoading = false;
    });
  }

  void openApp(String packageName) {
    // await enableScreenProtection(); // Enable security
    // SecurityService.enableScreenSecurity(); // Block screenshots & screen recording
    DeviceApps.openApp(packageName);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      disableScreenProtection(); // Disable security when user returns
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Safe Financial Apps")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : safeApps.isEmpty
              ? Center(child: Text("No financial apps detected."))
              : ListView.builder(
                  itemCount: safeApps.length,
                  itemBuilder: (context, index) {
                    FinancialApp app = safeApps[index];

                    return Card(
                      child: ListTile(
                        leading: app.iconPath.isNotEmpty
                            ? Image.memory(
                                Uint8List.fromList(app.iconPath.codeUnits),
                                width: 40,
                                height: 40,
                              )
                            : Icon(Icons.security),
                        title: Text(app.appName),
                        trailing: IconButton(
                          icon: Icon(Icons.open_in_new),
                          onPressed: () => openApp(app.packageName),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
