import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PermissionsScreenState createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool accessibilityGranted = false;
  bool usageStatsGranted = false;
  bool deviceAdminGranted = false;
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    // checkRegistration();
    checkPermissions();
  }

  // Future<void> checkRegistration() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   bool registered = prefs.getBool('device_registered') ?? false;
  //   if (!registered) {
  //     await registerDevice();
  //   }
  // }

  // Future<void> registerDevice() async {
  //   String? deviceId = await getDeviceId();
  //   if (deviceId == null) return;

  //   Map<String, String>? credentials = await askForCredentials();
  //   if (credentials == null) return;

  //   // String? password = await askForPassword();
  //   // if (password == null || password.isEmpty) return;

  //   var response = await http.post(
  //     Uri.parse('http://192.168.137.1:8000/auth/register'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'deviceid': deviceId,
  //       'username': credentials['username'],
  //       'password': credentials['password'],
  //       'role': 'user',
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setBool('device_registered', true);
  //     setState(() => isRegistered = true);
  //   } else {
  //     // Handle error
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Registration Failed'),
  //           content: Text('Please try again.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Device ID: ${androidInfo.id}");
    return androidInfo.id; // Unique device ID
  }

  // Future<Map<String, String>?> askForCredentials() async {
  //   TextEditingController usernameController = TextEditingController();
  //   TextEditingController passwordController = TextEditingController();

  //   return await showDialog<Map<String, String>>(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Register Device'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: usernameController,
  //               decoration: InputDecoration(labelText: 'Username'),
  //             ),
  //             TextField(
  //               controller: passwordController,
  //               obscureText: true,
  //               decoration: InputDecoration(labelText: 'Password'),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, null),
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, {
  //               'username': usernameController.text,
  //               'password': passwordController.text,
  //             }),
  //             child: Text('Confirm'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<String?> askForPassword() async {
  //   TextEditingController controller = TextEditingController();
  //   return await showDialog<String>(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Set Device Password'),
  //         content: TextField(
  //           controller: controller,
  //           obscureText: true,
  //           decoration: InputDecoration(labelText: 'Password'),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, null),
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, controller.text),
  //             child: Text('Confirm'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> checkPermissions() async {
    // Check Accessibility Service
    // (No direct way to check; assume it's disabled initially)
    setState(() {
      accessibilityGranted = false;
    });

    // Check Usage Stats
    bool usageStats = await Permission.systemAlertWindow.isGranted;
    setState(() {
      usageStatsGranted = usageStats;
    });

    // Check Device Admin (No direct API, assume it's disabled)
    setState(() {
      deviceAdminGranted = false;
    });
  }

  // void showPermissionDialog(
  //     String title, String message, VoidCallback onConfirm) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: Text(message),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               onConfirm();
  //             },
  //             child: const Text("Enable"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

void showPermissionDialog(
    String title, String message, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.grey[300],
            fontSize: 16,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[400],
              textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38BDF8),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            child: const Text("Enable"),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).scale(); // Animate it
    },
  );
}


  Future<void> requestAccessibility() async {
    showPermissionDialog(
      "Enable Accessibility Service",
      "This is required to detect foreground apps and improve security. We do not collect or store any personal data.",
      () async {
        const intent = AndroidIntent(
          action: 'android.settings.ACCESSIBILITY_SETTINGS',
          flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      },
    );
  }

  Future<void> requestUsageStats() async {
    showPermissionDialog(
      "Enable Usage Stats",
      "Usage stats are needed to monitor app activity and enhance security.",
      () async {
        const intent = AndroidIntent(
          action: 'android.settings.USAGE_ACCESS_SETTINGS',
          flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      },
    );
  }

  // Future<void> requestDeviceAdmin() async {
  //   const intent = AndroidIntent(
  //     action: 'android.app.action.ADD_DEVICE_ADMIN',
  //     package: 'com.example.safeapp', // ✅ Your app package
  //     componentName:
  //         'com.example.safeapp/.services.MyDeviceAdminReceiver', // ✅ Full path
  //     flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
  //     arguments: {
  //     'android.app.extra.DEVICE_ADMIN': 'com.example.safeapp/.services.MyDeviceAdminReceiver',
  //   },
  //   );

  //   await intent.launch();
  // }

//   Future<void> requestDeviceAdmin() async {
//   const intent = AndroidIntent(
//     action: 'android.app.action.ADD_DEVICE_ADMIN',
//     package: 'com.example.safeapp', // ✅ Your app package
//     componentName: '.services.MyDeviceAdminReceiver', // ✅ Correct format
//     flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
//     arguments: {
//       'android.app.extra.DEVICE_ADMIN': 'com.example.safeapp/.services.MyDeviceAdminReceiver',
//     },
//   );

//   await intent.launch();
// }

  static const platform = MethodChannel('com.example.safeapp/app_blocker');

  Future<void> requestDeviceAdmin() async {
    showPermissionDialog(
      "Enable Device Admin",
      "Device Admin is required to block unauthorized apps and enhance security.",
      () async {
        try {
          await platform.invokeMethod('requestAdmin');
        } on PlatformException catch (e) {
          print("Failed to request Device Admin: '${e.message}'.");
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Permissions Setup")),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           if (!isRegistered) const Text("Registering device... Please wait"),
  //           ListTile(
  //             title: const Text("Accessibility Service"),
  //             subtitle: const Text("Needed to detect foreground apps."),
  //             trailing: accessibilityGranted
  //                 ? const Icon(Icons.check, color: Colors.green)
  //                 : ElevatedButton(
  //                     onPressed: requestAccessibility,
  //                     child: const Text("Enable"),
  //                   ),
  //           ),
  //           ListTile(
  //             title: const Text("Usage Stats"),
  //             subtitle: const Text("Needed to monitor app usage."),
  //             trailing: usageStatsGranted
  //                 ? const Icon(Icons.check, color: Colors.green)
  //                 : ElevatedButton(
  //                     onPressed: requestUsageStats,
  //                     child: const Text("Enable"),
  //                   ),
  //           ),
  //           ListTile(
  //             title: const Text("Device Admin"),
  //             subtitle: const Text("Needed to block unauthorized apps."),
  //             trailing: deviceAdminGranted
  //                 ? const Icon(Icons.check, color: Colors.green)
  //                 : ElevatedButton(
  //                     onPressed: requestDeviceAdmin,
  //                     child: const Text("Enable"),
  //                   ),
  //           ),
  //           const SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: () async {
  //               if (!(await Permission.systemAlertWindow.isGranted)) {
  //                 await openAppSettings();
  //               }
  //             },
  //             child: const Text("Allow Overlay Permission"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Navigator.pushReplacementNamed(context, '/secure_container');
  //               Navigator.pushReplacementNamed(context, '/home_screen');
  //             },
  //             child: const Text("Continue"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }



  @override
Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;

  return Scaffold(
    backgroundColor: const Color(0xFF0F172A),
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        "Permissions Setup",
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (!isRegistered)
          //   Text(
          //     "Registering device... Please wait",
          //     style: GoogleFonts.poppins(color: Colors.white70),
          //   ).animate().fadeIn(duration: 500.ms),

          const SizedBox(height: 16),

          _buildPermissionCard(
            title: "Accessibility Service",
            subtitle: "Needed to detect foreground apps.",
            granted: accessibilityGranted,
            onPressed: requestAccessibility,
          ),

          _buildPermissionCard(
            title: "Usage Stats",
            subtitle: "Needed to monitor app usage.",
            granted: usageStatsGranted,
            onPressed: requestUsageStats,
          ),

          _buildPermissionCard(
            title: "Device Admin",
            subtitle: "Needed to block unauthorized apps.",
            granted: deviceAdminGranted,
            onPressed: requestDeviceAdmin,
          ),

          const Spacer(),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent[700],
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () async {
              if (!(await Permission.systemAlertWindow.isGranted)) {
                await openAppSettings();
              }
            },
            icon: const Icon(Icons.visibility),
            label: const Text("Allow Overlay Permission"),
          ).animate().fadeIn().slideX(begin: -0.3, duration: 600.ms),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home_screen');
            },
            icon: const Icon(Icons.arrow_forward_ios),
            label: const Text("Continue"),
          ).animate().fadeIn().slideX(begin: 0.3, duration: 600.ms),
        ],
      ),
    ),
  );
}

Widget _buildPermissionCard({
  required String title,
  required String subtitle,
  required bool granted,
  required VoidCallback onPressed,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: granted ? Colors.green : Colors.tealAccent,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: granted
              ? Colors.green.withOpacity(0.15)
              : Colors.tealAccent.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        granted
            ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
            : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Enable"),
              ),
      ],
    ),
  );
}

}

