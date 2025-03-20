import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController pinController = TextEditingController();

  Future<void> _authenticate() async {
    bool authenticated = await auth.authenticate(
      localizedReason: 'Authenticate to access SecureBank Hub',
      options: const AuthenticationOptions(biometricOnly: true),
    );
    if (authenticated) {
      Navigator.pushReplacementNamed(context, '/permissions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text("Enter your PIN", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (pinController.text == '1234') { // Placeholder PIN check
                  Navigator.pushReplacementNamed(context, '/permissions');
                }
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text("Use Fingerprint"),
            ),
          ],
        ),
      ),
    );
  }
}
