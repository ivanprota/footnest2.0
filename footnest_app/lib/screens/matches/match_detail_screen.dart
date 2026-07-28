import 'package:flutter/material.dart';

import '/models/match/match_detail.dart';
import '/services/football_match_service.dart';
import '/services/service_locator.dart';

import '/widgets/match/detail/match_header.dart';
import '/widgets/match/detail/match_score_card.dart';
import '/widgets/match/detail/match_info_card.dart';
import '/widgets/match/detail/match_statistics_section.dart';

class MatchDetailScreen extends StatefulWidget {

  final int matchId;

  const MatchDetailScreen({
    super.key,
    required this.matchId,
  });

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();

}


class _MatchDetailScreenState extends State<MatchDetailScreen> {

  final FootballMatchService matchService = locator();
  MatchDetail? match;

  bool loading = true;
  bool editing = false;

  bool saving = false;
  bool savingStatistics = false;

  String? selectedStatus;

  final TextEditingController homeGoalsController = TextEditingController();
  final TextEditingController awayGoalsController = TextEditingController();

  final GlobalKey<MatchStatisticsSectionState> statisticsKey =
      GlobalKey<MatchStatisticsSectionState>();

  @override
  void initState() {
    super.initState();
    loadMatch();
  }

  Future loadMatch() async {
    try {
      final result = await matchService.getMatchDetail(widget.matchId);

      if(!mounted) return;

      setState(() {
        match = result;
        selectedStatus = result.status;
      });

      homeGoalsController.text =
          result.homeGoals == -1
              ? ""
              : result.homeGoals.toString();

      awayGoalsController.text =
          result.awayGoals == -1
              ? ""
              : result.awayGoals.toString();

    }
    catch(e) {
      debugPrint(e.toString());
    }
    finally {
      if(mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future saveMatch() async {
    if(saving) return;

    setState(() {
      saving = true;
    });

    try {
      await matchService.updateMatch(
        match!.id,
        {

          "date":
              "${match!.date.year}-"
              "${match!.date.month.toString().padLeft(2,'0')}-"
              "${match!.date.day.toString().padLeft(2,'0')}",

          "kickoffTime":
              match!.kickoffTime,

          "homeGoals":
              homeGoalsController.text.isEmpty
                  ? -1
                  : int.parse(
                      homeGoalsController.text,
                    ),

          "awayGoals":
              awayGoalsController.text.isEmpty
                  ? -1
                  : int.parse(
                      awayGoalsController.text,
                    ),

          "status":
              selectedStatus ?? match!.status,

        },
      );

      setState(() {
        editing = false;
      });

      await loadMatch();

      if(mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                behavior:
                    SnackBarBehavior.floating,
                content:
                    Text(
                      "Partita aggiornata",
                    ),
              ),
            );
      }
    }
    catch(e) {
      debugPrint(e.toString());
    }
    finally {
      if(mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  Future saveAll() async {
    await saveMatch();
    await statisticsKey.currentState
        ?.saveAllStatistics();
  }

  Future saveStatistics(int id, Map<String,dynamic> body) async {

    if(savingStatistics) return;

    setState(() {
      savingStatistics = true;
    });

    try{
      if(id == -1) {
        await matchService.createStatistics(body);
      }
      else {
        await matchService.updateStatistics(id, body);
      }

      await loadMatch();

      if(mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content:
                    Text("Statistiche salvate"),
              ),
            );
      }
    }
    catch(e) {
      debugPrint(e.toString());
    }
    finally {
      if(mounted) {
        setState(() {
          savingStatistics = false;
        });
      }
    }
  }

  Future toggleEditing() async {
    if(editing) {
      await loadMatch();
    }

    setState(() {
      editing = !editing;
    });
  }

  @override
  void dispose() {
    homeGoalsController.dispose();
    awayGoalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop,result) {
        if(!didPop) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation:0,
          title: const Text("Dettaglio partita"),
          actions:[

            IconButton(
              icon: Icon(
                editing
                ? Icons.close
                : Icons.edit,
              ),
              onPressed: toggleEditing,
            )

          ],

        ),

        floatingActionButton:
            !editing
            ?
            FloatingActionButton.extended(
              onPressed: toggleEditing,
              icon: const Icon(Icons.edit),
              label: const Text("Modifica"),
            )
            : null,
        body: loading
          ?
          const Center(
            child:
                CircularProgressIndicator(),
          )
          :
          match == null
            ?
            const Center(
              child:
                  Text(
                    "Errore caricamento partita",
                  ),
            )
            :
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:[
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 90, 16, 30),
            child: Column(
              children:[

                MatchHeader(match:match!),

                const SizedBox(height:25),

                MatchScoreCard(
                  match:match!,
                  editing:editing,
                  homeGoalsController: homeGoalsController,
                  awayGoalsController: awayGoalsController,
                ),

                const SizedBox(height:25),

                MatchInfoCard(
                  match:match!,
                  editing:editing,
                  selectedStatus: selectedStatus,
                  onPickDate: pickDate,
                  onPickTime: pickTime,
                  onStatusChanged: (value) {
                    setState((){
                      selectedStatus = value;
                    });
                  },
                ),

                const SizedBox(height:30),

                MatchStatisticsSection(
                  key: statisticsKey,
                  match:match!,
                  editing:editing,
                  onSave: saveStatistics,
                ),

              ],

             ),
            ),
        ),
        bottomNavigationBar:
          editing
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0,-5),
                  ),
                ],
              ),

              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon:
                    saving
                    ?
                    const SizedBox(
                      width:22,
                      height:22,
                      child: CircularProgressIndicator(
                        strokeWidth:2.5,
                        color:Colors.white,
                      ),
                    )
                    :
                    const Icon(
                      Icons.save_rounded, 
                      size:26
                    ),
                  label:
                    Text(
                      saving
                      ? "Salvataggio..."
                      : "Salva modifiche",
                      style: const TextStyle(
                        fontSize:17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  onPressed: saving ? null : saveAll,
                ),
              ),
            )
          : null,
      ),
    );
  }

  Future pickDate() async {
    final result = await showDatePicker(
      context:context,
      initialDate: match!.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if(result != null) {
      setState(() {
        match = match!.copyWith(date:result);
      });
    }
  }

  Future pickTime() async {
    final result = await showTimePicker(
      context:context,
      initialTime: match!.kickoffTime != null
        ?
        TimeOfDay(
          hour: int.parse(match!.kickoffTime!.split(":")[0]),
          minute: int.parse(match!.kickoffTime!.split(":")[1]),
        )
        :
          TimeOfDay.now(),
        );

    if(result != null) {
      setState((){
        match = match!.copyWith(
          kickoffTime:
          "${result.hour.toString().padLeft(2,'0')}:"
          "${result.minute.toString().padLeft(2,'0')}",
        );
      });
    }
  }

}