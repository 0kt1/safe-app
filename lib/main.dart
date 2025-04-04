import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeapp/home.dart';
import 'package:safeapp/screens/auth/login.dart';
import 'package:safeapp/screens/auth/register.dart';
import 'package:safeapp/screens/auth/safe_login.dart';
import 'package:safeapp/screens/permission.dart';
import 'package:safeapp/screens/securecontainer.dart';
import 'package:safeapp/screens/welcome.dart';
import 'package:safeapp/screens/whitelist.dart';
import 'package:safeapp/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Block screenshots and screen recordings at runtime
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  
  runApp(const MainApp());
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
      // initialRoute: '/home_screen',
      initialRoute: '/permissions',
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
      },
    );
  }
}
