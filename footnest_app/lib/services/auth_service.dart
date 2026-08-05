import 'package:shared_preferences/shared_preferences.dart';

import '/models/auth/auth_response.dart';
import '/services/api_client.dart';

class AuthService {

  final ApiClient apiClient;

  AuthService({
    required this.apiClient,
  });

  Future<AuthResponse> login(String username, String password) async {
    final response = await apiClient.post(
      "/auth/login",
      {
        "username": username,
        "password": password,
      },
    );

    final auth = AuthResponse.fromJson(response);
    await _saveAuth(auth);

    return auth;
  }

  Future<void> register(String username, String password) async {
    await apiClient.post(
      "/auth/register",
      {
        "username": username,
        "password": password,
      },
    );
  }

  Future<void> _saveAuth(AuthResponse auth) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "token",
      auth.token,
    );

    await prefs.setString(
      "username",
      auth.username,
    );

    await prefs.setBool(
      "admin",
      auth.admin,
    );

  }

  Future<bool> isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("token");
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<SharedPreferences> getPreferences() async {
    return await SharedPreferences.getInstance();
  }
}