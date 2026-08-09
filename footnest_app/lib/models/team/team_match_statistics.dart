class TeamMatchStatistics {

  final int matchId;
  final int teamId;

  final int homeTeamId;
  final int awayTeamId;

  final DateTime date;

  final String homeTeam;
  final String awayTeam;

  final String homeLogo;
  final String awayLogo;

  final int? homeGoals;
  final int? awayGoals;

  final MatchTeamStatistics? homeStatistics;
  final MatchTeamStatistics? awayStatistics;

  TeamMatchStatistics({
    required this.matchId,
    required this.teamId,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.date,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    required this.homeGoals,
    required this.awayGoals,
    required this.homeStatistics,
    required this.awayStatistics,
  });

  factory TeamMatchStatistics.fromJson(
    Map<String, dynamic> json,
  ) {

    return TeamMatchStatistics(

      matchId: json["matchId"],
      teamId: json["teamId"],

      homeTeamId: json["homeTeamId"],
      awayTeamId: json["awayTeamId"],

      date: DateTime.parse(
        json["date"],
      ),

      homeTeam: json["homeTeam"],
      awayTeam: json["awayTeam"],

      homeLogo: json["homeLogo"],
      awayLogo: json["awayLogo"],

      homeGoals: json["homeGoals"],
      awayGoals: json["awayGoals"],

      homeStatistics:
          json["homeStatistics"] != null
              ? MatchTeamStatistics.fromJson(
                  json["homeStatistics"],
                )
              : null,

      awayStatistics:
          json["awayStatistics"] != null
              ? MatchTeamStatistics.fromJson(
                  json["awayStatistics"],
                )
              : null,
    );
  }
}


class MatchTeamStatistics {

  final double? xg;
  final double? possession;

  final int? totalShots;
  final int? shotsOnTarget;

  final int? bigChances;
  final int? corners;

  final int? yellowCards;
  final int? redCards;

  final int? fouls;

  MatchTeamStatistics({
    required this.xg,
    required this.possession,
    required this.totalShots,
    required this.shotsOnTarget,
    required this.bigChances,
    required this.corners,
    required this.yellowCards,
    required this.redCards,
    required this.fouls,
  });

  factory MatchTeamStatistics.fromJson(
    Map<String, dynamic> json,
  ) {

    return MatchTeamStatistics(

      xg: (json["xg"] as num?)?.toDouble(),

      possession:
          (json["possession"] as num?)?.toDouble(),

      totalShots: json["totalShots"],
      shotsOnTarget: json["shotsOnTarget"],

      bigChances: json["bigChances"],
      corners: json["corners"],

      yellowCards: json["yellowCards"],
      redCards: json["redCards"],

      fouls: json["fouls"],
    );
  }
}