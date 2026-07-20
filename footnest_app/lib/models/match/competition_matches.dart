import 'match_summary.dart';


class CompetitionMatches {

  final int competitionSeasonId;
  final String competitionName;
  final String competitionLogo;
  final List<MatchSummary> matches;

  CompetitionMatches({

    required this.competitionSeasonId,
    required this.competitionName,
    required this.competitionLogo,
    required this.matches,

  });

  factory CompetitionMatches.fromJson(Map<String,dynamic> json){
    return CompetitionMatches(
      competitionSeasonId: json['competitionSeasonId'],
      competitionName: json['competitionName'],
      competitionLogo: json['competitionLogo'],
      matches: (json['matches'] as List)
          .map((e)=>MatchSummary.fromJson(e))
          .toList(),
    );
  }
}