class TeamCreateRequest {

  final String name;
  final String logoPath;
  final int competitionSeasonId;


  TeamCreateRequest({
    required this.name,
    required this.logoPath,
    required this.competitionSeasonId,
  });


  Map<String, dynamic> toJson() {

    return {
      'name': name,
      'logoPath': logoPath,
      'competitionSeasonId': competitionSeasonId,
    };
  }
}