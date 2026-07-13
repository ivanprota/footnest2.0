import 'package:flutter/material.dart';
import 'package:footnest_app/models/competitionseason/competition_season.dart';
import 'package:go_router/go_router.dart';

import '/models/competition/competition.dart';
import '/services/service_locator.dart';
import '/services/competition_service.dart';
import '/widgets/competition/competition_header.dart';
import '/widgets/competition/season_selector.dart';
import '/widgets/competition/standings_section.dart';
import '/routes/routes.dart';

class CompetitionDetailsScreen extends StatefulWidget {

  final int competitionId;

  const CompetitionDetailsScreen({
    super.key,
    required this.competitionId,
  });

  @override
  State<CompetitionDetailsScreen> createState() =>
      _CompetitionDetailsScreenState();

}

class _CompetitionDetailsScreenState extends State<CompetitionDetailsScreen> {

  final CompetitionService competitionService = locator();
  late Future<Competition> competitionFuture;
  CompetitionSeason? selectedSeason;

  @override
  void initState() {
    super.initState();
    competitionFuture = competitionService.getCompetitionById(widget.competitionId);
  }

  void setDefaultSeason(Competition competition) {
    if (selectedSeason == null && competition.seasons.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedSeason = competition.seasons.first;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Competizione"),
      ),
      body: FutureBuilder<Competition>(
        future: competitionFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError) {
            return Center(
              child: Text(
                "Errore caricamento competizione: ${snapshot.error}",
              ),
            );
          }

          final competition = snapshot.data;

          if(competition == null) {
            return const Center(
              child: Text("Competizione non trovata"),
            );
          }

          setDefaultSeason(competition);

          if(selectedSeason == null && competition.seasons.isNotEmpty) {
            selectedSeason = competition.seasons.first;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              CompetitionHeader(competition: competition),

              const SizedBox(height: 30),

              SeasonSelector(
                seasons: competition.seasons,
                selectedSeason: selectedSeason,
                onChanged: (season) {
                  setState(() {
                    selectedSeason = season;
                  });
                },
              ),

              const SizedBox(height: 30),

              StandingsSection(
                competitionSeasonId: selectedSeason?.id,
                onTeamTap: (teamdId) {
                  context.push('${AppRoutes.teams}/$teamdId');
                },
              ),

              const SizedBox(height: 30)

            ],
          );
        }
      ),
    );
  }
}