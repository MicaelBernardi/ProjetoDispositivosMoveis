import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AuthService {
  static const _tokenKey = "token";

  static const _timeout = Duration(seconds: 10);

  /// LOGIN

  Future<bool> login(String email, String senha) async {
    final response = await http
        .post(
          Uri.parse('${ApiConfig.baseUrl}/login'),

          headers: {'Content-Type': 'application/json'},

          body: jsonEncode({'email': email, 'senha': senha}),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final dados = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_tokenKey, dados['token']);

      return true;
    }

    return false;
  }

  /// TOKEN

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_tokenKey);
  }

  /// HEADERS

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();

    return {
      "Content-Type": "application/json",

      "Authorization": "Bearer $token",
    };
  }

  /// LOGOUT

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tokenKey);
  }

  /// VERIFICA LOGIN

  Future<bool> isLogged() async {
    final token = await getToken();

    return token != null;
  }
}
