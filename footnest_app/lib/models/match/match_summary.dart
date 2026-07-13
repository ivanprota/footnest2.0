class MatchSummary {

  final int id;
  final String homeTeam;
  final String awayTeam;
  final String homeLogo;
  final String awayLogo;
  final DateTime date;
  final int? homeGoals;
  final int? awayGoals;
  final String status;

  MatchSummary({

    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    required this.date,
    required this.homeGoals,
    required this.awayGoals,
    required this.status,

  });

  factory MatchSummary.fromJson(Map<String,dynamic> json){
    return MatchSummary(
      id: json['id'],
      homeTeam: json['homeTeam'],
      awayTeam: json['awayTeam'],
      homeLogo: json['homeLogo'],
      awayLogo: json['awayLogo'],
      date: DateTime.parse(json['date']),
      homeGoals: json['homeGoals'],
      awayGoals: json['awayGoals'],
      status: json['status'],
    );
  }

}