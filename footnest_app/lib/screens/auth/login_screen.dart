import 'package:flutter/material.dart';
import 'package:footnest_app/routes/routes.dart';
import 'package:footnest_app/services/auth_state_service.dart';
import 'package:go_router/go_router.dart';

import '/services/service_locator.dart';
import '/services/auth_service.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  String? error;

  Future<void> login() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {

      await locator<AuthService>()
          .login(
            usernameController.text,
            passwordController.text,
          );

      await locator<AuthStateService>().loginSuccess();

      if(mounted) {
        context.go(AppRoutes.home);
      }

    } 
    catch(e) {
      setState(() {
        error = e.toString();
      });
    } 
    finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                  ),

                  const SizedBox(height: 20),

                  if(error != null)
                    Text(
                      error!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : login,
                      child: loading
                        ? const CircularProgressIndicator()
                        : const Text("Accedi"),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: const Text("Non hai un account? Registrati"),
                  )

                ],

              ),

            ),
          ),
        ),
      ),
    );

  }

}