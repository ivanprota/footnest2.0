import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/services/service_locator.dart';
import '/services/profile_service.dart';

import '/models/prediction/prediction.dart';

import '/widgets/profile/prediction_preview_tile.dart';
import '/widgets/profile/status_filter_bar.dart';

class UserPredictionsScreen extends StatefulWidget {

  final int userId;

  const UserPredictionsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserPredictionsScreen> createState() =>
      _UserPredictionsScreenState();
}

class _UserPredictionsScreenState
    extends State<UserPredictionsScreen> {

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

  Future<void> loadPredictions() async {

    setState(() {
      loading = true;
    });

    try {

      final service =
          locator<ProfileService>();

      final response =
          await service.getUserPredictions(
            widget.userId,
            page: currentPage,
            size: 10,
          );

      if (!mounted) return;

      setState(() {
        predictions =
            response.content.cast<Prediction>();

        totalPages =
            response.totalPages;

        loading = false;
      });

    } catch (e) {

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Errore nel caricamento dei pronostici: $e",
          ),
        ),
      );
    }
  }

  void nextPage() {

    if (currentPage < totalPages - 1) {
      currentPage++;
      loadPredictions();
    }
  }

  void previousPage() {

    if (currentPage > 0) {
      currentPage--;
      loadPredictions();
    }
  }

  List<Prediction> get filteredPredictions {

    if (filter == "OPEN") {
      return predictions
          .where((p) => !p.settled)
          .toList();
    }

    if (filter == "WON") {
      return predictions
          .where(
            (p) => p.settled && p.won,
          )
          .toList();
    }

    if (filter == "LOST") {
      return predictions
          .where(
            (p) => p.settled && !p.won,
          )
          .toList();
    }

    return predictions;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Pronostici",
        ),
      ),

      body: loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : Padding(
              padding: const EdgeInsets.all(25),

              child: Column(
                children: [

                  StatusFilterBar(
                    selected: filter,
                    onChanged: (value) {
                      setState(() {
                        filter = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(

                      itemCount:
                          filteredPredictions.length,

                      itemBuilder: (_, index) {

                        return PredictionPreviewTile(
                          prediction: filteredPredictions[index],
                          readOnly: true,
                          onTap: () {
                            context.push("/matches/${filteredPredictions[index].matchId}");
                          },
                        );

                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      IconButton(
                        onPressed:
                            currentPage > 0
                                ? previousPage
                                : null,
                        icon: const Icon(
                          Icons.chevron_left,
                        ),
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
                        icon: const Icon(
                          Icons.chevron_right,
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
    );
  }
}