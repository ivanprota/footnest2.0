import 'package:flutter/material.dart';
import 'package:footnest_app/services/match_refresh_service.dart';

import '/models/match/match_detail.dart';
import '/services/football_match_service.dart';
import '/services/service_locator.dart';
import '/services/team_refresh_service.dart';

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

      locator<TeamRefreshService>().refresh();

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

  bool hasValidResult() {

    final home =
        homeGoalsController.text.trim();

    final away =
        awayGoalsController.text.trim();


    return home.isNotEmpty &&
          away.isNotEmpty &&
          int.tryParse(home) != null &&
          int.tryParse(away) != null;

  }

  Future saveAll() async {

    final homeGoals =
        homeGoalsController.text.trim();

    final awayGoals =
        awayGoalsController.text.trim();


    final hasHomeGoals =
        homeGoals.isNotEmpty;

    final hasAwayGoals =
        awayGoals.isNotEmpty;


    final hasStatistics =
        match!.statistics.length > 0 ||
        statisticsKey.currentState
            ?.hasInsertedStatistics() == true;


    // Controllo risultato incompleto
    if (hasHomeGoals != hasAwayGoals) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
            const SnackBar(
              content:
                  Text(
                    "Inserire entrambi i risultati della partita",
                  ),
            ),
          );

      return;
    }


    // Controllo statistiche senza risultato
    if (hasStatistics &&
        (!hasHomeGoals || !hasAwayGoals)) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
            const SnackBar(
              content:
                  Text(
                    "Per salvare le statistiche devi prima inserire il risultato",
                  ),
            ),
          );

      return;
    }


    await saveMatch();


    await statisticsKey.currentState
        ?.saveAllStatistics();


    await loadMatch();

    locator<TeamRefreshService>().refresh();
    locator<MatchRefreshService>().refresh();

    if(mounted){

      setState(() {
        editing = false;
      });


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

  Future saveStatistics(int id, Map<String,dynamic> body) async {

    try {

      if(id == -1) {

        await matchService.createStatistics(body);

      }
      else {

        await matchService.updateStatistics(
          id,
          body,
        );

      }

      await loadMatch();

    }
    catch(e) {

      debugPrint(e.toString());

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
              mouseCursor: SystemMouseCursors.click,
              tooltip: editing
                ? "Annulla modifiche"
                : "Modifica partita",
              icon: Icon(
                editing
                ? Icons.close
                : Icons.edit,
              ),
              onPressed: toggleEditing,
            )

          ],

        ),
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
                child: _HoverSaveButton(
                  saving: saving,
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

class _HoverSaveButton extends StatefulWidget {

  final bool saving;
  final VoidCallback? onPressed;

  const _HoverSaveButton({
    required this.saving,
    required this.onPressed,
  });

  @override
  State<_HoverSaveButton> createState() =>
      _HoverSaveButtonState();

}


class _HoverSaveButtonState extends State<_HoverSaveButton> {

  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        if(widget.onPressed != null) {
          setState(() {
            hovering = true;
          });
        }
      },
      onExit: (_) {
        setState(() {
          hovering = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds:180),
        transform: hovering
            ? Matrix4.translationValues(0, -3, 0)
            : Matrix4.identity(),
        child: ElevatedButton.icon(
          style: ButtonStyle(
            mouseCursor: WidgetStateProperty.all(
              SystemMouseCursors.click,
            ),
            backgroundColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.primary,
            ),
            foregroundColor: WidgetStateProperty.all(
              Colors.white,
            ),
            elevation: WidgetStateProperty.resolveWith(
              (states) {
                if(states.contains(WidgetState.hovered)) {
                  return 12;
                }
                return 6;
              },
            ),
            shadowColor: WidgetStateProperty.all(
              Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.5),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          icon:
              widget.saving
              ? const SizedBox(
                  width:22,
                  height:22,
                  child: CircularProgressIndicator(
                    strokeWidth:2.5,
                    color:Colors.white,
                  ),
                )
              : const Icon(
                  Icons.save_rounded,
                  size:26,
                ),
          label:
              Text(
                widget.saving
                ? "Salvataggio..."
                : "Salva modifiche",
                style:
                    const TextStyle(
                      fontSize:17,
                      fontWeight:
                          FontWeight.bold,
                    ),
              ),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}