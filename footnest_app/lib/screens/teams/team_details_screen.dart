import 'package:flutter/material.dart';

import '/services/team_details_service.dart';
import '/services/service_locator.dart';

import '/widgets/team_details/matches_section.dart';
import '/widgets/team_details/standing_card.dart';
import '/widgets/team_details/team_header_card.dart';

class TeamDetailsScreen extends StatefulWidget {

  final int teamId;

  const TeamDetailsScreen({
    super.key,
    required this.teamId,
  });

  @override
  State<TeamDetailsScreen> createState() =>
      _TeamDetailsScreenState();

}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {

  late Future teamFuture;

  final teamDetailsService = locator<TeamDetailsService>();

  @override
  void initState() {
    super.initState();
    teamFuture = teamDetailsService.getTeamDetails(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Team Details",
        ),
      ),
      body: FutureBuilder(
        future: teamFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasError) {
            return const Center(
              child: Text(
                "Errore caricamento squadra",
              ),
            );
          }

          final team = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TeamHeaderCard(team: team),

                const SizedBox(height: 24),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      flex: 1,
                      child: team.standing != null
                          ? StandingCard(standing: team.standing!)
                          : const Card(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text("Classifica non disponibile"),
                              ),
                            ),
                    ),

                    const SizedBox(width: 24),

                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [

                          SizedBox(
                            height: 320,
                            child: MatchesSection(
                              title: "Ultime partite",
                              matches: team.lastMatches,
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            height: 320,
                            child: MatchesSection(
                              title: "Prossime partite",
                              matches: team.nextMatches,
                            ),
                          ),

                        ],

                      ),
                    ),

                  ],

                ),

              ],

            ),
          );
        },
      ),
    );
  }

}