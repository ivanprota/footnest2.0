import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/services/service_locator.dart';
import '/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() =>
  _RegisterScreenState();

}


class _RegisterScreenState extends State<RegisterScreen> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String? message;

  Future<void> register() async {
    try {
      await locator<AuthService>().register(usernameController.text, passwordController.text);
      setState(() {
        message =
        "Registrazione completata. Attendi approvazione.";
      });
    }
    catch(e) {
      setState(() {
        message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: SizedBox(
          width:400,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[

                  Text(
                    "Registrazione",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height:20),

                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText:"Username",
                    ),
                  ),

                  const SizedBox(height:12),

                  TextField(
                    controller: passwordController,
                    obscureText:true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                  ),

                  const SizedBox(height:20),

                  ElevatedButton(
                    onPressed:register,
                    child: const Text("Registrati"),
                  ),

                  if(message != null)
                    Text(message!),

                  TextButton(
                    onPressed:() {
                      context.go('/login');
                    },
                    child: const Text("Torna al login"),
                  )

                ]

              ),
            ),
          ),
        ),
      ),
    );

  }

}