import 'dart:convert';

import 'package:http/http.dart' as http;

import '../authentication/auth_service.dart';
import '../config/api_config.dart';

abstract class ApiService {
  Duration get timeout => const Duration(seconds: 10);

  Future<Map<String, String>> get headers async {
    final token = await AuthService().getToken();

    return {
      'Content-Type': 'application/json',

      'Authorization': 'Bearer $token',
    };
  }

  Uri uri(String endpoint) {
    return Uri.parse('${ApiConfig.baseUrl}$endpoint');
  }

  dynamic decode(http.Response response) {
    return jsonDecode(response.body);
  }
}
