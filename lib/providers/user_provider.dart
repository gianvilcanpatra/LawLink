import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_provider.dart';
import 'package:lawyer_appointment_app/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  Future<void> fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      var userData = await DioProvider().getUser(token);
      _user = User.fromJson(jsonDecode(userData));
      notifyListeners();
    }
  }

  Future<bool> updateUser(String? name, String? email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      bool success = await DioProvider().updateUser(token, name, email);
      if (success) {
        await fetchUser();
        return true;
      }
    }
    return false;
  }

  Future<bool> uploadPhoto(File? image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null && image != null) {
      bool success = await DioProvider().uploadPhoto(token, image);
      if (success) {
        await fetchUser();
        return true;
      }
    }
    return false;
  }
}