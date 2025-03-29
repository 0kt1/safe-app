import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';

class SecureContainerScreen extends StatefulWidget {
  const SecureContainerScreen({super.key});

  @override
  State<SecureContainerScreen> createState() => _SecureContainerScreenState();
}

class _SecureContainerScreenState extends State<SecureContainerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SecureBank Hub")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        children: [
          SecureAppTile(appName: "Google Pay"),
          SecureAppTile(appName: "Paytm"),
          SecureAppTile(appName: "HDFC Bank"),
        ],
      ),
    );
  }
}

void openGooglePay() {
  const intent = AndroidIntent(
    action: 'android.intent.action.VIEW',
    package: 'com.google.android.apps.nbu.paisa.user',
    arguments: {'secure_launch': 'SecureBankHub'},
    flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
  );
  intent.launch();
}

class SecureAppTile extends StatelessWidget {
  final String appName;
  SecureAppTile({required this.appName});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_balance, size: 50, color: Colors.blue),
          const SizedBox(height: 10),
          Text(appName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text("Secure", style: TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}
