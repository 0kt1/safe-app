import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeapp/services/auth.dart';
import '../models/user_model.dart';

class GetUser {
  static const String apiUrl = 'http://192.168.137.1:8000/auth/me';

  static Future<User> fetchUserData() async {
    try {
      
      // Retrieve the stored token from SharedPreferences or SecureStorage
      String? token = await AuthService.getToken(); // Implement this function in auth_service.dart

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("User data fetched successfully: ${response.body}");
        return User.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }
}
