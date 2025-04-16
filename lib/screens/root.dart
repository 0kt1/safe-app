import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:root_jailbreak_sniffer/rjsniffer.dart';

// class RootCheckApp extends StatelessWidget {
//   const RootCheckApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: RootChecker());
//   }
// }

class RootChecker extends StatefulWidget {
  const RootChecker({super.key});

  @override
  State<RootChecker> createState() => _RootCheckerState();
}

class _RootCheckerState extends State<RootChecker> {
  bool amICompromised = false;
  bool amIEmulator = false;
  bool amIDebugged = false;

  @override
  void initState() {
    super.initState();
    runRootChecks();
  }

  Future<void> runRootChecks() async {
    try {
      bool compromised = await Rjsniffer.amICompromised() ?? false;
      bool emulator = await Rjsniffer.amIEmulator() ?? false;
      bool debugged = await Rjsniffer.amIDebugged() ?? false;

      setState(() {
        amICompromised = compromised;
        amIEmulator = emulator;
        amIDebugged = debugged;
      });
    } catch (e) {
      debugPrint("Error checking root/jailbreak: $e");
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Root/Jailbreak Sniffer")),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text("Compromised (Root/Jailbreak): $amICompromised"),
  //           Text("Running on Emulator: $amIEmulator"),
  //           Text("Is Debugged: $amIDebugged"),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Root/Jailbreak Detection",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background effect
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.security_rounded,
                          color: Colors.tealAccent, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        "Device Security Status",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildStatusRow(
                          "Compromised (Root/Jailbreak)",
                          amICompromised,
                          "Indicates whether the device is rooted or jailbroken, which may expose it to security risks.",
                          context),
                      _buildStatusRow(
                          "Running on Emulator",
                          amIEmulator,
                          "Checks if the app is being run inside an emulator, often used for reverse engineering or testing.",
                          context),
                      _buildStatusRow(
                          "Is Debugged",
                          amIDebugged,
                          "Detects if the app is currently being debugged, which can be a sign of tampering.",
                          context),
                    ],
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatusRow(String label, bool value, String description, BuildContext context) {
  final String statusText = value
      ? (label.contains("Root") ? "Rooted"
          : label.contains("Emulator") ? "Running on Emulator"
          : "Debugged")
      : (label.contains("Root") ? "Not Rooted"
          : label.contains("Emulator") ? "Not on Emulator"
          : "Not Debugged");

  final Color statusColor = value ? Colors.orangeAccent : Colors.greenAccent;

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B), // deep blue-gray background for dark mode
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.white.withOpacity(0.05),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Label & Description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.white,
          ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade400,
          ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // Right: Status Text
        Text(
          statusText,
          
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: statusColor,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    ),
  );
}
