import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeapp/screens/root.dart';
import 'package:safeapp/screens/security.dart';
import 'package:safeapp/screens/sms.dart';
import 'package:safeapp/screens/toggle_apps.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E293B),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //   ),
            // ),
            child: const CircleAvatar(
              radius: 40,
              backgroundImage:
                  AssetImage("assets/icon/icon.png"), // Change as needed
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildDrawerItem(
                  icon: Icons.toggle_off_rounded,
                  title: "Toggle Apps",
                  context: context,
                  page: const ToggleAppsScreen(), // Replace with your screen
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: "System Security Check",
                  context: context,
                  page: SecurityScreen(), // Replace with your screen
                ),

                _buildDrawerItem(
                  icon: Icons.security_rounded,
                  title: "Root/Jailbreak Check",
                  context: context,
                  page: const RootChecker(), // Replace with your screen
                ),


                _buildDrawerItem(
                  icon: Icons.security_rounded,
                  title: "Secure Messages",
                  context: context,
                  page: const SmsInboxScreen(), // Replace with your screen
                ),
                // _buildDrawerItem(
                //   icon: Icons.settings,
                //   title: "Settings",
                //   context: context,
                //   page: const SettingsScreen(), // Replace with your screen
                // ),
                // _buildDrawerItem(
                //   icon: Icons.security,
                //   title: "Privacy",
                //   context: context,
                //   page: const PrivacyScreen(), // Replace with your screen
                // ),// Divider for spacing
                // _buildDrawerItem(
                //   icon: Icons.info,
                //   title: "About",
                //   context: context,
                //   page: const AboutScreen(), // Replace with your screen
                // ),
              ],
            ),
          ),

          Text(
            "Version 1.0",
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Made by Team INVICTUS",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  // Drawer Item Widget
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required BuildContext context,
    required Widget page,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}
