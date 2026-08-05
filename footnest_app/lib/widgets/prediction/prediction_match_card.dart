import 'package:flutter/material.dart';

import '/models/match/match_summary.dart';
import '/models/prediction/prediction.dart';

import '/config/api_config.dart';

class PredictionMatchCard extends StatefulWidget {

  final MatchSummary match;
  final List<Prediction> predictions;
  final Future Function(int predictionId) onDeletePrediction;
  final Future Function(Map<String,dynamic>) onCreatePrediction;
  final Function(Prediction prediction) onAddToBetSlip;
  final bool Function(Prediction prediction) isInBetSlip;

  const PredictionMatchCard({
    super.key,
    required this.match,
    required this.predictions,
    required this.onDeletePrediction,
    required this.onCreatePrediction,
    required this.onAddToBetSlip,
    required this.isInBetSlip
  });

  @override
  State createState() => _PredictionMatchCardState();
}

class _PredictionMatchCardState extends State<PredictionMatchCard> {

  final TextEditingController predictionController =
      TextEditingController();

  final TextEditingController oddController =
      TextEditingController();

  bool adding = false;

  Future savePrediction() async {
    if(predictionController.text.isEmpty || oddController.text.isEmpty) {
      return;
    }

    await widget.onCreatePrediction(
    {
      "matchId": widget.match.id,

      "prediction":
          predictionController.text,

      "odd":
          double.parse(
            oddController.text,
          ),
    });

    predictionController.clear();
    oddController.clear();

    setState(() {
      adding = false;
    });
  }

  @override
  void dispose() {
    predictionController.dispose();
    oddController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal:12,
        vertical:6,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            Row(
              children: [

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Flexible(
                        child: Text(
                          widget.match.homeTeam,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width:8),

                      Image.network(
                        "${ApiConfig.baseUrl}/uploads/${widget.match.homeLogo}",
                        width:32,
                        height:32,
                        errorBuilder: (_,__,___)=>
                            const Icon(
                              Icons.shield,
                              size:32,
                            ),
                      ),

                    ],
                  ),
                ),


                const SizedBox(width:15),


                Text(
                  widget.match.kickoffText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),


                const SizedBox(width:15),


                Expanded(
                  child: Row(
                    children: [

                      Image.network(
                        "${ApiConfig.baseUrl}/uploads/${widget.match.awayLogo}",
                        width:32,
                        height:32,
                        errorBuilder: (_,__,___)=>
                            const Icon(
                              Icons.shield,
                              size:32,
                            ),
                      ),

                      const SizedBox(width:8),

                      Flexible(
                        child: Text(
                          widget.match.awayTeam,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height:12),

            if(widget.predictions.isNotEmpty)
              Column(
                children: [

                  const Divider(),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "I tuoi pronostici",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize:13,
                      ),
                    ),
                  ),

                  ...widget.predictions.map(
                    (p) => ListTile(
                      contentPadding: EdgeInsets.zero,

                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),

                      title: Text(
                        p.prediction,
                      ),

                      subtitle: Text(
                        "Quota @${p.odd}",
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                      widget.isInBetSlip(p)
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.green,
                              ),
                              tooltip: "Aggiungi alla schedina",
                              onPressed: () {
                                widget.onAddToBetSlip(p);
                              },
                            ),


                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            tooltip: "Elimina pronostico",
                            onPressed: () async {

                              final confirm =
                                  await showDialog<bool>(
                                    context: context,
                                    builder: (context)=>AlertDialog(
                                      title: const Text(
                                        "Eliminare pronostico?",
                                      ),

                                      content: Text(
                                        "Vuoi eliminare ${p.prediction}?",
                                      ),

                                      actions:[

                                        TextButton(
                                          onPressed: (){
                                            Navigator.pop(
                                              context,
                                              false,
                                            );
                                          },
                                          child: const Text(
                                            "Annulla",
                                          ),
                                        ),


                                        ElevatedButton(
                                          onPressed: (){
                                            Navigator.pop(
                                              context,
                                              true,
                                            );
                                          },
                                          child: const Text(
                                            "Elimina",
                                          ),
                                        ),

                                      ],
                                    ),
                                  );


                              if(confirm == true){

                                await widget.onDeletePrediction(
                                  p.id,
                                );

                              }

                            },
                          ),

                        ],
                      ),

                    ),
                  )

                ],
              ),

              const SizedBox(height:8),

              if (widget.match.status != "PLAYED")
                if(!adding)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          adding=true;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        widget.predictions.isEmpty
                          ? "Inserisci pronostico"
                          : "Aggiungi pronostico",
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top:10),
                    child: Row(
                      children:[

                        Expanded(
                          child: TextField(
                            controller: predictionController,
                            decoration: const InputDecoration(
                              hintText: "Pronostico",
                            ),
                          ),
                        ),

                        const SizedBox(width:10),

                        SizedBox(
                          width:80,
                          child: TextField(
                            controller: oddController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "Quota",
                            ),

                          ),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.save,
                            color:Colors.green,
                          ),
                          onPressed: savePrediction,
                        ),

                      ],

                    ),
                  )

              ],

          ),

      ),

    );

  }

}