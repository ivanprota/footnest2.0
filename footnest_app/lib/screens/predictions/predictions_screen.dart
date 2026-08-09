import 'package:flutter/material.dart';
import 'package:footnest_app/services/profile_refresh_service.dart';

import '/services/service_locator.dart';
import '/services/football_match_service.dart';
import '/services/prediction_service.dart';
import '/services/bet_service.dart';

import '/models/match/competition_matches.dart';
import '/models/prediction/prediction.dart';

import '/widgets/match/match_timeline.dart';
import '/widgets/prediction/prediction_competition_tile.dart';

import '/screens/bets/bet_slip_screen.dart';

class PredictionsScreen extends StatefulWidget {

  const PredictionsScreen({
    super.key,
  });

  @override
  State<PredictionsScreen> createState() =>
      _PredictionsScreenState();

}

class _PredictionsScreenState extends State<PredictionsScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; 

  final footballMatchService =
      locator<FootballMatchService>();

  final predictionService =
      locator<PredictionService>();

  final betService =
      locator<BetService>();

  List<CompetitionMatches> competitions = [];

  List<Prediction> predictions = [];

  DateTime selectedDate = DateTime.now();

  List<Prediction> betSlip = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List<Prediction> getMatchPredictions(int matchId){
    return predictions
        .where(
          (p) =>
            p.matchId == matchId,
        )
        .toList();
  }

  Future<void> loadData() async {
    final matches =
        await footballMatchService
            .getMatchesByDate(
              selectedDate,
            );

    final myPredictions = await predictionService.getMyPredictions();

    setState(() {
      competitions = matches;
      predictions = myPredictions;
    });

  }

  Future deletePrediction(int id) async {

    try {

      await predictionService.delete(id);

      locator<ProfileRefreshService>().refresh();

      setState(() {
        betSlip.removeWhere(
          (p) => p.id == id,
        );
      });

      await loadData();

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Non puoi eliminare questo pronostico perché è presente in una schedina.",
          ),
        ),
      );

    }

  }

  Future createPrediction(Map<String,dynamic> body) async {
    await predictionService.create(body);
    locator<ProfileRefreshService>().refresh();
    await loadData();
  }

  void addToBetSlip(Prediction prediction) {

    final alreadyExists = betSlip.any(
      (p) => p.matchId == prediction.matchId,
    );

    if (alreadyExists) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Hai già aggiunto un pronostico per questa partita.",
          ),
        ),
      );

      return;
    }

    setState(() {
      betSlip.add(prediction);
    });

  }

  void openBetSlip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
          BetSlipScreen(
            selections: betSlip,
            onRemove: removeFromBetSlip,
            onSave: saveBet,
          ),
        ),
    );
  }

  void removeFromBetSlip(Prediction prediction) {
    setState((){
      betSlip.removeWhere(
        (p)=>p.id == prediction.id,
      );
    });
  }

  Future saveBet(String name, List selections) async {

    await betService.create({

      "name":
          name.trim().isEmpty
          ? "Schedina"
          : name.trim(),

      "selections":
          selections.map((prediction){

            return {

              "predictionId":
                  prediction.id,

            };

          }).toList(),

    });

    locator<ProfileRefreshService>().refresh();

    setState(() {
      betSlip.clear();
    });

  }

  Widget _buildBetSlipBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal:20,
        vertical:12,
      ),
      decoration: BoxDecoration(
        color:Theme.of(context).colorScheme.onPrimary,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      child: Row(
        children:[

          const Icon(Icons.receipt_long),

          const SizedBox(width:12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:[

                const Text(
                  "Schedina corrente",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "${betSlip.length} pronostici inseriti",
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),

              ],

            ),
          ),

          TextButton(
            style: ButtonStyle(
              mouseCursor: WidgetStateProperty.all(
                SystemMouseCursors.click,
              ),

              overlayColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.18);
                  }

                  if (states.contains(WidgetState.pressed)) {
                    return Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.30);
                  }

                  return null;
                },
              ),

              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            onPressed: openBetSlip,

            child: const Text(
              "Vedi",
            ),
          ),

          IconButton(
            icon: const Icon(Icons.delete_outline),
            style: ButtonStyle(
              mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click)
            ),
            onPressed: () {
              setState((){
                betSlip.clear();
              });
            },
          ),

        ],

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [

            Icon(
              Icons.tips_and_updates,
            ),

            SizedBox(width:10),

            Text(
              "Pronostici",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: MatchTimeline(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });

                loadData();
              },
            ),
          ),


          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16
              ),
              itemCount: competitions.length,
              itemBuilder: (context,index) {
                final competition =
                    competitions[index];

                return PredictionCompetitionTile(
                  competition: competition,
                  predictions:
                      predictions.cast<Prediction>(),
                  onDeletePrediction: deletePrediction,
                  onCreatePrediction: createPrediction,
                  onAddToBetSlip: addToBetSlip,
                  isInBetSlip: (prediction) {
                    return betSlip.any((p) => p.id == prediction.matchId,);
                  },
                );

              },

            ),
          ),

        ],
      ),
      bottomNavigationBar: betSlip.isEmpty
        ? null
        : _buildBetSlipBar(),

    );

  }

}