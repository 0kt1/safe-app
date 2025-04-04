import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void showPermissionDialog(
      String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text("Enable"),
            ),
          ],
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Permissions Setup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isRegistered) const Text("Registering device... Please wait"),
            ListTile(
              title: const Text("Accessibility Service"),
              subtitle: const Text("Needed to detect foreground apps."),
              trailing: accessibilityGranted
                  ? const Icon(Icons.check, color: Colors.green)
                  : ElevatedButton(
                      onPressed: requestAccessibility,
                      child: const Text("Enable"),
                    ),
            ),
            ListTile(
              title: const Text("Usage Stats"),
              subtitle: const Text("Needed to monitor app usage."),
              trailing: usageStatsGranted
                  ? const Icon(Icons.check, color: Colors.green)
                  : ElevatedButton(
                      onPressed: requestUsageStats,
                      child: const Text("Enable"),
                    ),
            ),
            ListTile(
              title: const Text("Device Admin"),
              subtitle: const Text("Needed to block unauthorized apps."),
              trailing: deviceAdminGranted
                  ? const Icon(Icons.check, color: Colors.green)
                  : ElevatedButton(
                      onPressed: requestDeviceAdmin,
                      child: const Text("Enable"),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!(await Permission.systemAlertWindow.isGranted)) {
                  await openAppSettings();
                }
              },
              child: const Text("Allow Overlay Permission"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.pushReplacementNamed(context, '/secure_container');
                Navigator.pushReplacementNamed(context, '/home_screen');
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
