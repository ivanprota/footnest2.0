import 'match_statistics.dart';

class MatchDetail {

  final int id;

  final int homeTeamId;
  final int awayTeamId;

  final String homeTeam;
  final String awayTeam;

  final String homeLogo;
  final String awayLogo;

  final DateTime date;

  final String? kickoffTime;

  final int? homeGoals;
  final int? awayGoals;

  final int matchday;

  final String status;

  final String competition;
  final String season;

  final List<MatchStatistics> statistics;


  MatchDetail({
    required this.id,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    required this.date,
    this.kickoffTime,
    this.homeGoals,
    this.awayGoals,
    required this.matchday,
    required this.status,
    required this.competition,
    required this.season,
    required this.statistics,
  });

  factory MatchDetail.fromJson(Map<String, dynamic> json) {
    return MatchDetail(
      id: json["id"],
      homeTeamId: json["homeTeamId"],
      awayTeamId: json["awayTeamId"],
      homeTeam: json["homeTeam"],
      awayTeam: json["awayTeam"],
      homeLogo: json["homeLogo"],
      awayLogo: json["awayLogo"],
      date: DateTime.parse(json["date"]),
      kickoffTime: json["kickoffTime"],
      homeGoals: json["homeGoals"],
      awayGoals: json["awayGoals"],
      matchday: json["matchday"],
      status: json["status"],
      competition: json["competition"],
      season: json["season"],
      statistics: (json["statistics"] as List<dynamic>)
          .map(
            (e) => MatchStatistics.fromJson(e),
          )
          .toList(),
    );
  }

  MatchDetail copyWith({

    DateTime? date,
    String? kickoffTime,
    int? homeGoals,
    int? awayGoals,
    int? homeTeamId,
    int? awayTeamId,
    String? status,

  }) {

    return MatchDetail(

      id: id,

      homeTeam: homeTeam,
      awayTeam: awayTeam,

      homeLogo: homeLogo,
      awayLogo: awayLogo,

      date: date ?? this.date,

      kickoffTime:
          kickoffTime ?? this.kickoffTime,

      homeGoals:
          homeGoals ?? this.homeGoals,

      awayGoals:
          awayGoals ?? this.awayGoals,

      homeTeamId: homeTeamId ?? this.homeTeamId,

      awayTeamId: awayTeamId ?? this.awayTeamId,

      matchday:
          matchday,

      status:
          status ?? this.status,

      competition:
          competition,

      season:
          season,

      statistics:
          statistics,

    );

  }

}