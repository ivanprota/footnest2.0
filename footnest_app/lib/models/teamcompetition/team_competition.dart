class TeamCompetition {

  final String competitionName;
  final String seasonName;

  TeamCompetition({
    required this.competitionName,
    required this.seasonName,
  });

  factory TeamCompetition.fromJson(Map<String,dynamic> json) {
    return TeamCompetition(
      competitionName:
          json['competitionName'],
      seasonName:
          json['seasonName'],
    );
  }

}