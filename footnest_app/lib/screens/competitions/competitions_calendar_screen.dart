import 'package:flutter/material.dart';
import 'package:footnest_app/services/match_refresh_service.dart';

import '/models/match/match_summary.dart';
import '/services/football_match_service.dart';
import '/services/service_locator.dart';
import '/widgets/team_details/match_summary_card.dart';

class CompetitionCalendarScreen extends StatefulWidget {
  final int competitionSeasonId;

  const CompetitionCalendarScreen({
    super.key,
    required this.competitionSeasonId,
  });

  @override
  State<CompetitionCalendarScreen> createState() =>
      _CompetitionCalendarScreenState();
}

class _CompetitionCalendarScreenState
    extends State<CompetitionCalendarScreen> {

  final FootballMatchService matchService = locator();

  late Future<List<MatchSummary>> matchesFuture;

  int? selectedMatchday;

  final MatchRefreshService matchRefreshService = locator<MatchRefreshService>();

  @override
  void initState() {
    super.initState();
    matchesFuture = _loadMatches();
    matchRefreshService.addListener(_onMatchesChanged);
  }

  void _onMatchesChanged() {
    if (!mounted) return;

    setState(() {
      matchesFuture = _loadMatches();
    });
  }

  @override
  void dispose() {
    matchRefreshService.removeListener(
      _onMatchesChanged,
    );

    super.dispose();
  }

  Future<List<MatchSummary>> _loadMatches() async {
    return matchService.getMatchesByCompetitionSeason(
      widget.competitionSeasonId,
    );
  }

  Map<int, List<MatchSummary>> _groupByMatchday(
    List<MatchSummary> matches,
  ) {
    final grouped = <int, List<MatchSummary>>{};

    for (final match in matches) {
      grouped
          .putIfAbsent(
            match.matchday,
            () => [],
          )
          .add(match);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calendario",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<List<MatchSummary>>(
        future: matchesFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Errore caricamento partite: "
                "${snapshot.error}",
              ),
            );
          }

          final matches = snapshot.data ?? [];

          if (matches.isEmpty) {
            return const Center(
              child: Text(
                "Nessuna partita disponibile",
              ),
            );
          }

          final Map<int, List<MatchSummary>> grouped =
              _groupByMatchday(matches);

          final List<int> matchdays =
              grouped.keys.toList()..sort();

          final effectiveMatchday =
              selectedMatchday != null &&
                      grouped.containsKey(selectedMatchday)
                  ? selectedMatchday!
                  : matchdays.first;

          if (selectedMatchday != effectiveMatchday) {
            selectedMatchday = effectiveMatchday;
          }

          final selectedMatches =
              grouped[effectiveMatchday] ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),

            children: [

              const Text(
                "Calendario",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _buildMatchdaySelector(
                matchdays,
              ),

              const SizedBox(height: 30),

              Text(
                "Giornata $effectiveMatchday",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              ...selectedMatches.map(
                (match) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: MatchSummaryCard(
                    match: match,
                    showResultIndicator: false,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMatchdaySelector(List matchdays) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: matchdays.map(
        (matchday) {
          final selected =
              selectedMatchday == matchday;

          return _MatchdayButton(
            matchday: matchday,
            selected: selected,
            onTap: () {
              setState(() {
                selectedMatchday = matchday;
              });
            },
          );
        },
      ).toList(),
    );
  }
}

class _MatchdayButton extends StatefulWidget {
  final int matchday;
  final bool selected;
  final VoidCallback onTap;

  const _MatchdayButton({
    required this.matchday,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_MatchdayButton> createState() =>
      _MatchdayButtonState();
}

class _MatchdayButtonState
    extends State<_MatchdayButton> {

  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final primary =
        Theme.of(context).colorScheme.primary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          hovered = true;
        });
      },

      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(12),

          onTap: widget.onTap,

          mouseCursor:
              SystemMouseCursors.click,

          child: AnimatedContainer(
            duration:
                const Duration(milliseconds: 150),

            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),

            decoration: BoxDecoration(
              color: widget.selected
                  ? primary
                  : hovered
                      ? primary.withOpacity(0.15)
                      : Theme.of(context)
                          .colorScheme
                          .surface,

              borderRadius:
                  BorderRadius.circular(12),

              border: Border.all(
                color: widget.selected
                    ? primary
                    : Theme.of(context)
                        .colorScheme
                        .outline,
              ),

              boxShadow: hovered
                  ? [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.25),
                        blurRadius: 8,
                        offset:
                            const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),

            child: Text(
              "Giornata ${widget.matchday}",

              style: TextStyle(
                color: widget.selected
                    ? Colors.white
                    : null,

                fontWeight:
                    widget.selected || hovered
                        ? FontWeight.bold
                        : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}