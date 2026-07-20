import 'package:flutter/material.dart';

import '/models/match/competition_matches.dart';
import '/services/football_match_service.dart';
import '/services/service_locator.dart';
import '/widgets/match/competition_matches_tile.dart';
import '/widgets/match/match_timeline.dart';

class MatchesScreen extends StatefulWidget {

  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();

}

class _MatchesScreenState extends State<MatchesScreen> {

  final FootballMatchService matchService = locator<FootballMatchService>();
  DateTime selectedDate = DateTime.now();
  List<CompetitionMatches> competitions = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadMatches();
  }

  Future<void> loadMatches() async {
    setState(() {
      loading = true;
    });

    try {

      final result = await matchService.getMatchesByDate(selectedDate);

      setState(() {
        competitions = result;
      });

    } catch(e) {

      debugPrint(e.toString());

    } finally {

      setState(() {
        loading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [

            Icon(Icons.sports_soccer,),

            SizedBox(width:10),

            Text(
              "Partite",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [

            // TIMELINE DATA
            Padding(
              padding: const EdgeInsets.all(16),
              child: MatchTimeline(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                  loadMatches();
                },
              ),
            ),

            Expanded(
              child: loading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          CircularProgressIndicator(),

                          SizedBox(height: 16,),

                          Text(
                            "Caricamento partite...",
                            style: TextStyle(
                              color: Colors.grey,
                            )
                          )

                        ],
                      ),
                    )
                  : competitions.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Icon(
                                Icons.event_busy,
                                size: 60,
                                color: Colors.grey
                              ),

                              SizedBox(height: 15,),

                              Text(
                                "Nessuna partita in programma",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              SizedBox(height: 5,),

                              Text(
                                "Prova a cambiare data",
                                style: TextStyle(
                                  color: Colors.grey
                                ),
                              )

                            ],
                          )
                        )
                        : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 20
                            ),
                            itemCount: competitions.length,
                            itemBuilder: (context,index){
                              final competition = competitions[index];
                              return CompetitionMatchesTile(
                                competition: competition,
                              );
                            },
                          ),
                        ),
            )

          ],
        ),
      )
    );
  }

}