import 'package:flutter/material.dart';

import '/models/match/competition_matches.dart';
import '/models/prediction/prediction.dart';

import 'prediction_match_card.dart';

class PredictionCompetitionTile extends StatefulWidget {

  final CompetitionMatches competition;
  final List<Prediction> predictions;
  final Future Function(int predictionId) onDeletePrediction;
  final Future Function(Map<String,dynamic>) onCreatePrediction;
  final Function(Prediction prediction) onAddToBetSlip;
  final bool Function(Prediction prediction) isInBetSlip;

  const PredictionCompetitionTile({
    super.key,
    required this.competition,
    required this.predictions,
    required this.onDeletePrediction,
    required this.onCreatePrediction,
    required this.onAddToBetSlip,
    required this.isInBetSlip
  });

  @override
  State createState() => _PredictionCompetitionTileState();

}

class _PredictionCompetitionTileState extends State<PredictionCompetitionTile> {

  bool expanded = true;

  List getMatchPredictions(int matchId) {
    return widget.predictions
      .where(
        (p)=>p.matchId == matchId,
      )
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom:12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children:[

          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap:() {
              setState((){
                expanded = !expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children:[

                  Image.network(
                    widget.competition.competitionLogo,
                    width:35,
                    height:35,
                    errorBuilder: (_,__,___)=>
                      const Icon(Icons.emoji_events),
                  ),

                  const SizedBox(width:12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[

                        Text(
                          widget.competition.competitionName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "${widget.competition.matches.length} partite",
                          style: TextStyle(
                            fontSize:12,
                            color: Colors.grey[500],
                          ),
                        ),

                      ],

                    ),

                  ),

                  Icon(
                    expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  )
                ],

              ),

            ),

          ),

          if(expanded)
            Column(
              children:
                widget.competition.matches
                  .map((match) {
                    return PredictionMatchCard(
                      match:match,
                      predictions:
                        getMatchPredictions(match.id)
                          .cast<Prediction>(),
                      onDeletePrediction: widget.onDeletePrediction,
                      onCreatePrediction: widget.onCreatePrediction,
                      onAddToBetSlip: widget.onAddToBetSlip,
                      isInBetSlip: widget.isInBetSlip,
                    );

                  }).toList(),
              ),

        ],

      ),
    );
  }

}