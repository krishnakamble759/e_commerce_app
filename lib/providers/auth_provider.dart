import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier{
  final AuthService _authservice = AuthService();

  String? _token;
  bool _isLoading = false;

  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final token = await _authservice.login(username, password);
    _isLoading = false;

    if (token != null && token.isNotEmpty) {
      _token = token;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await _authservice.logout();
    _token = null;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
      _token = token;
      notifyListeners();
    }
}