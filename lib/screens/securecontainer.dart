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
