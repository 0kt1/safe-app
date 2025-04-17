import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeapp/firebase_options.dart';
import 'package:safeapp/home.dart';
import 'package:safeapp/screens/auth/login.dart';
import 'package:safeapp/screens/auth/register.dart';
import 'package:safeapp/screens/auth/safe_login.dart';
import 'package:safeapp/screens/auth/test.dart';
import 'package:safeapp/screens/permission.dart';
import 'package:safeapp/screens/root.dart';
import 'package:safeapp/screens/welcome.dart';
import 'package:safeapp/screens/whitelist.dart';
import 'package:safeapp/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Block screenshots and screen recordings at runtime
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseApi().initNotifications();
  await _initFCM();


  //  // Set up the background message handler
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MainApp());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

}

String? deviceToken;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  
  // Optionally, show a local notification
  // FlutterLocalNotificationsPlugin().show(...)

  if (message.data['command'] == 'wipe') {
    await _saveNotificationData('wipe');
    // triggerWipe();
  }
}

Future<void> _saveNotificationData(String command) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('notification_command', command);
  print("✅ Notification command saved: $command");
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


 Future<void> _initFCM() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    deviceToken = await messaging.getToken();
    print("📱 Device FCM Token: $deviceToken");

    // Send token to backend (optional)
    await _sendTokenToBackend(deviceToken!);

     // Set up the background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    // Listen for foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['command'] == 'wipe') {
        // _performWipe();
        triggerWipe();
      }
    });

    // Listen for background opened message
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['command'] == 'wipe') {
        // _performWipe();
        triggerWipe();
      }
    });
  }

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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe App',
      // theme: ThemeData(primarySwatch: Colors.deepPurple),
      // initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home_screen',
      // initialRoute: '/testauthscreen',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/safe_login': (context) => const SafeLogin(),
        '/register': (context) => const DeviceRegistrationScreen(),
        '/permissions': (context) => const PermissionsScreen(),
        '/whitelist': (context) => const WhitelistScreen(),
        '/home_screen': (context) => const HomeScreen(),
        // '/secure_container': (context) => const SecureContainerScreen(),
        '/testauthscreen': (context) => BiometricAuthPage(),
        '/root_page': (context) => const RootChecker(),
      },
    );
  }
}
