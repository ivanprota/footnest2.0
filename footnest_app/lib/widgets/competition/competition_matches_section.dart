import 'package:flutter/material.dart';

import '/models/match/match_summary.dart';
import '/services/football_match_service.dart';
import '/services/service_locator.dart';
import '/widgets/team_details/match_summary_card.dart';

class CompetitionMatchesSection extends StatefulWidget {
  final int? competitionSeasonId;

  const CompetitionMatchesSection({
    super.key,
    required this.competitionSeasonId,
  });

  @override
  State<CompetitionMatchesSection> createState() =>
      _CompetitionMatchesSectionState();
}

class _CompetitionMatchesSectionState
    extends State<CompetitionMatchesSection> {

  final FootballMatchService matchService = locator();

  late Future<List<MatchSummary>> matchesFuture;

  int? selectedMatchday;

  @override
  void initState() {
    super.initState();

    matchesFuture = _loadMatches();
  }

  @override
  void didUpdateWidget(
    covariant CompetitionMatchesSection oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.competitionSeasonId !=
        widget.competitionSeasonId) {

      setState(() {
        selectedMatchday = null;
        matchesFuture = _loadMatches();
      });
    }
  }

  Future<List<MatchSummary>> _loadMatches() async {

    final seasonId = widget.competitionSeasonId;

    if (seasonId == null) {
      return [];
    }

    return matchService.getMatchesByCompetitionSeason(
      seasonId,
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

    if (widget.competitionSeasonId == null) {
      return const SizedBox();
    }

    return FutureBuilder<List<MatchSummary>>(
      future: matchesFuture,

      builder: (context, snapshot) {

        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
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

          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "Nessuna partita disponibile",
              ),
            ),
          );
        }

        final grouped =
            _groupByMatchday(matches);

        final matchdays =
            grouped.keys.toList()..sort();

        final effectiveMatchday =
            selectedMatchday != null &&
                    grouped.containsKey(selectedMatchday)
                ? selectedMatchday!
                : matchdays.first;

        final selectedMatches =
            grouped[effectiveMatchday] ?? [];

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Partite",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _buildMatchdaySelector(
              matchdays,
            ),

            const SizedBox(height: 24),

            Text(
              "Giornata $effectiveMatchday",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...selectedMatches.map(
              (match) => MatchSummaryCard(
                match: match,
              ),
            ),

          ],
        );
      },
    );
  }

  Widget _buildMatchdaySelector(
    List<int> matchdays,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Row(
        children: matchdays.map(
          (matchday) {

            final selected =
                selectedMatchday == matchday;

            return Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),

              child: _MatchdayButton(
                matchday: matchday,
                selected: selected,

                onTap: () {
                  setState(() {
                    selectedMatchday = matchday;
                  });
                },
              ),
            );
          },
        ).toList(),
      ),
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

      child: GestureDetector(
        onTap: widget.onTap,

        child: AnimatedContainer(

          duration:
              const Duration(milliseconds: 150),

          transform: hovered
              ? Matrix4.translationValues(
                  0,
                  -3,
                  0,
                )
              : Matrix4.identity(),

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
                      color:
                          Colors.black.withOpacity(
                        0.25,
                      ),
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
    );
  }
}