import 'package:flutter/material.dart';

import '/services/service_locator.dart';
import '/services/profile_service.dart';

import '/models/bet/bet.dart';

import '/widgets/profile/bet_preview_tile.dart';
import '/widgets/profile/status_filter_bar.dart';

class UserBetsScreen extends StatefulWidget {

  final int userId;

  const UserBetsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserBetsScreen> createState() =>
      _UserBetsScreenState();
}

class _UserBetsScreenState
    extends State<UserBetsScreen> {

  List<Bet> bets = [];

  bool loading = true;

  int currentPage = 0;
  int totalPages = 0;

  String filter = "ALL";

  @override
  void initState() {
    super.initState();
    loadBets();
  }

  Future<void> loadBets() async {

    setState(() {
      loading = true;
    });

    try {

      final service =
          locator<ProfileService>();

      final response =
          await service.getUserBets(
            widget.userId,
            page: currentPage,
            size: 10,
          );

      if (!mounted) return;

      setState(() {
        bets = response.content.cast<Bet>();
        totalPages = response.totalPages;
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
            "Errore nel caricamento delle schedine: $e",
          ),
        ),
      );
    }
  }

  void nextPage() {

    if (currentPage < totalPages - 1) {
      currentPage++;
      loadBets();
    }
  }

  void previousPage() {

    if (currentPage > 0) {
      currentPage--;
      loadBets();
    }
  }

  List<Bet> get filteredBets {

    if (filter == "OPEN") {
      return bets
          .where((bet) => bet.status == "OPEN")
          .toList();
    }

    if (filter == "WON") {
      return bets
          .where((bet) => bet.status == "WON")
          .toList();
    }

    if (filter == "LOST") {
      return bets
          .where((bet) => bet.status == "LOST")
          .toList();
    }

    return bets;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Schedine",
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
                          filteredBets.length,

                      itemBuilder: (_, index) {

                        return BetPreviewTile(
                          bet: filteredBets[index],
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