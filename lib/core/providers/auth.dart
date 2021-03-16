import 'dart:async';
import 'dart:convert';
import 'package:ethio_shoppers/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  AuthService _authService = AuthService();

  bool get isAuth => token != null;


  String get userId => _userId;

  String get token {
    if(_expiryDate != null && _token != null && _expiryDate.isAfter(DateTime.now()))
      return _token;

    return null;
  }

  Future<void> updateAuth(dynamic  authData) async {
    _token = authData["idToken"];
    _userId = authData["localId"];
    _expiryDate = DateTime.now().add(Duration(seconds: int.parse(authData["expiresIn"])));
    _autoLogout();
    notifyListeners();
    await saveUserData();
  }

  Future saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      "token": _token,
      "userId": _userId,
      "expiryDate": _expiryDate.toIso8601String()
    });
    prefs.setString("userData", userData);
  }

  Future<bool> tryAutoLogin() async {

    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("userData"))
      return false;

    final extractedUserData = json.decode(prefs.getString("userData")) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now()))
      return false;

    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
    return true;
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

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
    notifyListeners();
  }

  void _autoLogout() {
    if(_authTimer != null) _authTimer.cancel();
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}