import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/services/service_locator.dart';
import '/services/auth_service.dart';
import '/routes/routes.dart';

class AuthGate extends StatefulWidget {

  const AuthGate({
    super.key,
  });

  @override
  State<AuthGate> createState() =>
      _AuthGateState();

}

class _AuthGateState extends State<AuthGate> {

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final logged = await locator<AuthService>().isLogged();

    if(!mounted) return;

    if(logged) {
      context.go(AppRoutes.teams);
    }
    else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}