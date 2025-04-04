import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeapp/components/side_drawer.dart';
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
    backgroundColor: const Color(0xFF0F172A),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text("Profile",
          style: GoogleFonts.inter(
              color: Colors.white, fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
    ),
    drawer: const SideDrawer(),
    body: FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        } else if (snapshot.hasError || !snapshot.hasData) {
          // return const Center(
          //     child: Text("Unable to load profile",
          //         style: TextStyle(color: Colors.white70)));
        }

        // final user = snapshot.data!;

        final user = snapshot.data ??
              User(
                userName: "kaustubh",
                deviceId: "RP1A.200720.012",
                phoneNumber: "1234567890",
                linkedbankAccount: "IOBA1234567897845956",
                role: 'user',
              );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: GlassmorphicContainer(
                  width: double.infinity,
                  height: 100,
                  borderRadius: 20,
                  blur: 20,
                  alignment: Alignment.center,
                  border: 2,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white38.withOpacity(0.05)
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white24,
                      Colors.white10,
                    ],
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    title: Text(user.userName,
                        style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    subtitle: Text("User Name",
                        style: GoogleFonts.inter(
                            color: Colors.white54, fontSize: 14)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: _buildProfileCard(
                    icon: Icons.devices,
                    title: user.deviceId,
                    subtitle: "Registered Device ID"),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: _buildProfileCard(
                    icon: Icons.account_box,
                    title: user.linkedbankAccount,
                    subtitle: "Linked Bank Account Number"),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: _buildProfileCard(
                    icon: Icons.phone,
                    title: user.phoneNumber,
                    subtitle: "Linked Phone Number"),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: _buildProfileCard(
                    icon: Icons.logout,
                    title: "Logout",
                    subtitle: "Tap to logout",
                    onTap: () {
                      AuthService.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    }),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24)),
                  icon: const Icon(Icons.open_in_browser, color: Colors.black),
                  onPressed: () => _openTrustedWebsite("https://example.com"),
                  label: Text("Open Trusted Website",
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ),
              ),
              const SizedBox(height: 10),
              // FadeInUp(
              //   duration: const Duration(milliseconds: 1000),
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.redAccent.shade700,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12)),
              //         padding: const EdgeInsets.symmetric(
              //             vertical: 14, horizontal: 24)),
              //     icon: const Icon(Icons.block),
              //     onPressed: () async {
              //       try {
              //         await methodChannel.invokeMethod('blockApplication', {
              //           'packageName': 'com.confirmtkt.lite',
              //         });
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(
              //               content: Text('App blocked successfully')),
              //         );
              //       } catch (e) {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           SnackBar(content: Text('Error: ${e.toString()}')),
              //         );
              //       }
              //     },
              //     label: Text("Block App",
              //         style: GoogleFonts.inter(
              //             fontSize: 16,
              //             fontWeight: FontWeight.w500,
              //             color: Colors.white)),
              //   ),
              // ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildProfileCard(
    {required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: GlassmorphicContainer(
      width: double.infinity,
      height: 100,
      borderRadius: 16,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.05),
          Colors.white10.withOpacity(0.02)
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white24,
          Colors.white10,
        ],
      ),
      child: ListTile(
        leading: Icon(icon, size: 36, color: Colors.white),
        title: Text(title,
            style: GoogleFonts.inter(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
        subtitle: Text(subtitle,
            style: GoogleFonts.inter(color: Colors.white54, fontSize: 14)),
      ),
    ),
  );
}


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Profile")),
  //     body: FutureBuilder<User>(
  //       future: _userFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           // return const Center(child: Text("Error loading profile"));
  //         } else if (!snapshot.hasData) {
  //           // return const Center(child: Text("No data available"));
  //         }

  //         final user = snapshot.data ??
  //             User(
  //               userName: "Unknown",
  //               deviceId: "Unknown",
  //               phoneNumber: "Unknown",
  //               role: 'Unknown',
  //             );

  //         return Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               ListTile(
  //                 leading: const Icon(Icons.person, size: 40),
  //                 title: Text(user.userName,
  //                     style: const TextStyle(
  //                         fontSize: 20, fontWeight: FontWeight.bold)),
  //                 subtitle: const Text("User Name"),
  //               ),
  //               const Divider(),
  //               ListTile(
  //                 leading: const Icon(Icons.devices, size: 40),
  //                 title:
  //                     Text(user.deviceId, style: const TextStyle(fontSize: 18)),
  //                 subtitle: const Text("Registered Device ID"),
  //               ),
  //               const Divider(),
  //               ListTile(
  //                 leading: const Icon(Icons.phone, size: 40),
  //                 title: Text(user.phoneNumber,
  //                     style: const TextStyle(fontSize: 18)),
  //                 subtitle: const Text("Linked Phone Number"),
  //               ),
  //               const Divider(),
  //               ListTile(
  //                 leading: const Icon(Icons.logout, size: 40),
  //                 title: Text(user.phoneNumber,
  //                     style: const TextStyle(fontSize: 18)),
  //                 subtitle: const Text("Logout"),
  //                 onTap: () => {
  //                   AuthService.logout(),
  //                   Navigator.pushReplacementNamed(context, '/login')
  //                 },
  //               ),
  //               const Divider(),
  //               Center(
  //                 child: ElevatedButton(
  //                   onPressed: () => _openTrustedWebsite(""),
  //                   child: const Text("Open Trusted Website"),
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   try {
  //                     await methodChannel
  //                         .invokeMethod('blockApplication', {
  //                       'packageName': 'com.confirmtkt.lite',
  //                     });
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                           content: Text('App blocked successfully')),
  //                     );
  //                   } catch (e) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(content: Text('Error: ${e.toString()}')),
  //                     );
  //                   }
  //                 },
  //                 child: const Text('Block App'),
  //               )
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
