import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safeapp/home.dart';

class DeviceBlockListener extends StatefulWidget {
  final String deviceId;
  DeviceBlockListener({required this.deviceId, required newPin});

  @override
  _DeviceBlockListenerState createState() => _DeviceBlockListenerState();
}

class _DeviceBlockListenerState extends State<DeviceBlockListener> {
  bool isBlocked = false;
  String? newPin;
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // checkDeviceStatus();
  }

//   Future<void> checkDeviceStatus() async {
//   final response = await http.get(Uri.parse("https://your-api.com/device-status/YOUR_DEVICE_ID"));

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     if (data["is_blocked"]) {
//       // Navigate to Blocked Screen
//       setState(() {
//         isBlocked = true;
//         newPin = data["new_pin"];
//       });
//       // Navigator.push(context, MaterialPageRoute(builder: (context) => BlockedScreen(newPin: data["new_pin"])));
//     }
//   }
// }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print("device id: ${androidInfo.id}");
      return androidInfo.id; // This is the unique Android device ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // This is the unique iOS device ID
    }
    return "0";
  }

  Future<void> unlockDevice(String enteredPin) async {
    final response = await http.post(
      Uri.parse("http://10.22.14.158:8000/auth/unblock-device/${getDeviceId()}"),
      body: json.encode({"entered_pin": enteredPin}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // Successfully unblocked, navigate back to main screen
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("PIN Valid!")));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      // Show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid PIN!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("This app has been blocked remotely."),
            const Text("Enter the new PIN to continue."),
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(labelText: "Enter New PIN"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => {unlockDevice(_pinController.text)},
              child: const Text("Unlock App"),
            ),
          ],
        ),
      ),
    ); // Normal app screen when unblocked
  }
}
