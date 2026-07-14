class CompetitionSeason {

  final int id;
  final String competitionName;
  final String seasonName;


  CompetitionSeason({
    required this.id,
    required this.competitionName,
    required this.seasonName,
  });


  factory CompetitionSeason.fromJson(
      Map<String, dynamic> json
  ) {

    return CompetitionSeason(
      id: json['id'],
      competitionName:
          json['competitionName'],
      seasonName:
          json['seasonName'],
    );
  }


  String get displayName =>
      '$competitionName $seasonName';
}