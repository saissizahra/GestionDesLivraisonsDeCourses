import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mkadia/models/user.dart';
import 'package:mkadia/services/authService.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

Future<void> login(String email, String password) async {
  try {
    final response = await AuthService.login(email, password);
    
    // Conversion explicite des types
    final userData = Map<String, dynamic>.from(response['user']);
    userData['id'] = int.parse(userData['id'].toString()); // Conversion en int
    
    _user = User.fromJson(userData);
    _token = response['token'].toString();
    
    notifyListeners();
  } catch (e) {
    debugPrint('Login error: $e');
    rethrow;
  }
}

  Future<void> register(String name, String email, String password, String role) async {
    try {
      final response = await AuthService.register(name, email, password, role);

      _user = User.fromJson(response['user']);
      _token = response['token'];

      notifyListeners();
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  Future<void> fetchUser() async {
    try {
      if (_token == null) throw Exception('No token available');

      final userData = await AuthService.fetchUser(_token!);
      _user = User.fromJson(userData);

      notifyListeners();
    } catch (e) {
      print('Fetch user error: $e');
      rethrow;
    }
  }

Future<void> logout() async {
  try {
    // Appel API pour logout
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/logout'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      _user = null;
      _token = null;
      notifyListeners();
    } else {
      throw Exception('Logout failed');
    }
  } catch (e) {
    debugPrint('Logout error: $e');
    // Même en cas d'erreur API, on nettoie localement
    _user = null;
    _token = null;
    notifyListeners();
  }
}
}