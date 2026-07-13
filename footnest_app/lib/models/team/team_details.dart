import '/models/teamcompetition/team_competition.dart';
import '/models/standing/standing.dart';
import '/models/match/match_summary.dart';

class TeamDetails {

  final int id;
  final String name;
  final String logoPath;
  final List<TeamCompetition> competitions;
  final Standing? standing;
  final List<MatchSummary> lastMatches;
  final List<MatchSummary> nextMatches;

  TeamDetails({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.competitions,
    this.standing,
    required this.lastMatches,
    required this.nextMatches,
  });

  factory TeamDetails.fromJson(Map<String, dynamic> json) {
    return TeamDetails(
      id: json['id'],
      name: json['name'],
      logoPath: json['logoPath'],
      competitions:
          (json['competitions'] as List)
              .map(
                (e) => TeamCompetition.fromJson(e)
              )
              .toList(),
      standing:
          json['standing'] != null
              ? Standing.fromJson(json['standing'])
              : null,
      lastMatches:
          (json['lastMatches'] as List)
              .map(
                (e) => MatchSummary.fromJson(e)
              )
              .toList(),
      nextMatches:
          (json['nextMatches'] as List)
              .map(
                (e) => MatchSummary.fromJson(e)
              )
              .toList(),
    );
  }

}