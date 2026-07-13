import '../competitionseason/competition_season.dart';

class Competition {

  final int id;
  final String name;
  final String? logoPath;
  final String type;
  final List<CompetitionSeason> seasons;


  const Competition({
    required this.id,
    required this.name,
    this.logoPath,
    required this.type,
    required this.seasons,
  });


  factory Competition.fromJson(Map<String, dynamic> json) {

    return Competition(
      id: json['id'],
      name: json['name'] ?? '',
      logoPath: json['logoPath'],
      type: json['type'] ?? '',
      seasons: (json['seasons'] as List?)
          ?.map(
              (e) => CompetitionSeason.fromJson(e)
          )
          .toList()
          ?? [],
    );

  }

}