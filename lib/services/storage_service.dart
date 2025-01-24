// ignore_for_file: body_might_complete_normally_nullable

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  Future<void> saveAccessToken(String token) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  Future<String> getAccessToken () async{
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  if (accessToken == null) {
    throw Exception('Access token is null');
  }
  return accessToken;
}

  Future<void> clearAccessToken () async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }

}