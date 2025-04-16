import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  // final String baseUrl = "http://localhost:8000/auth"; // Change for production

  // Future<bool> login(String username, String password) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse("$baseUrl/login"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"username": username, "password": password}),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       // Store token & role
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("token", data["access_token"]);
  //       await prefs.setString("role", data["role"]);

  //       return true; // Login successful
  //     } else {
  //       print("Login failed: ${response.body}");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Error during login: $e");
  //     return false;
  //   }
  // }

  static const _storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }


  // ========================================================

  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    return await auth.canCheckBiometrics;
  }

  Future<bool> isDeviceSupported() async {
    return await auth.isDeviceSupported();
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await auth.getAvailableBiometrics();
  }

  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }
}