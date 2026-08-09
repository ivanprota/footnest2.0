import 'package:flutter/material.dart';
import 'package:footnest_app/widgets/profile/status_filter_bar.dart';
import 'package:go_router/go_router.dart';

import '/services/service_locator.dart';
import '/services/profile_service.dart';

import '/models/prediction/prediction.dart';

import '/widgets/profile/prediction_preview_tile.dart';

class MyPredictionsScreen extends StatefulWidget {

  const MyPredictionsScreen({
    super.key,
  });

  @override
  State<MyPredictionsScreen> createState() => _MyPredictionsScreenState();

}


class _MyPredictionsScreenState extends State<MyPredictionsScreen> {

  List<Prediction> predictions = [];
  bool loading = true;
  int currentPage = 0;
  int totalPages = 0;

  String filter = "ALL";

  @override
  void initState() {
    super.initState();
    loadPredictions();
  }

  Future loadPredictions() async {
    setState(() {
      loading = true;
    });

    final service = locator<ProfileService>();
    final response = await service.getPredictions(page: currentPage, size: 10);

    setState(() {
      predictions = response.content;
      totalPages = response.totalPages;
      loading = false;
    });
  }

  void nextPage() {
    if(currentPage < totalPages - 1) {
      currentPage++;
      loadPredictions();
    }
  }

  void previousPage() {
    if(currentPage > 0) {
      currentPage--;
      loadPredictions();
    }
  }

  List<Prediction> get filteredPredictions {

    if(filter == "OPEN") {
    return predictions
        .where((p)=>!p.settled)
        .toList();
    }

    if(filter == "WON") {
    return predictions
        .where((p)=>p.settled && p.won)
        .toList();
    }

    if(filter == "LOST") {
    return predictions
        .where((p)=>p.settled && !p.won)
        .toList();
    }

    return predictions;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("I miei pronostici"),
      ),
      body: loading
          ?
          const Center(
            child: CircularProgressIndicator(),
          )
          :
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [

                StatusFilterBar(
                  selected: filter,
                  onChanged:(value) {
                    setState(() {
                      filter = value;
                      currentPage = 0;
                    });
                  },
                ),

                const SizedBox(height: 20,),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredPredictions.length,
                    itemBuilder: (_, index) {

                      return PredictionPreviewTile(
                        prediction: filteredPredictions[index],
                        onRefresh: loadPredictions,
                          onTap: () {
                            context.push("/matches/${filteredPredictions[index].matchId}");
                          },
                      );

                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    IconButton(
                      onPressed:
                          currentPage > 0
                          ? previousPage
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),

                    Text(
                      "${currentPage + 1}"
                      " / "
                      "$totalPages",
                    ),

                    IconButton(
                      onPressed:
                          currentPage <
                              totalPages - 1
                          ? nextPage
                          : null,
                      icon:const Icon(Icons.chevron_right),
                    ),

                  ],
                )

              ],
            ),
          ),
    );
  }

}