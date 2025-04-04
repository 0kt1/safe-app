// import 'package:flutter/material.dart';
// import 'package:safeapp/services/auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';

// import '../../services/aes.dart';

// class SafeLogin extends StatefulWidget {
//   const SafeLogin({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _SafeLoginState createState() => _SafeLoginState();
// }

// class _SafeLoginState extends State<SafeLogin> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   String? _errorMessage;

//   final Dio _dio = Dio(BaseOptions(baseUrl: "http://192.168.137.1:8000/auth"));

//   Future<void> _login() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     final String username = _usernameController.text.trim();
//     final String password = _passwordController.text.trim();

//     if (username.isEmpty || password.isEmpty) {
//       setState(() {
//         _errorMessage = "Username and password cannot be empty.";
//         _isLoading = false;
//       });
//       return;
//     }

//     try {
//       String encryptedUsername = AESHelper.encrypt(username);
//       String encryptedPassword = AESHelper.encrypt(password);
//       final response = await _dio.post(
//         "/login",
//         data: {"username": encryptedUsername, "password": encryptedPassword},
//         options: Options(headers: {"Content-Type": "application/json"}),
//       );

//       final data = response.data;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString("token", data["access_token"]);
//       await prefs.setString("role", data["role"]);

//       // Securely save token
//       await AuthService.saveToken(data["access_token"]);

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Login successful! Redirecting...")),
//       );

//       // Navigate to home screen after login
//       Navigator.pushReplacementNamed(context, "/permissions");
//     } on DioException catch (e) {
//       setState(() {
//         _errorMessage = e.response?.data["detail"] ?? "Login failed. Please try again.";
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Login")),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextField(
//                   controller: _usernameController,
//                   decoration: const InputDecoration(labelText: "Username"),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: _obscurePassword,
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     suffixIcon: IconButton(
//                       icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
//                       onPressed: () {
//                         setState(() {
//                           _obscurePassword = !_obscurePassword;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 if (_errorMessage != null)
//                   Text(
//                     _errorMessage!,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 const SizedBox(height: 10),
//                 _isLoading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                         onPressed: _login,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                           textStyle: const TextStyle(fontSize: 16),
//                         ),
//                         child: const Text("Login"),
//                       ),
//                       const SizedBox(height: 20),
//                       GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, "/register");
//                   },
//                   child: const Text(
//                     "If device not registered, please Register",
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontSize: 14,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:safeapp/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/aes.dart';

class SafeLogin extends StatefulWidget {
  const SafeLogin({super.key});

  @override
  _SafeLoginState createState() => _SafeLoginState();
}

class _SafeLoginState extends State<SafeLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  final Dio _dio = Dio(BaseOptions(baseUrl: "http://192.168.137.1:8000/auth"));

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Username and password cannot be empty.";
        _isLoading = false;
      });
      return;
    }

    try {
      final encryptedUsername = AESHelper.encrypt(username);
      final encryptedPassword = AESHelper.encrypt(password);
      final response = await _dio.post(
        "/login",
        data: {
          "username": encryptedUsername,
          "password": encryptedPassword,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      final data = response.data;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["access_token"]);
      await prefs.setString("role", data["role"]);
      await AuthService.saveToken(data["access_token"]);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful! Redirecting...")),
      );

      Navigator.pushReplacementNamed(context, "/permissions");
    } on DioException catch (e) {
      setState(() {
        _errorMessage =
            e.response?.data["detail"] ?? "Login failed. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Secure Login", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(height: 50),
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                const SizedBox(height: 10),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/register");
                  },
                  child: Center(
                    child: Text(
                      "Not registered? Tap here to Register",
                      style: GoogleFonts.inter(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
