import 'package:flutter/material.dart';

class WhitelistScreen extends StatefulWidget {
  const WhitelistScreen({super.key});

  @override
  State<WhitelistScreen> createState() => _WhitelistScreenState();
}

class _WhitelistScreenState extends State<WhitelistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Whitelist Apps")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Select banking apps to protect:",
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  CheckboxListTile(
                    title: const Text("Google Pay"),
                    value: true,
                    onChanged: (val) {},
                  ),
                  CheckboxListTile(
                    title: const Text("Paytm"),
                    value: true,
                    onChanged: (val) {},
                  ),
                  CheckboxListTile(
                    title: const Text("PhonePe"),
                    value: false,
                    onChanged: (val) {},
                  ),
                  CheckboxListTile(
                    title: const Text("HDFC Bank"),
                    value: true,
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home_screen');
              },
              child: const Text("Proceed"),
            ),
          ],
        ),
      ),
    );
  }
}