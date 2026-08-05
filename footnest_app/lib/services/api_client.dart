import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/config/api_config.dart';
import 'dart:io';

class ApiClient {

  final String baseUrl = ApiConfig.baseUrl;

  Map<String, String> get headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Future<Map<String,String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final headers = {
      "Content-Type":"application/json",
      "Accept":"application/json",
    };

    if(token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;

  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await getHeaders(),
    );

    return _handleResponse(response);
  }

  Future<dynamic> post(
      String endpoint,
      dynamic body
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await getHeaders(),
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
      headers: await getHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> delete(
      String endpoint
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await getHeaders(),
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

  Future uploadFile(
    String endpoint,
    File file,
    Map<String, String> fields,
  ) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$endpoint'),
    );


    request.headers.addAll({
      "Accept": "application/json",
    });


    fields.forEach((key, value) {
      request.fields[key] = value;
    });


    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
      ),
    );


    final streamedResponse = await request.send();


    final response =
        await http.Response.fromStream(streamedResponse);


    return _handleResponse(response);
  }
  
}