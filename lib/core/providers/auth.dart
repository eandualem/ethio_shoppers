import 'package:ethio_shoppers/core/services/auth_service.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  AuthService _authService = AuthService();

  bool get isAuth => token != null;
  String get userId => _userId;

  String get token {
    if(_expiryDate != null && _token != null && _expiryDate.isAfter(DateTime.now()))
      return _token;
    return null;
  }

  void updateAuth(dynamic  authData) {
    _token = authData["idToken"];
    _userId = authData["localId"];
    _expiryDate = DateTime.now().add(Duration(seconds: int.parse(authData["expiresIn"])));
    notifyListeners();
  }
  Future<void> signUp(String email, String password) async {
    final authData = await _authService.authenticate(email, password, "signUp");
    updateAuth(authData);
    return;
  }
  Future<void> login(String email, String password) async {
    final authData = await _authService.authenticate(email, password, "login");
    updateAuth(authData);
    return;
  }
}