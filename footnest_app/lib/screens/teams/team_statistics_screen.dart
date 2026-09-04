import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '/routes/routes.dart';

import '/models/team/team_match_statistics.dart';
import '/services/service_locator.dart';
import '/services/team_statistics_service.dart';
import '/services/team_refresh_service.dart';

class TeamStatisticsScreen extends StatefulWidget {
  final int teamId;
 
  const TeamStatisticsScreen({
    super.key,
    required this.teamId,
  });

  @override
  State<TeamStatisticsScreen> createState() =>
      _TeamStatisticsScreenState();
}

class _TeamStatisticsScreenState
    extends State<TeamStatisticsScreen> {

  late Future<List<TeamMatchStatistics>> statisticsFuture;

  final teamStatisticsService = locator<TeamStatisticsService>();

  final teamRefreshService = locator<TeamRefreshService>();

  String selectedStatistic = "XG";
  String selectedRange = "TOTAL";
  String selectedVenue = "TOTAL";

  @override
  void initState() {
    super.initState();
    teamRefreshService.addListener(_onTeamRefresh);
    statisticsFuture = teamStatisticsService.getTeamStatistics(widget.teamId);
  }

  @override
  void dispose() {
    teamRefreshService.removeListener(
      _onTeamRefresh,
    );

    super.dispose();
  }

  void _onTeamRefresh() {
    setState(() {
      statisticsFuture =
          teamStatisticsService.getTeamStatistics(
        widget.teamId,
      );
    });
  }

  List<TeamMatchStatistics> filterMatches(
    List matches,
  ) {
    List<TeamMatchStatistics> result =
        List.from(matches);

    result.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    if (selectedVenue == "HOME") {
      result = result
          .where(_isTeamHome)
          .toList();
    }

    if (selectedVenue == "AWAY") {
      result = result
          .where(_isTeamAway)
          .toList();
    }

    if (selectedRange == "5") {
      result = result.take(5).toList();
    }

    if (selectedRange == "10") {
      result = result.take(10).toList();
    }

    return result;
  }

  // Questi due metodi verranno sostituiti
  // dal controllo effettivo del team tramite i dati.
  //
  // Per ora li lasciamo separati per rendere
  // più semplice la gestione del filtro.
  bool _isTeamHome(TeamMatchStatistics match) {
    return match.teamId == match.homeTeamId;
  }

  bool _isTeamAway(TeamMatchStatistics match) {
    return match.teamId == match.awayTeamId;
  }

  double _sumXg(
    List<TeamMatchStatistics> matches,
  ) {
    double total = 0;

    for (final match in matches) {
      final stats = match.teamId == match.homeTeamId
          ? match.homeStatistics
          : match.awayStatistics;

      total += stats?.xg ?? 0;
    }

    return total;
  }

  double _sumXgAgainst(
    List<TeamMatchStatistics> matches,
  ) {
    double total = 0;

    for (final match in matches) {
      final stats = match.teamId == match.homeTeamId
          ? match.awayStatistics
          : match.homeStatistics;

      total += stats?.xg ?? 0;
    }

    return total;
  }

  int _sumGoals(
    List<TeamMatchStatistics> matches,
  ) {
    int total = 0;

    for (final match in matches) {
      if (match.teamId == match.homeTeamId) {
        total += match.homeGoals ?? 0;
      } else {
        total += match.awayGoals ?? 0;
      }
    }

    return total;
  }

  int _sumGoalsAgainst(
    List<TeamMatchStatistics> matches,
  ) {
    int total = 0;

    for (final match in matches) {
      if (match.teamId == match.homeTeamId) {
        total += match.awayGoals ?? 0;
      } else {
        total += match.homeGoals ?? 0;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiche squadra"),
      ),
      body: FutureBuilder<List<TeamMatchStatistics>>(
        future: statisticsFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Errore caricamento statistiche",
              ),
            );
          }

          final matches = snapshot.data ?? [];

          if (matches.isEmpty) {
            return const Center(
              child: Text(
                "Nessuna statistica disponibile",
              ),
            );
          }

          final filteredMatches =
              filterMatches(matches);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                _buildStatisticFilters(),

                const SizedBox(height: 20),

                _buildRangeFilters(),

                const SizedBox(height: 20),

                _buildVenueFilters(),

                const SizedBox(height: 30),

                if (selectedStatistic == "XG")
                  _buildXgSummary(
                    filteredMatches,
                  ),

                const SizedBox(height: 25),

                if (filteredMatches.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "Nessuna partita disponibile "
                        "con questi filtri",
                      ),
                    ),
                  )
                else
                  Column(
                    children: filteredMatches
                        .map(
                          (match) =>
                              _buildMatchCard(match),
                        )
                        .toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticFilters() {
    final filters = [
      ("XG", "xG"),
      ("POSSESSION", "Possesso"),
      ("SHOTS", "Tiri"),
      ("BIG_CHANCES", "Grandi occasioni"),
      ("CORNERS", "Corner"),
      ("YELLOW", "Gialli"),
      ("RED", "Rossi"),
      ("FOULS", "Falli"),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((filter) {

        final selected =
            selectedStatistic == filter.$1;

        return ChoiceChip(
          label: Text(filter.$2),

          selected: selected,

          mouseCursor:
              SystemMouseCursors.click,

          onSelected: (_) {
            setState(() {
              selectedStatistic = filter.$1;
            });
          },
        );

      }).toList(),
    );
  }

  Widget _buildRangeFilters() {
    return Wrap(
      spacing: 8,
      children: [
        _buildChoice(
          "5",
          "Ultime 5 partite",
        ),
        _buildChoice(
          "10",
          "Ultime 10 partite",
        ),
        _buildChoice(
          "TOTAL",
          "Totale",
        ),
      ],
    );
  }

  Widget _buildVenueFilters() {
    return Wrap(
      spacing: 8,
      children: [
        _buildVenueChoice(
          "HOME",
          "Casa",
        ),
        _buildVenueChoice(
          "AWAY",
          "Trasferta",
        ),
        _buildVenueChoice(
          "TOTAL",
          "Totale",
        ),
      ],
    );
  }

  Widget _buildChoice(
    String value,
    String label,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedRange == value,

      mouseCursor: SystemMouseCursors.click,

      onSelected: (_) {
        setState(() {
          selectedRange = value;
        });
      },
    );
  }

  Widget _buildVenueChoice(
    String value,
    String label,
  ) {
    return ChoiceChip(
      label: Text(label),

      selected: selectedVenue == value,

      mouseCursor:
          SystemMouseCursors.click,

      onSelected: (_) {
        setState(() {
          selectedVenue = value;
        });
      },
    );
  }

  Widget _buildXgSummary(
    List<TeamMatchStatistics> matches,
  ) {
    final xg = _sumXg(matches);
    final xgAgainst = _sumXgAgainst(matches);

    final goals = _sumGoals(matches);
    final goalsAgainst = _sumGoalsAgainst(matches);

    return Row(
      children: [

        Expanded(
          child: _buildSummaryCard(
            title: "xG",
            value: xg.toStringAsFixed(2),
            subtitle:
                "Gol segnati: $goals",
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          child: _buildSummaryCard(
            title: "xG contro",
            value: xgAgainst.toStringAsFixed(2),
            subtitle:
                "Gol subiti: $goalsAgainst",
          ),
        ),

      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(
    TeamMatchStatistics match,
  ) {
    bool hovered = false;

    return StatefulBuilder(
      builder: (context, setHoverState) {

        return MouseRegion(
          cursor: SystemMouseCursors.click,

          onEnter: (_) {
            setHoverState(() {
              hovered = true;
            });
          },

          onExit: (_) {
            setHoverState(() {
              hovered = false;
            });
          },

          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),

            transform: hovered
                ? Matrix4.translationValues(0, -4, 0)
                : Matrix4.identity(),

            child: Card(
              elevation: hovered ? 8 : 2,

              child: InkWell(
                mouseCursor:
                    SystemMouseCursors.click,

                borderRadius:
                    BorderRadius.circular(12),

                onTap: () {
                  context.push(
                    '${AppRoutes.matches}/${match.matchId}',
                  );
                },

                child: Padding(
                  padding: const EdgeInsets.all(14),

                  child: Column(
                    children: [

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Risultato + data + ora
                          SizedBox(
                            width: 70,
                            child: Column(
                              children: [

                                if (match.homeGoals != null &&
                                    match.awayGoals != null)
                                  _ResultIndicator(
                                    homeGoals: match.homeGoals,
                                    awayGoals: match.awayGoals,
                                    teamId: match.teamId,
                                    homeTeamId: match.homeTeamId,
                                    awayTeamId: match.awayTeamId,
                                  )
                                else
                                  const SizedBox(
                                    height: 30,
                                  ),

                                const SizedBox(height: 8),

                                Text(
                                  DateFormat("dd-MM-yyyy").format(match.date),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),

                              ],
                            ),
                          ),


                          const SizedBox(width: 12),

                          // Squadre
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Expanded(
                                  child: _buildTeamStatisticsColumn(
                                    name: match.homeTeam,
                                    logo: match.homeLogo,
                                    statistics: match.homeStatistics,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Column(
                                    children: [

                                      const SizedBox(height: 12),

                                      Text(
                                        "${match.homeGoals ?? '-'}"
                                        " - "
                                        "${match.awayGoals ?? '-'}",
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: _buildTeamStatisticsColumn(
                                    name: match.awayTeam,
                                    logo: match.awayLogo,
                                    statistics: match.awayStatistics,
                                  ),
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamStatisticsColumn({
    required String name,
    required String logo,
    required MatchTeamStatistics? statistics,
  }) {
    return Column(
      children: [

        Image.network(
          logo,
          height: 45,
          width: 45,
          errorBuilder: (_, __, ___) {
            return const Icon(
              Icons.shield,
              size: 45,
            );
          },
        ),

        const SizedBox(height: 6),

        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        _buildTeamStatisticValues(
          statistics,
        ),
      ],
    );
  }

  Widget _buildTeamStatisticValues(
    MatchTeamStatistics? stats,
  ) {
    if (stats == null) {
      return const Text("-");
    }

    switch (selectedStatistic) {

      case "XG":
        return _buildStatisticValue(
          "xG",
          stats.xg?.toStringAsFixed(2) ?? "-",
        );

      case "POSSESSION":
        return _buildStatisticValue(
          "Possesso",
          stats.possession != null
              ? "${stats.possession!.toStringAsFixed(1)}%"
              : "-",
        );

      case "SHOTS":
        return Column(
          children: [
            _buildStatisticValue(
              "Tiri",
              "${stats.totalShots ?? '-'}",
            ),
            _buildStatisticValue(
              "In porta",
              "${stats.shotsOnTarget ?? '-'}",
            ),
          ],
        );

      case "BIG_CHANCES":
        return _buildStatisticValue(
          "Grandi occasioni",
          "${stats.bigChances ?? '-'}",
        );

      case "CORNERS":
        return _buildStatisticValue(
          "Corner",
          "${stats.corners ?? '-'}",
        );

      case "YELLOW":
        return _buildStatisticValue(
          "Gialli",
          "${stats.yellowCards ?? '-'}",
        );

      case "RED":
        return _buildStatisticValue(
          "Rossi",
          "${stats.redCards ?? '-'}",
        );

      case "FOULS":
        return _buildStatisticValue(
          "Falli",
          "${stats.fouls ?? '-'}",
        );

      default:
        return const SizedBox();
    }
  }

  Widget _buildStatisticValue(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 3,
        bottom: 3,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Text(
            "$label: ",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }

}

class _ResultIndicator extends StatelessWidget {

  final int? homeGoals;
  final int? awayGoals;

  final int teamId;
  final int homeTeamId;
  final int awayTeamId;

  const _ResultIndicator({
    required this.homeGoals,
    required this.awayGoals,
    required this.teamId,
    required this.homeTeamId,
    required this.awayTeamId,
  });

  @override
  Widget build(BuildContext context) {

    if (homeGoals == null || awayGoals == null) {
      return const SizedBox.shrink();
    }

    final bool isHome = teamId == homeTeamId;

    final int teamGoals =
        isHome ? homeGoals! : awayGoals!;

    final int opponentGoals =
        isHome ? awayGoals! : homeGoals!;

    late String result;
    late Color color;

    if (teamGoals > opponentGoals) {
      result = "V";
      color = Colors.green;
    } else if (teamGoals < opponentGoals) {
      result = "S";
      color = Colors.red;
    } else {
      result = "P";
      color = Colors.amber;
    }

    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(
        result,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}