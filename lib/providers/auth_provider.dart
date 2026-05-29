import 'package:flutter/material.dart';

import 'package:siresep/models/user_model.dart';

import 'package:siresep/services/auth_service.dart';

class AuthProvider
    extends ChangeNotifier {
  final AuthService
  _authService =
  AuthService();

  UserModel? _user;

  bool _isLoading = false;

  UserModel? get user =>
      _user;

  bool get isLoading =>
      _isLoading;

  bool get isLoggedIn =>
      _user != null;

  Future<void>
  restoreSession() async {
    _user =
        AuthService
            .currentUser;

    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;

    notifyListeners();

    try {
      _user =
      await _authService
          .login(
        email: email,
        password: password,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;

    notifyListeners();

    try {
      _user =
      await _authService
          .register(
        name: name,
        email: email,
        password: password,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService
        .logout();

    _user = null;

    notifyListeners();
  }
}