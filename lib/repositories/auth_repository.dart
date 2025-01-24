import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvvm/services/storage_service.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("https://dummyjson.com/auth/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['accessToken'] != null) {
          final storageService = StorageService();
          await storageService.saveAccessToken(data['accessToken']);
        } else {
          throw Exception(
              "----------------ACCESS TOKEN IS MISSING IN THE RESPONSE!!!-------------------");
        }

        return data;
      } else {
        throw Exception(
            "Invalid username or password : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> logout() async {
    try {
      final storageService = StorageService();
      await storageService.clearAccessToken();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
