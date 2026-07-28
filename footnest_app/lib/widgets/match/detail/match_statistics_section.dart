import 'package:flutter/material.dart';

import '/models/match/match_detail.dart';
import '/config/api_config.dart';

class MatchStatisticsSection extends StatefulWidget {

  final MatchDetail match;
  final bool editing;
  final Function(int, Map<String, dynamic>) onSave;

  const MatchStatisticsSection({
    super.key,
    required this.match,
    required this.editing,
    required this.onSave,
  });

  @override
  State<MatchStatisticsSection> createState() =>
      MatchStatisticsSectionState();

}



class MatchStatisticsSectionState extends State<MatchStatisticsSection> {

  final Map<String, TextEditingController> controllers = {};


  TextEditingController getController(String key, dynamic value) {
    if (!controllers.containsKey(key)) {
      controllers[key] =
          TextEditingController(
            text: value?.toString() ?? "",
          );
    }

    return controllers[key]!;

  }

  Map<String, dynamic> buildPayload(String prefix) {
    return {

      "xg":
          double.tryParse(
            controllers["${prefix}_xg"]?.text ?? "",
          ),


      "possession":
          double.tryParse(
            controllers["${prefix}_possession"]?.text ?? "",
          ),


      "totalShots":
          int.tryParse(
            controllers["${prefix}_totalShots"]?.text ?? "",
          ),


      "shotsOnTarget":
          int.tryParse(
            controllers["${prefix}_shotsOnTarget"]?.text ?? "",
          ),


      "bigChances":
          int.tryParse(
            controllers["${prefix}_bigChances"]?.text ?? "",
          ),


      "corners":
          int.tryParse(
            controllers["${prefix}_corners"]?.text ?? "",
          ),


      "yellowCards":
          int.tryParse(
            controllers["${prefix}_yellowCards"]?.text ?? "",
          ),


      "redCards":
          int.tryParse(
            controllers["${prefix}_redCards"]?.text ?? "",
          ),


      "fouls":
          int.tryParse(
            controllers["${prefix}_fouls"]?.text ?? "",
          ),

    };

  }



  void saveStatistics(dynamic homeStats, dynamic awayStats) async {
    await widget.onSave(
      homeStats.id,
      {
        "matchId": widget.match.id,

        "teamId":
            widget.match.homeTeamId,

        ...buildPayload("home"),

      },
    );

    await widget.onSave(
      awayStats.id,
      {
        "matchId": widget.match.id,

        "teamId":
            widget.match.awayTeamId,

        ...buildPayload("away"),
      },
    );

  }

  Future<void> saveAllStatistics() async {

    final homeStats =
        widget.match.statistics.where(
          (s) =>
              s.teamName ==
              widget.match.homeTeam,
        ).firstOrNull;


    final awayStats =
        widget.match.statistics.where(
          (s) =>
              s.teamName ==
              widget.match.awayTeam,
        ).firstOrNull;


    await widget.onSave(
      homeStats?.id ?? -1,
      {
        "matchId": widget.match.id,
        "teamId": widget.match.homeTeamId,
        ...buildPayload("home"),
      },
    );


    await widget.onSave(
      awayStats?.id ?? -1,
      {
        "matchId": widget.match.id,
        "teamId": widget.match.awayTeamId,
        ...buildPayload("away"),
      },
    );

  }

  @override
  void dispose() {
    for(final controller in controllers.values) {
      controller.dispose();
    }

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        widget.match.statistics.length < 2

            ? widget.editing

                ? _buildEmptyStatisticsForm()

                : const Text(
                    "Dati statistici incompleti",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )

            : _buildStatistics(),

      ],

    );
  }

  Widget _buildStatistics() {
    final homeStats =
        widget.match.statistics.firstWhere(
          (s) =>
              s.teamName ==
              widget.match.homeTeam,
        );

    final awayStats =
        widget.match.statistics.firstWhere(
          (s) =>
              s.teamName ==
              widget.match.awayTeam,
        );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Column(
        children: [

          Row(
            children: [

              Expanded(
                child: _teamStatisticHeader(
                  homeStats.teamName,
                  homeStats.teamLogo,
                ),
              ),

              const Icon(
                Icons.analytics_outlined,
                color: Colors.grey,
              ),

              Expanded(
                child: _teamStatisticHeader(
                  awayStats.teamName,
                  awayStats.teamLogo,
                ),
              ),

            ],
          ),

          const SizedBox(height:25),

          _statRow(
            "xG",
            homeStats.xg,
            awayStats.xg,
            "xg",
            progress:true,
          ),

          _statRow(
            "Possesso",
            homeStats.possession,
            awayStats.possession,
            "possession",
            suffix:"%",
            progress:true,
          ),

          _statRow(
            "Tiri",
            homeStats.totalShots,
            awayStats.totalShots,
            "totalShots",
            progress:true,
          ),

          _statRow(
            "Tiri in porta",
            homeStats.shotsOnTarget,
            awayStats.shotsOnTarget,
            "shotsOnTarget",
            progress:true,
          ),

          _statRow(
            "Grandi occasioni",
            homeStats.bigChances,
            awayStats.bigChances,
            "bigChances",
            progress:true,
          ),

          _statRow(
            "Corner",
            homeStats.corners,
            awayStats.corners,
            "corners",
            progress:true,
          ),

          _statRow(
            "Gialli",
            homeStats.yellowCards,
            awayStats.yellowCards,
            "yellowCards",
            progress:true,
          ),

          _statRow(
            "Rossi",
            homeStats.redCards,
            awayStats.redCards,
            "redCards",
            progress:true,
          ),

          _statRow(
            "Falli",
            homeStats.fouls,
            awayStats.fouls,
            "fouls",
            progress:true,
          ),

          if(widget.editing)
            const SizedBox(height:20),

        ],
      ),
    );
  }

  Widget _teamStatisticHeader(String name, String logo) {
    return Column(
      children: [

        Text(
          name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:16,
          ),
        ),

        const SizedBox(height:8),

        Image.network(
          "${ApiConfig.baseUrl}/$logo",
          width:45,
          height:45,
          errorBuilder:
              (_,__,___)=>
                  const Icon(
                    Icons.shield,
                    size:45,
                  ),
        ),

      ],

    );
  }

  Widget _statRow(
    String label,
    dynamic home,
    dynamic away,
    String field,
    {
      String suffix = "",
      bool progress = false,
    }
  ) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical:12),
      child: Column(
        children: [

          Row(
            children: [

              Expanded(
                child: _valueWidget(
                  "home_$field",
                   home,
                ),
              ),

              SizedBox(
                width:130,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Expanded(
                child: _valueWidget(
                  "away_$field",
                  away,
                  alignRight:true,
                ),
              ),

            ],

          ),

          if(progress)
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: _buildProgress(
                home,
                away,
              ),
            ),

          const Divider(height:20),

        ],

      ),
    );
  }

  Widget _valueWidget(String key, dynamic value, {bool alignRight = false}) {
    if(widget.editing) {
      return SizedBox(
        width:60,
        child: TextField(
          controller: getController(
            key,
            value,
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(8),
          ),
        ),
      );
    }

    return Text(
      value == null
          ? "-"
          : value.toString(),
      textAlign:
          alignRight
              ? TextAlign.right
              : TextAlign.left,
      style: const TextStyle(
        fontSize:18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProgress(dynamic home, dynamic away) {

    final double h =
        double.tryParse(
          home?.toString() ?? "",
        ) ?? 0;

    final double a =
        double.tryParse(
          away?.toString() ?? "",
        ) ?? 0;

    final total = h + a;

    final homePercent =
        total == 0
            ? 0.5
            : h / total;

    final awayPercent =
        total == 0
            ? 0.5
            : a / total;

    final bool homeBetter = h > a;
    final bool awayBetter = a > h;

    return SizedBox(
      height:14,
      child: Row(
        children: [

          Expanded(
            child: Align(
              alignment:Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: homePercent,
                child: Container(
                  height:6,
                  decoration: BoxDecoration(
                    color: homeBetter
                      ? Colors.green
                      : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),

          Container(
            width:2,
            height:14,
            color: Colors.white38,
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: awayPercent,
                child: Container(
                  height:6,
                  decoration: BoxDecoration(
                    color: awayBetter
                      ? Colors.green
                      : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),

        ],

      ),
    );
  }

  Widget _buildEmptyStatisticsForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [

          const Text(
            "Inserisci statistiche",
            style: TextStyle(
              fontSize:20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height:20),

          _emptyStatRow(
            "xG",
            "xg",
          ),

          _emptyStatRow(
            "Possesso",
            "possession",
          ),

          _emptyStatRow(
            "Tiri",
            "totalShots",
          ),

          _emptyStatRow(
            "Tiri in porta",
            "shotsOnTarget",
          ),

          _emptyStatRow(
            "Grandi occasioni",
            "bigChances",
          ),

          _emptyStatRow(
            "Corner",
            "corners",
          ),

          _emptyStatRow(
            "Gialli",
            "yellowCards",
          ),

          _emptyStatRow(
            "Rossi",
            "redCards",
          ),

          _emptyStatRow(
            "Falli",
            "fouls",
          ),

          const SizedBox(height:20),

        ],

      ),
    );
  }

  Widget _emptyStatRow(String label, String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8),
      child: Row(
        children: [

          Expanded(
            child: TextField(
              controller: getController(
                "home_$field",
                null,
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            width:120,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            child: TextField(
              controller: getController(
                "away_$field",
                null,
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
          ),

        ],

      ),
    );
  }

}