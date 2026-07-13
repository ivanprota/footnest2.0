import 'package:flutter/material.dart';

import '/models/standing/standing.dart';
import '/services/standing_service.dart';
import '/services/service_locator.dart';
import '/widgets/competition/standing_row.dart';

class StandingsSection extends StatefulWidget {

  final int? competitionSeasonId;
  final Function(int teamId)? onTeamTap;

  const StandingsSection({
    super.key,
    required this.competitionSeasonId,
    this.onTeamTap,
  });

  @override
  State<StandingsSection> createState() => _StandingSectionState();
}

class _StandingSectionState extends State<StandingsSection> {

  late Future<List<Standing>> standingsFutute;
  final StandingService standingService = locator();

  @override
  void initState() {
    super.initState();
    _loadStandings();
  }

  void _loadStandings() {
    if(widget.competitionSeasonId == null) {
      standingsFutute = Future.value([]);
      return;
    }

    standingsFutute = standingService.getStandings(widget.competitionSeasonId!);
  }

  @override
  void didUpdateWidget(covariant StandingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.competitionSeasonId
        != widget.competitionSeasonId){
      _loadStandings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Divider(),

        const SizedBox(height: 20),

        const Text(
          "Classifica",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        FutureBuilder<List<Standing>>(
          future: standingsFutute,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text("Errore caricamento classifica: ${snapshot.error}");
            }

            final standings = snapshot.data ?? [];

            if (standings.isEmpty) {
              return const Text("Nessuna classifica disponibile");
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [

                    // intestazione
                    Row(
                      children: const [

                        SizedBox(
                          width: 30,
                          child: Text(
                            "#",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            "Squadra",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 35,
                          child: Text(
                            "PG",
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(
                          width: 35,
                          child: Text(
                            "V",
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(
                          width: 35,
                          child: Text(
                            "N",
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(
                          width: 35,
                          child: Text(
                            "P",
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(
                          width: 40,
                          child: Text(
                            "GF",
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(
                          width: 40,
                          child: Text(
                            "GS",
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(
                          width: 40,
                          child: Text(
                            "Pt",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),


                    const Divider(),


                    ...standings.map((standing){
                      return StandingRow(
                        standing: standing,
                        onTap: () {
                          widget.onTeamTap?.call(standing.team.id);
                        },
                      );
                    })

                    ],
                  ),
                ),
            );

          },

        )
      ],
    );

  }

}