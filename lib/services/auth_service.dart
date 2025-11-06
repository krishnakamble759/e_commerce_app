import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService{
  static const String baseUrl = 'https://fakestoreapi.com';
  final storage = const FlutterSecureStorage();

  //login user and get token
  Future<String?> login (String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body : json.encode({
        'username': username,
        'password' : password,
      }),
    );

    print('--- LOGIN DEBUG ---');
    print('Request: $username / $password');
    print('Status code: ${res.statusCode}');
    print('Body: ${res.body}');
    print('-------------------');


    if (res.statusCode == 200 || res.statusCode ==201) {
      final data = json.decode(res.body);
      final token = data['token'];
      await storage.write(key: 'token', value: token);
      return token;
    } else{
      return null;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }
}