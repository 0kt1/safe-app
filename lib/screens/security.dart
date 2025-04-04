import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  static const platform = MethodChannel('com.example.safeapp/app_blocker');

  bool isAccessibilityEnabled = false;
  bool isOverlayEnabled = false;
  List<String> unauthorizedSmsApps = [];
  List<String> accessibilityApps = []; // FIXED
  List<String> overlayApps = []; // FIXED
  List<String> suspiciousApps = [];

  @override
  void initState() {
    super.initState();
    checkSecurityThreats();
  }

  /// **Check for accessibility service, overlay attack, and unauthorized SMS apps**
  Future<void> checkSecurityThreats() async {
    List<String> accApps = await _isAccessibilityEnabled();
    List<String> ovApps = await _isOverlayEnabled();
    List<String> unauthorizedApps = await _detectUnauthorizedApps();

    setState(() {
      isAccessibilityEnabled = accApps.isNotEmpty;
      isOverlayEnabled = ovApps.isNotEmpty;
      unauthorizedSmsApps = unauthorizedApps;
      accessibilityApps = accApps; // FIXED
      overlayApps = ovApps; // FIXED
    });

    if (isAccessibilityEnabled ||
        isOverlayEnabled ||
        unauthorizedApps.isNotEmpty) {
      print("🚨 Warning! Security threats detected.");
    }
  }

  /// **Check if an accessibility service (screen reader) is active**
  Future<List<String>> _isAccessibilityEnabled() async {
    try {
      final List<dynamic> result =
          await platform.invokeMethod('isAccessibilityServiceEnabled');
      return result.cast<String>();
    } on PlatformException catch (e) {
      print("⚠️ Error checking accessibility: $e");
      return [];
    }
  }

  /// **Check if overlay apps are enabled**
  Future<List<String>> _isOverlayEnabled() async {
    try {
      final List<dynamic> result =
          await platform.invokeMethod('isOverlayEnabled');
      return result.cast<String>();
    } on PlatformException catch (e) {
      print("⚠️ Error checking overlay: $e");
      return [];
    }
  }

  /// **Detect unauthorized apps with SMS permission**
  Future<List<String>> _detectUnauthorizedApps() async {
    var status = await Permission.sms.request();
    if (!status.isGranted) {
      print("❌ SMS Permission Denied");
      return [];
    }

    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      includeAppIcons: false,
    );

    List<String> unauthorizedApps = [];

    for (var app in apps) {
      bool hasSmsPermission = await Permission.sms.status.isGranted;
      if (hasSmsPermission) {
        bool isSystemApp = await _isSystemApp(app.packageName);
        bool isPreInstalled = await _isPreInstalledApp(app.packageName);

        if (!isSystemApp && !isPreInstalled) {
          bool isUnauthorized = await _isUnauthorizedApp(app.packageName);
          if (isUnauthorized) {
            print(
                "🚨 Unauthorized App Detected: ${app.appName} (${app.packageName})");
            unauthorizedApps.add(app.appName);
          } else {
            print("✅ Verified App: ${app.appName} (${app.packageName})");
          }
        }
      }
    }

    return unauthorizedApps;
  }

  /// **Check if the app is a system app**
  Future<bool> _isSystemApp(String packageName) async {
    try {
      final bool isSystem =
          await platform.invokeMethod('isSystemApp', packageName);
      return isSystem;
    } on PlatformException catch (e) {
      print("⚠️ Error checking system app status: $e");
      return false;
    }
  }

  /// **Check if the app is pre-installed**
  Future<bool> _isPreInstalledApp(String packageName) async {
    try {
      final bool isPreInstalled =
          await platform.invokeMethod('isPreInstalled', packageName);
      return isPreInstalled;
    } on PlatformException catch (e) {
      print("⚠️ Error checking pre-installed app status: $e");
      return false;
    }
  }

  /// **Detect if an app is unauthorized (not from Play Store or trusted source)**
  Future<bool> _isUnauthorizedApp(String packageName) async {
    List<String> trustedSources = [
      "com.android.vending", // Google Play Store
      "com.sec.android.app.samsungapps", // Samsung Galaxy Store
      "com.amazon.venezia", // Amazon Appstore
      "com.huawei.appmarket", // Huawei AppGallery
      "com.oppo.market", // Oppo Market
      "com.vivo.appstore", // Vivo Store
      "com.xiaomi.market", // Xiaomi App Store
      "com.oneplus.store" // OnePlus Store
    ];

    try {
      final String? installerSource =
          await platform.invokeMethod('getInstaller', packageName);
      if (installerSource == null ||
          !trustedSources.contains(installerSource)) {
        return true;
      }
    } on PlatformException catch (e) {
      print("⚠️ Error checking installer source: $e");
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Security Insights",
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.white,
            tooltip: "Refresh",
            onPressed: () {
              checkSecurityThreats();
            },
          ),
        ],
        automaticallyImplyLeading: true,
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // appBar: AppBar(
      //   title: Text(
      //     "Security Insights",
      //     style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: const Color(0xFF1E293B),
      //   elevation: 4,
      //   shadowColor: Colors.black54,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.refresh),
      //       onPressed: () {
      //         checkSecurityThreats();
      //       },
      //     ),
      //   ],
      //   automaticallyImplyLeading: true,
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "System Security Overview",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(duration: 500.ms),
              ),
            ),
            const SizedBox(height: 16),
            _buildSecurityCard(
              title: "Accessibility Service",
              description: isAccessibilityEnabled
                  ? "🚨 Active Accessibility Services Detected!"
                  : "✅ No Accessibility Services Detected",
              icon: isAccessibilityEnabled ? Icons.warning : Icons.check_circle,
              iconColor: isAccessibilityEnabled ? Colors.red : Colors.green,
            ).animate().slideX(duration: 400.ms),
            if (isAccessibilityEnabled)
              ..._buildDetectedApps(accessibilityApps),
            const SizedBox(height: 12),
            _buildSecurityCard(
              title: "Overlay Apps",
              description: isOverlayEnabled
                  ? "🚨 Overlay Apps Detected!"
                  : "✅ No Overlay Apps Running",
              icon: isOverlayEnabled ? Icons.warning : Icons.check_circle,
              iconColor: isOverlayEnabled ? Colors.red : Colors.green,
            ).animate().slideX(begin: -1, duration: 400.ms),
            if (isOverlayEnabled) ..._buildDetectedApps(overlayApps),
            const SizedBox(height: 12),
            _buildSecurityCard(
              title: "Unauthorized SMS Apps",
              description: unauthorizedSmsApps.isEmpty
                  ? "✅ No unauthorized apps with SMS permission"
                  : "🚨 Some apps have SMS permissions!",
              icon: unauthorizedSmsApps.isEmpty
                  ? Icons.check_circle
                  : Icons.warning,
              iconColor:
                  unauthorizedSmsApps.isEmpty ? Colors.green : Colors.red,
            ).animate().slideX(begin: 1, duration: 400.ms),
            if (unauthorizedSmsApps.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: unauthorizedSmsApps.length,
                  itemBuilder: (context, index) {
                    return Card(
  elevation: 2,
  shadowColor: Colors.orange.withOpacity(0.25),
  color: const Color(0xFF1E293B), // slate-800 tone
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    title: Text(
      unauthorizedSmsApps[index],
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 15.5,
        color: Colors.white.withOpacity(0.95),
      ),
    ),
    leading: Container(
      decoration: BoxDecoration(
        color: Colors.deepOrange.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(10),
      child: Icon(Icons.sms, color: Colors.deepOrange, size: 22),
    ),
  ),
)
.animate()
.fadeIn(duration: 500.ms, delay: (index * 100).ms)
.moveY(begin: 20, end: 0, curve: Curves.easeOut);

                    // return Card(
                    //   color: Colors.orange.shade100,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: ListTile(
                    //     title: Text(
                    //       unauthorizedSmsApps[index],
                    //       style:
                    //           GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    //     ),
                    //     leading:
                    //         const Icon(Icons.sms, color: Colors.deepOrange),
                    //   ),
                    // ).animate().fadeIn(delay: (index * 100).ms);
                  },
                ),
              ),
          ],
        ),
      ),
    );

    // return MaterialApp(
    //   theme: ThemeData(primarySwatch: Colors.blue),
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: Text("🔍 Security Status"),
    //       centerTitle: true,
    //     ),
    //     body: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           _buildSecurityCard(
    //             title: "Accessibility Service",
    //             description: isAccessibilityEnabled
    //                 ? "🚨 Active Accessibility Services Detected!"
    //                 : "✅ No Accessibility Services Detected",
    //             icon:
    //                 isAccessibilityEnabled ? Icons.warning : Icons.check_circle,
    //             iconColor: isAccessibilityEnabled ? Colors.red : Colors.green,
    //           ),
    //           if (isAccessibilityEnabled)
    //             ..._buildDetectedApps(accessibilityApps),
    //           SizedBox(height: 10),
    //           _buildSecurityCard(
    //             title: "Overlay Apps",
    //             description: isOverlayEnabled
    //                 ? "🚨 Overlay Apps Detected!"
    //                 : "✅ No Overlay Apps Running",
    //             icon: isOverlayEnabled ? Icons.warning : Icons.check_circle,
    //             iconColor: isOverlayEnabled ? Colors.red : Colors.green,
    //           ),
    //           if (isOverlayEnabled) ..._buildDetectedApps(overlayApps),
    //           SizedBox(height: 10),
    //           _buildSecurityCard(
    //             title: "Unauthorized SMS Apps",
    //             description: unauthorizedSmsApps.isEmpty
    //                 ? "✅ No unauthorized apps with SMS permission"
    //                 : "🚨 Some apps have SMS permissions!",
    //             icon: unauthorizedSmsApps.isEmpty
    //                 ? Icons.check_circle
    //                 : Icons.warning,
    //             iconColor:
    //                 unauthorizedSmsApps.isEmpty ? Colors.green : Colors.red,
    //           ),
    //           if (unauthorizedSmsApps.isNotEmpty)
    //             Expanded(
    //               child: ListView.builder(
    //                 itemCount: unauthorizedSmsApps.length,
    //                 itemBuilder: (context, index) {
    //                   return ListTile(
    //                     title: Text(unauthorizedSmsApps[index]),
    //                     leading: Icon(Icons.sms, color: Colors.orange),
    //                   );
    //                 },
    //               ),
    //             ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

// Widget _buildSecurityCard({
//   required String title,
//   required String description,
//   required IconData icon,
//   required Color iconColor,
// }) {
//   return Card(
//     elevation: 3,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           Icon(icon, color: iconColor, size: 28),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 4),
//                 Text(description, style: TextStyle(fontSize: 14)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// List<Widget> _buildDetectedApps(List<String> apps) {
//   return apps
//       .map((app) => Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Card(
//               color: Colors.red.shade50,
//               shape:
//                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               child: ListTile(
//                   leading: Icon(Icons.apps, color: Colors.red), title: Text(app)),
//             ),
//       ))
//       .toList();
// }


Widget _buildSecurityCard({
  required String title,
  required String description,
  required IconData icon,
  required Color iconColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TranslationAnimatedWidget(
      enabled: true,
      values: [Offset(100, 0), Offset(0, 0)],
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 120,
        borderRadius: 20,
        blur: 20,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            iconColor.withOpacity(0.5),
            Colors.white.withOpacity(0.2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor.withOpacity(0.2),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

List<Widget> _buildDetectedApps(List<String> apps) {
  return apps
      .asMap()
      .entries
      .map(
        (entry) => OpacityAnimatedWidget.tween(
          opacityEnabled: 1,
          opacityDisabled: 0,
          duration: Duration(milliseconds: 300 + entry.key * 100), // staggered
          enabled: true,
          child: GlassmorphicContainer(
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            width: double.infinity,
            height: 65,
            borderRadius: 15,
            blur: 15,
            alignment: Alignment.center,
            border: 1,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.redAccent.withOpacity(0.12),
                Colors.white.withOpacity(0.04),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.15),
                child: Icon(Icons.apps, color: Colors.redAccent),
              ),
              title: Text(
                entry.value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      )
      .toList();
}


