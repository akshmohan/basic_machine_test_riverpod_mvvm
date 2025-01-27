// ignore_for_file: file_names, prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, avoid_print, unnecessary_null_comparison
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvvm/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm/repositories/auth_repository.dart';
import 'package:mvvm/services/storage_service.dart';

class AuthenticationViewmodel with ChangeNotifier {
 
 String? _accessToken;
 String? _username;
  bool _isAuthenticated = false;
  UserModel? _user;
  bool _isInitialized = false;

 
  String? get accessToken => _accessToken;
  String? get username => _username;
  bool get isAuthenticated => _isAuthenticated;
  UserModel? get user => _user;
  bool get isInitialized => _isInitialized;

  AuthenticationViewmodel() {
    _initializeAuthentication();
  }

    Future<void> _initializeAuthentication() async {
    try {
      final storageService = StorageService();
      final token = await storageService.getAccessToken();
      final username = await storageService.getUsername();
      if (token != null) {
        _isAuthenticated = true;
        _user = UserModel(accessToken: token, username: username);
        _accessToken = token;
        if(_user != null) {
          _username = _user!.username;
        }
      }
    } catch (_) {
      _isAuthenticated = false;
      _user = null;
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    try {
      final _authRepository = AuthRepository();
      final result = await _authRepository.login(username, password);
      if (result["accessToken"] != null) {
        final storageServcice = StorageService();
        await storageServcice.saveAccessToken(result['accessToken']);
        await storageServcice.saveUsername(username);
        _accessToken = result['accessToken'];
        _username = username;
        print(storageServcice);
      } else {
        throw Exception("Access token is null");
      }

      _isAuthenticated = true;

      _user = UserModel.fromJson(result);

      notifyListeners();
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> logout() async {
    try {
      final _authRepository = AuthRepository();
      await _authRepository.logout();
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

final authenticationProvider =
    ChangeNotifierProvider<AuthenticationViewmodel>((ref) {
  return AuthenticationViewmodel();
});
