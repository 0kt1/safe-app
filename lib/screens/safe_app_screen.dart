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
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_detector.dart';
import '../models/financial_app.dart';

List<String> trustedApps = [];
List<Application> installedApps = [];

class ManageAppsScreen extends StatefulWidget {
  const ManageAppsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManageAppsScreenState createState() => _ManageAppsScreenState();
}

class _ManageAppsScreenState extends State<ManageAppsScreen> {
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
      isLoading = false;
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
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
    title: 'Manage Your Apps',
    themeMode: ThemeMode.light,
    theme: NeumorphicThemeData(
      baseColor: const Color(0xFF0F172A),
      lightSource: LightSource.topLeft,
      depth: 4,
      shadowLightColor: Colors.white24,
      shadowDarkColor: Colors.black87,
    ),
      home: Scaffold(
        backgroundColor: const Color(0xFF0F172A), // dark professional background
        // appBar: AppBar(
        //   title: const Text('Manage Your Apps'),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   centerTitle: true,
        //   titleTextStyle: GoogleFonts.poppins(
        //     fontSize: 22,
        //     fontWeight: FontWeight.w600,
        //     color: Colors.white,
        //   ),
        // ),
        appBar: NeumorphicAppBar(
          title: Text(
            'Manage Your Apps',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          color: const Color(0xFF0F172A),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Padding(
                padding: const EdgeInsets.all(12),
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: installedApps.length,
                    itemBuilder: (context, index) {
                      final app = installedApps[index];
                      bool isTrusted = trustedApps.contains(app.packageName);
      
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 300),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: app is ApplicationWithIcon
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          app.icon,
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Icons.apps, color: Colors.white),
                                title: Text(
                                  app.appName,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  app.packageName,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                trailing: Switch(
                                  value: isTrusted,
                                  onChanged: (value) =>
                                      toggleApp(app.packageName),
                                  activeColor: Colors.greenAccent,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey[700],
                                ),
                                onTap: () => openApp(app.packageName),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
