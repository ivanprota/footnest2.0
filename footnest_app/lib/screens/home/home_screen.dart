import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/widgets/app_sidebar.dart';
import '../teams/teams_screen.dart';
import '../matches/matches_screen.dart';
import '../competitions/competitions_screen.dart';
import '../predictions/predictions_screen.dart';
import '/services/service_locator.dart';
import '/services/auth_service.dart';
import '/routes/routes.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  int selectedIndex = 0;

  final screens = const [
    TeamsScreen(),
    MatchesScreen(),
    CompetitionsScreen(),
    PredictionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            onAccountPressed: () async {
              final logged =
                  await locator<AuthService>()
                      .isLogged();

              if(context.mounted) {
                if(logged) {
                  context.go(AppRoutes.profile);
                } 
                else {
                  context.go(AppRoutes.login);
                }
              }
            },
          ),

          const VerticalDivider(width: 1,),

          Expanded(child: screens[selectedIndex],),
        ],
      ),
    );
  }
}