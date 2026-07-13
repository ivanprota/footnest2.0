import '/models/team/team.dart';

class Standing {

  final Team team;
  final int position;
  final int played;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int points;
  final double totalXg;

  Standing({
    required this.team,
    required this.position,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
    required this.totalXg,
  });

  factory Standing.fromJson(Map<String,dynamic> json){
    return Standing(
      team: Team.fromJson(json['team']),
      position: json['position'],
      played: json['played'],
      wins: json['wins'],
      draws: json['draws'],
      losses: json['losses'],
      goalsFor: json['goalsFor'],
      goalsAgainst:
          json['goalsAgainst'],
      points: json['points'],
      totalXg:
          json['totalXg']?.toDouble() ?? 0,
    );
  }

}