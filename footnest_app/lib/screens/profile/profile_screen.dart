import 'package:flutter/material.dart';
import 'package:footnest_app/services/auth_state_service.dart';
import 'package:go_router/go_router.dart';

import '/services/service_locator.dart';
import '/routes/routes.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
  _ProfileScreenState();

}


class _ProfileScreenState extends State<ProfileScreen> {


  String? username;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final auth = await locator<AuthStateService>();
    setState(() {
      username = auth.username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(
              AppRoutes.home,
            );
          },
        ),
        title: const Text("Profilo"),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[

                const Icon(
                  Icons.account_circle,
                  size:80,
                ),

                Text(
                  username ?? "",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height:20),

                ElevatedButton(
                  onPressed:() async {
                    await locator<AuthStateService>().logout();

                    if(context.mounted) {
                      context.go(
                        AppRoutes.login,
                      );
                    }
                  },
                  child: const Text("Logout"),
                )

              ]

            ),
          ),
        ),
      ),
    );

  }

}