class CompetitionSeason {

  final int id;
  final String seasonName;


  CompetitionSeason({
    required this.id,
    required this.seasonName,
  });


  factory CompetitionSeason.fromJson(
      Map<String, dynamic> json
  ) {

    return CompetitionSeason(
      id: json['id'],
      seasonName: json['seasonName'],
    );

  }

}