import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../services/aes.dart';

// AES Key (Must be same as the backend)
// const String AES_SECRET_KEY = "mysecretaeskey123";

// Encrypt data using AES
// String encryptData(String text) {
//   final key = encrypt.Key.fromUtf8(AES_SECRET_KEY);
//   final iv = encrypt.IV.fromUtf8(AES_SECRET_KEY);
//   final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
//
//   final encrypted = encrypter.encrypt(text, iv: iv);
//   return base64.encode(encrypted.bytes);
// }

class DeviceRegistrationScreen extends StatefulWidget {
  const DeviceRegistrationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeviceRegistrationScreenState createState() => _DeviceRegistrationScreenState();
}

class _DeviceRegistrationScreenState extends State<DeviceRegistrationScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String suggestedPassword = "";

  @override
  void initState() {
    super.initState();
    suggestedPassword = generateStrongPassword(); // Generate strong password
  }

  /// Generates a very strong password with increased randomness and length (20 chars)
  String generateStrongPassword({int length = 20}) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_=+[]{}|;:,.<>?/`~';
    Random random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }


  Future<void> registerDevice() async {
    setState(() => isLoading = true);
    
    String? deviceId = await getDeviceId();
    if (deviceId == null) return;

    // Encrypt data
    // Encrypt data before sending it to the backend
    String encryptedUsername = AESHelper.encrypt(usernameController.text);
    String encryptedPassword = AESHelper.encrypt(passwordController.text);
    String encryptedRole = AESHelper.encrypt('user');
    String encryptedDeviceId = AESHelper.encrypt(deviceId);

    print("encryptedUsername: $encryptedUsername");
    print("encryptedPassword: $encryptedPassword");
    print("encryptedRole: $encryptedRole");
    print("encryptedDeviceId: $encryptedDeviceId");

    var response = await http.post(
      Uri.parse('http://192.168.137.1:8000/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'deviceid': encryptedDeviceId,
        'username': encryptedUsername,
        'password': encryptedPassword,
        'role': encryptedRole,
        // 'deviceid': deviceId,
        // 'username': usernameController.text,
        // 'password': passwordController.text,
        // 'role': 'user',
      }),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('device_registered', true);
      // Navigator.pushReplacementNamed(context, '/permissions_screen');
      Navigator.pop(context, true); // Close the dialog and return true
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: const Text('Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    setState(() => isLoading = false);
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Device')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            Text("Suggested Strong Password:", style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
              suggestedPassword,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      passwordController.text = suggestedPassword;
                    });
                  },
                  child: const Text("Use Suggested Password"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      suggestedPassword = generateStrongPassword();
                    });
                  },
                  child: const Text("Regenerate Password"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: registerDevice,
                    child: const Text('Register'),
                  ),
          ],
        ),
      ),
    );
  }
}