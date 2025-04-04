// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:safeapp/services/auth.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final LocalAuthentication auth = LocalAuthentication();
//   final TextEditingController pinController = TextEditingController();

//   Future<void> _authenticate() async {
//     String? token = await AuthService.getToken();
//     if (token?.isEmpty ?? true) {
//       bool authenticated = await auth.authenticate(
//         localizedReason: 'Authenticate to access SecureBank Hub',
//         options: const AuthenticationOptions(biometricOnly: true),
//       );
//       if (authenticated) {
//         Navigator.pushReplacementNamed(context, '/safe_login');
//       }
//     } else {
//       Navigator.pushReplacementNamed(context, '/safe_login');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.lock, size: 100, color: Colors.blueAccent),
//             const SizedBox(height: 20),
//             const Text("Enter your PIN", style: TextStyle(fontSize: 18)),
//             const SizedBox(height: 10),
//             TextField(
//               controller: pinController,
//               obscureText: true,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 if (pinController.text == '1234') {
//                   // Placeholder PIN check
//                   String? token = await AuthService.getToken();
//                   if (token?.isEmpty ?? true) {
//                     Navigator.pushReplacementNamed(context, '/safe_login');
//                   } else {
//                     Navigator.pushReplacementNamed(context, '/permissions');
//                   }
//                 }
//               },
//               child: const Text("Login"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _authenticate,
//               child: const Text("Use Fingerprint"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:safeapp/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController pinController = TextEditingController();

  Future<void> _authenticate() async {
    String? token = await AuthService.getToken();
    if (token?.isEmpty ?? true) {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to access SecureBank Hub',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated) {
        Navigator.pushReplacementNamed(context, '/safe_login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/safe_login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 400,
          borderRadius: 25,
          blur: 15,
          alignment: Alignment.center,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: 2,
          borderGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.05),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded, size: 55, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  "SAFE APP",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter your PIN",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (pinController.text == '1234') {
                      String? token = await AuthService.getToken();
                      if (token?.isEmpty ?? true) {
                        Navigator.pushReplacementNamed(context, '/safe_login');
                      } else {
                        Navigator.pushReplacementNamed(context, '/permissions');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _authenticate,
                  icon: const Icon(Icons.fingerprint, color: Colors.white70),
                  label: Text(
                    "Use Fingerprint",
                    style: GoogleFonts.inter(color: Colors.white70),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
