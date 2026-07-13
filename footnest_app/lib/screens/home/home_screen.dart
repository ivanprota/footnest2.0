import 'package:flutter/material.dart';

import '../../widgets/app_sidebar.dart';
import '../teams/teams_screen.dart';
import '../matches/matches_screen.dart';
import '../competitions/competitions_screen.dart';

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
          ),

          const VerticalDivider(width: 1,),

          Expanded(child: screens[selectedIndex],),
        ],
      ),
    );
  }
}