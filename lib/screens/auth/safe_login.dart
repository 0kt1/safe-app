import 'package:flutter/material.dart';
import 'package:safeapp/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../services/aes.dart';

class SafeLogin extends StatefulWidget {
  const SafeLogin({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Username and password cannot be empty.";
        _isLoading = false;
      });
      return;
    }

    try {
      String encryptedUsername = AESHelper.encrypt(username);
      String encryptedPassword = AESHelper.encrypt(password);
      final response = await _dio.post(
        "/login",
        data: {"username": encryptedUsername, "password": encryptedPassword},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      final data = response.data;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["access_token"]);
      await prefs.setString("role", data["role"]);

      // Securely save token
      await AuthService.saveToken(data["access_token"]);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful! Redirecting...")),
      );

      // Navigate to home screen after login
      Navigator.pushReplacementNamed(context, "/permissions");
    } on DioException catch (e) {
      setState(() {
        _errorMessage = e.response?.data["detail"] ?? "Login failed. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
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
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text("Login"),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/register");
                  },
                  child: const Text(
                    "If device not registered, please Register",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
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
