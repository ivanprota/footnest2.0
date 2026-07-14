import 'package:flutter/material.dart';
import 'package:footnest_app/services/team_service.dart';
import 'package:go_router/go_router.dart';

import '/models/team/team.dart';
import '/services/service_locator.dart';
import '/widgets/team_card.dart';
import '/routes/routes.dart';

class TeamsScreen extends StatefulWidget {

  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();

}

class _TeamsScreenState extends State<TeamsScreen> {

  final TeamService teamService = locator();
  late Future<List<Team>> teamsFuture;

  @override
  void initState() {
    super.initState();
    teamsFuture = teamService.getTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Squadre",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Aggiungi squadra",
            onPressed: () async {
              await context.push(AppRoutes.addTeam);

              setState(() {
                teamsFuture = teamService.getTeams();
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<Team>>(
        future: teamsFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.redAccent,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Errore caricamento squadre",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final teams = snapshot.data ?? [];

          if(teams.isEmpty) {
            return const Center(
              child: Text(
                "Nessuna squadra presente",
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${teams.length} squadre",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (context,index) {
                      return TeamCard(
                        team: teams[index],
                        onTap: () {
                          context.push('${AppRoutes.teams}/${teams[index].id}');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}