// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:safeapp/screens/app_blocker_screen.dart';
// import 'package:safeapp/screens/dashboard.dart';
// import 'package:safeapp/screens/profile.dart';
// import 'package:safeapp/screens/safe_app_screen.dart';
// import 'package:safeapp/screens/test.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   final List<Widget> _screens = [
//     // SecureContainerScreen(),
//     const ManageAppsScreen(),
//     const DashboardPage(),
//     const ProfileScreen(),
//     // const AppBlockerScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Safe App'),
//       // ),
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         type: BottomNavigationBarType.fixed,
//         selectedIconTheme: const IconThemeData(color: Colors.white),
//         unselectedIconTheme: const IconThemeData(color: Colors.grey, size: 25),
//         selectedLabelStyle: GoogleFonts.inter(
//                                   fontSize: 12,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//         iconSize: 30,
//         elevation: 5,
//         unselectedLabelStyle: const TextStyle(color: Colors.grey),
//         items: const <BottomNavigationBarItem>[
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.lock),
//           //   label: 'Secure Container',
//           // ),

//           BottomNavigationBarItem(
//             icon: Icon(Icons.lock),
//             label: 'Manage Apps',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.telegram),
//           //   label: 'Block Apps',
//           // ),
//         ],
//         currentIndex: _selectedIndex,
//         // selectedItemColor: Colors.deepPurple,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safeapp/components/side_drawer.dart';
import 'package:safeapp/screens/app_blocker_screen.dart';
import 'package:safeapp/screens/dashboard.dart';
import 'package:safeapp/screens/financialapps.dart';
import 'package:safeapp/screens/detect_apps.dart';
import 'package:safeapp/screens/profile.dart';
import 'package:safeapp/screens/toggle_apps.dart';
import 'package:safeapp/screens/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
  
//   // Optionally, show a local notification
//   // FlutterLocalNotificationsPlugin().show(...)

//   if (message.data['command'] == 'wipe') {
//     await _saveNotificationData('wipe');
//     // triggerWipe();
//   }
// }

// Future<void> _saveNotificationData(String command) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('notification_command', command);
// }


// Future<void> triggerWipe() async {
//     const platform = MethodChannel('com.example.safeapp/app_blocker');
//     try {
//       final result = await platform.invokeMethod('wipeData');
//       print("✅ App data wiped: $result");
//     } on PlatformException catch (e) {
//       print("❌ Failed to wipe data: ${e.message}");
//     }
//   }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const FinancialAppsScreen(),
    DetectAppsScreen(),
    const DashboardPage(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  String? deviceToken;

  @override
  void initState() {
    super.initState();
    // _initFCM();
    _checkForNotification();  // Check for saved notification when the app is opened
  }

  Future<void> _checkForNotification() async {
  final prefs = await SharedPreferences.getInstance();
  final command = prefs.getString('notification_command');

  if (command == 'wipe') {
    // Perform the wipe function
    triggerWipe();

    // Optionally, remove the saved command after triggering the wipe
    await prefs.remove('notification_command');
  }
}

  // Future<void> _initFCM() async {
  //   final messaging = FirebaseMessaging.instance;
  //   await messaging.requestPermission();

  //   deviceToken = await messaging.getToken();
  //   print("📱 Device FCM Token: $deviceToken");

  //   // Send token to backend (optional)
  //   await _sendTokenToBackend(deviceToken!);

  //    // Set up the background message handler
  //   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  //   // Listen for foreground message
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.data['command'] == 'wipe') {
  //       // _performWipe();
  //       triggerWipe();
  //     }
  //   });

  //   // Listen for background opened message
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     if (message.data['command'] == 'wipe') {
  //       // _performWipe();
  //       triggerWipe();
  //     }
  //   });
  // }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }

  Future<void> _sendTokenToBackend(String token) async {

    String? deviceId = await getDeviceId();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.137.1:8000/register-device'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "device_id": deviceId,
          'fcm_token': token
        }),
      );
      print("✅ Token sent to backend: ${response.body}");
    } catch (e) {
      print("❌ Error sending token to backend: $e");
    }
  }

  Future<void> _performWipe() async {
    print("⚠️ Wipe command received!");

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    final cacheDir = await getTemporaryDirectory();
    if (await cacheDir.exists()) await cacheDir.delete(recursive: true);

    final dir = await getApplicationDocumentsDirectory();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }

    print("✅ App data wiped");
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Remote Wipe"),
          content: Text("All SafeApp data has been securely deleted."),
        ),
      );
    }

    if (Platform.isAndroid) {
      SystemNavigator.pop(); // graceful exit
    }
  }

  Future<void> triggerWipe() async {
    const platform = MethodChannel('com.example.safeapp/app_blocker');
    try {
      final result = await platform.invokeMethod('wipeData');
      print("✅ App data wiped: $result");
    } on PlatformException catch (e) {
      print("❌ Failed to wipe data: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(child: _screens[_selectedIndex]),
      drawer: const SideDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 21, 29, 42),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        iconSize: 26,
        elevation: 8,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Financial Apps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Detect Apps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
