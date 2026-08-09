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

        if (e.toString().contains("403")) {
          error = "Account non ancora approvato. Attendi l'approvazione di un amministratore.";
        }
        else {
          error = e.toString();
        }
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
          width: 450,
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    "Login",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  if(error != null)
                    Text(
                      error!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        mouseCursor: WidgetStateProperty.all(
                          SystemMouseCursors.click,
                        ),
                      ),
                      onPressed: loading ? null : login,
                      child: loading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Accedi",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    style: ButtonStyle(
                      mouseCursor: WidgetStateProperty.all(
                        SystemMouseCursors.click,
                      ),
                    ),
                    onPressed: () {
                      context.go('/register');
                    },
                    child: const Text(
                      "Non hai un account? Registrati",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
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