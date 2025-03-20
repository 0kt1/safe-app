import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class PermissionsScreen extends StatefulWidget {
  @override
  _PermissionsScreenState createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool accessibilityGranted = false;
  bool usageStatsGranted = false;
  bool deviceAdminGranted = false;

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

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

  Future<void> requestAccessibility() async {
    const intent = AndroidIntent(
      action: 'android.settings.ACCESSIBILITY_SETTINGS',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  Future<void> requestUsageStats() async {
    const intent = AndroidIntent(
      action: 'android.settings.USAGE_ACCESS_SETTINGS',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  Future<void> requestDeviceAdmin() async {
    const intent = AndroidIntent(
      action: 'android.app.action.ADD_DEVICE_ADMIN',
      package: 'com.example.safeapp',
      componentName: 'com.example.safeapp.services.MyDeviceAdminReceiver',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Permissions Setup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/secure_container');
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
