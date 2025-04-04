import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safeapp/services/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    String? token = await AuthService.getToken();
    Timer(const Duration(seconds: 3), () {
      if (token?.isEmpty ?? true) {
        // Navigate to the welcome screen if token is empty
        Navigator.pushReplacementNamed(context, '/welcome');
      } else {
        // Navigate directly to the login screen if token is not empty
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white, // Card color
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          child: Image.asset(
            'assets/icon/icon.png', // Make sure your logo is in the assets folder
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }
}
