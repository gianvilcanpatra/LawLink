import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    final url = Uri.parse('http://localhost:8000/api/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      _token = responseData['token'];
      _user = User.fromJson(responseData['user']);
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    final url = Uri.parse('http://localhost:8000/api/logout');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      _token = null;
      _user = null;
      notifyListeners();
    } else {
      throw Exception('Failed to logout');
    }
  }
}
