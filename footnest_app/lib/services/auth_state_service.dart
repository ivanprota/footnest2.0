
import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthStateService extends ChangeNotifier {

  final AuthService authService;

  AuthStateService({
    required this.authService,
  }) {
    loadUser();
  }

  String? username;
  bool admin = false;
  bool logged = false;

  Future loadUser() async {

    logged = await authService.isLogged();

    if (logged) {

      username = await authService.getUsername();

      final prefs =
          await authService.getPreferences();

      admin =
          prefs.getBool("admin") ?? false;

    }

    notifyListeners();
  }

  Future loginSuccess() async {
    await loadUser();
  }

  Future logout() async {

    await authService.logout();

    username = null;
    admin = false;
    logged = false;

    notifyListeners();
  }

}
