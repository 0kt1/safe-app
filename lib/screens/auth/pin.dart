import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safeapp/home.dart';
import 'dart:convert';

import 'package:safeapp/screens/auth/blockapp.dart';

bool isBlocked = false;
String? newPin;

class Pinscreen extends StatefulWidget {
  const Pinscreen({super.key});

  @override
  State<Pinscreen> createState() => _PinscreenState();
}

class _PinscreenState extends State<Pinscreen> {
  @override
  void initState() {
    super.initState();
    getDeviceId();
    checkDeviceStatus();
  }

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

  Future<void> checkDeviceStatus() async {
    final response = await http.get(
      Uri.parse("http://10.22.14.158:8000/auth/device-status/${getDeviceId()}"),
      headers: {
        "Cache-Control": "no-cache, no-store, must-revalidate",
        "Pragma": "no-cache",
        "Expires": "0",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("device status: ${data["is_blocked"]}");

      if (data["is_blocked"]) {
        // Navigate to Blocked Screen
        setState(() {
          isBlocked = true;
          newPin = data["new_pin"];
          print("new pin: $newPin");
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeviceBlockListener(
                  newPin: data["new_pin"],
                  deviceId: '',
                )));
      } else {
        // Device is not blocked, proceed with normal flow
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("pin scren"),
            const Text("pin "),
            // TextField(
            //   controller: _pinController,
            //   decoration: const InputDecoration(labelText: "Enter New PIN"),
            //   obscureText: true,
            // ),
            // ElevatedButton(
            //   onPressed: _validatePin,
            //   child: const Text("Unlock App"),
            // ),
          ],
        ),
      ),
    );
  }
}
