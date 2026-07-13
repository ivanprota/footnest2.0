import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiClient {

  final String baseUrl = ApiConfig.baseUrl;

  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );

    return _handleResponse(response);
  }

  Future<dynamic> post(
      String endpoint,
      dynamic body
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> put(
      String endpoint,
      dynamic body
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> delete(
      String endpoint
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );

    return _handleResponse(response);
  }

  dynamic _handleResponse(
      http.Response response
  ) {
    if(response.statusCode >= 200 &&
       response.statusCode < 300) {

      if(response.body.isEmpty) {
        return null;
      }

      return jsonDecode(response.body);
    }

    throw Exception(
      "Errore HTTP ${response.statusCode}: ${response.body}"
    );
  }
  
}