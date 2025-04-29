import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthService {
  final storage = const FlutterSecureStorage();
  final String baseUrl = "http://<DJANGO_BACKEND_IP>:8000"; // doğru IP'yi yaz

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/token/login/'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['auth_token']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String firstName, String lastName, String birthDate, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/users/'),
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'birth_date': birthDate, // "YYYY-MM-DD" formatında gönder
        'email': email,
        'password': password,
      },
    );
    return response.statusCode == 201;
  }

  Future<void> logout() async {
    final token = await storage.read(key: 'token');
    await http.post(
      Uri.parse('$baseUrl/auth/token/logout/'),
      headers: {'Authorization': 'Token $token'},
    );
    await storage.delete(key: 'token');
  }
}
