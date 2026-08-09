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
        width: 450,
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[

                Text(
                  "Registrazione",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),

                const SizedBox(height:30),

                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText:"Username",
                    filled:true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal:15,
                      vertical:18,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height:18),

                TextField(
                  controller: passwordController,
                  obscureText:true,
                  decoration: const InputDecoration(
                    labelText:"Password",
                    filled:true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal:15,
                      vertical:18,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height:25),

                SizedBox(
                  width:double.infinity,
                  height:50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      mouseCursor: WidgetStateProperty.all(
                        SystemMouseCursors.click,
                      ),
                    ),
                    onPressed:register,
                    child: const Text(
                      "Registrati",
                      style: TextStyle(
                        fontSize:16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height:15),

                if(message != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom:10,
                    ),
                    child: Text(
                      message!,
                      textAlign: TextAlign.center,
                    ),
                  ),

                TextButton(
                  style: ButtonStyle(
                    mouseCursor: WidgetStateProperty.all(
                      SystemMouseCursors.click,
                    ),
                  ),
                  onPressed:() {
                    context.go('/login');
                  },
                  child: const Text(
                    "Torna al login",
                    style: TextStyle(
                      fontSize:15,
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