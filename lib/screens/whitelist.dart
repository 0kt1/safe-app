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
      appBar: AppBar(title: Text("Whitelist Apps")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Select banking apps to protect:",
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  CheckboxListTile(
                    title: Text("Google Pay"),
                    value: true,
                    onChanged: (val) {},
                  ),
                  CheckboxListTile(
                    title: Text("Paytm"),
                    value: true,
                    onChanged: (val) {},
                  ),
                  CheckboxListTile(
                    title: Text("PhonePe"),
                    value: false,
                    onChanged: (val) {},
                  ),
                  CheckboxListTile(
                    title: Text("HDFC Bank"),
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
              child: Text("Proceed"),
            ),
          ],
        ),
      ),
    );
  }
}