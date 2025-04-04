import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeapp/services/auth.dart';
import '../models/user_model.dart';
import '../services/get_me.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = GetUser.fetchUserData();
  }

  void _openTrustedWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open $url")),
      );
    }
  }

  final methodChannel = MethodChannel('device_admin_channel');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // return const Center(child: Text("Error loading profile"));
          } else if (!snapshot.hasData) {
            // return const Center(child: Text("No data available"));
          }

          final user = snapshot.data ??
              User(
                userName: "Unknown",
                deviceId: "Unknown",
                phoneNumber: "Unknown",
                role: 'Unknown',
              );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, size: 40),
                  title: Text(user.userName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: const Text("User Name"),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.devices, size: 40),
                  title:
                      Text(user.deviceId, style: const TextStyle(fontSize: 18)),
                  subtitle: const Text("Registered Device ID"),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone, size: 40),
                  title: Text(user.phoneNumber,
                      style: const TextStyle(fontSize: 18)),
                  subtitle: const Text("Linked Phone Number"),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, size: 40),
                  title: Text(user.phoneNumber,
                      style: const TextStyle(fontSize: 18)),
                  subtitle: const Text("Logout"),
                  onTap: () => {
                    AuthService.logout(),
                    Navigator.pushReplacementNamed(context, '/login')
                  },
                ),
                const Divider(),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _openTrustedWebsite(""),
                    child: const Text("Open Trusted Website"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await methodChannel
                          .invokeMethod('blockApplication', {
                        'packageName': 'com.confirmtkt.lite',
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('App blocked successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  child: const Text('Block App'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
