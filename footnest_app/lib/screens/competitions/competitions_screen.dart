import 'package:flutter/material.dart';
import 'package:footnest_app/widgets/competition/competition_card.dart';

import '/services/service_locator.dart';
import '/models/competition/competition.dart';
import '/services/competition_service.dart';
import 'package:go_router/go_router.dart';
import '/routes/routes.dart';

class CompetitionsScreen extends StatefulWidget {

  const CompetitionsScreen({super.key});

  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();

}

class _CompetitionsScreenState extends State<CompetitionsScreen> {

  final CompetitionService competitionService = locator<CompetitionService>();
  late Future<List<Competition>> competitionsFuture;

  @override
  void initState() {
    super.initState();
    competitionsFuture = competitionService.getCompetitions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Competition>>(
      future: competitionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Errore caricamento competizioni: ${snapshot.error}",
            ),
          );
        }

        final competitions = snapshot.data ?? [];

        if (competitions.isEmpty) {
          return const Center(
            child: Text(
              "Nessuna competizione presente",
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: competitions.length,
          itemBuilder: (context, index) {
            final competition = competitions[index];
            return CompetitionCard(
              competition: competition,
              onTap: () {
                context.push('${AppRoutes.competitions}/${competition.id}');
              },
            );
          },
        );
      },
    );
  }

}