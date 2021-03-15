import 'package:ethio_shoppers/core/services/auth_service.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  AuthService _authService = AuthService();

  Future<void> signUp(String email, String password) async {
    return await _authService.authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return await _authService.authenticate(email, password, "login");
  }
}