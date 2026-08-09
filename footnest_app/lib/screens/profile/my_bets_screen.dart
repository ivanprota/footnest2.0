import 'package:flutter/material.dart';

import '/services/service_locator.dart';
import '/services/profile_service.dart';
import '/services/bet_service.dart';
import '/services/profile_refresh_service.dart';

import '/models/bet/bet.dart';

import '/widgets/profile/bet_preview_tile.dart';
import '/widgets/profile/status_filter_bar.dart';

class MyBetsScreen extends StatefulWidget {

  const MyBetsScreen({
    super.key,
  });

  @override
  State<MyBetsScreen> createState() => _MyBetsScreenState();

}


class _MyBetsScreenState extends State<MyBetsScreen> {

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

  Future loadBets() async {
    setState(() {
      loading = true;
    });

    final service = locator<ProfileService>();
    final response = await service.getBets(page: currentPage, size:10);

    setState(() {
      bets = response.content;
      totalPages = response.totalPages;
      loading = false;
    });
  }

  void nextPage() {
    if(currentPage < totalPages - 1) {
      currentPage++;
      loadBets();
    }
  }

  void previousPage() {
    if(currentPage > 0) {
      currentPage--;
      loadBets();
    }
  }

  List<Bet> get filteredBets {

    if(filter == "OPEN") {
      return bets
          .where((bet) => bet.status == "OPEN")
          .toList();
    }

    if(filter == "WON") {
      return bets
          .where((bet) => bet.status == "WON")
          .toList();
    }

    if(filter == "LOST") {
      return bets
          .where((bet) => bet.status == "LOST")
          .toList();
    }

    return bets;
  }

  Future deleteBet(int id) async {

    try {

      final service = locator<BetService>();

      await service.delete(id);

      // aggiorna il profilo
      locator<ProfileRefreshService>().refresh();

      setState(() {
        bets.removeWhere(
          (bet) => bet.id == id,
        );
      });

    } catch(e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Errore durante l'eliminazione della schedina",
          ),
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Le mie schedine"),
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
                      itemCount: filteredBets.length,
                      itemBuilder: (_,index) {

                        return BetPreviewTile(
                          bet: filteredBets[index],
                          onDelete: deleteBet
                        );
                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      IconButton(
                        onPressed: currentPage > 0 ? previousPage : null,
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
                        icon: const Icon(Icons.chevron_right),
                      ),

                    ],
                  )

              ],
            ),
          ),
    );
  }

}