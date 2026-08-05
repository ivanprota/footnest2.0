import 'package:flutter/material.dart';

import '/models/prediction/prediction.dart';
import '/config/api_config.dart';

class BetSlipScreen extends StatefulWidget {

  final List<Prediction> selections;
  final Function(Prediction) onRemove;
  final Future Function(String name, List<Prediction> selections) onSave;

  const BetSlipScreen({
    super.key,
    required this.selections,
    required this.onRemove,
    required this.onSave,
  });

  @override
  State createState() => _BetSlipScreenState();
}


class _BetSlipScreenState extends State<BetSlipScreen> {


  final TextEditingController nameController =
      TextEditingController();


  String generateDefaultName() {
    final now = DateTime.now();

    return
      "Schedina "
      "${now.day.toString().padLeft(2,'0')}/"
      "${now.month.toString().padLeft(2,'0')}/"
      "${now.year} "
      "${now.hour.toString().padLeft(2,'0')}:"
      "${now.minute.toString().padLeft(2,'0')}";
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  String logoUrl(String path) {
    if(path.startsWith("http")) {
    return path;
    }

    return "${ApiConfig.baseUrl}/uploads/$path";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedina corrente"),
      ),
      body: Column(
        children:[

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nome schedina",
                hintText: "Lascia vuoto per nome automatico",
              ),
            ),
          ),

          Expanded(
            child:      
              widget.selections.isEmpty
              ?
              const Center(
                child: Text("Nessun pronostico inserito"),
              )
              :
              ListView.builder(
                itemCount: widget.selections.length,
                itemBuilder: (context,index) {
                  final prediction = widget.selections[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal:16,
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
                                        prediction.homeTeam,
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width:8),

                                    Image.network(
                                      "${ApiConfig.baseUrl}/uploads/${prediction.homeLogo}",
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


                              const SizedBox(width:20),


                              const Text(
                                "VS",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),


                              const SizedBox(width:20),


                              Expanded(
                                child: Row(
                                  children: [

                                    Image.network(
                                      "${ApiConfig.baseUrl}/uploads/${prediction.awayLogo}",
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
                                        prediction.awayTeam,
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


                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical:8,
                              horizontal:12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  prediction.prediction,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(width:10),

                                Text(
                                  "@${prediction.odd}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),

                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  );
                },
              ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.selections.isEmpty
                  ? null
                  : () async {
                        String name = nameController.text.trim();
                        if(name.isEmpty) {
                          name = generateDefaultName();
                        }

                        await widget.onSave(name, widget.selections);
                        if(context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                  child: const Text("Salva schedina"),
              ),
            ),
          ),

        ],
      ),
    );
  }
}