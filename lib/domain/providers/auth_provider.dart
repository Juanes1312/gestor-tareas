import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn;

  AuthProvider({required bool isLoggedIn}) : _isLoggedIn = isLoggedIn;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (username == 'user' && password == 'password') {
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      notifyListeners();
      return true;
    }
    _isLoggedIn = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    notifyListeners();
  }
}
