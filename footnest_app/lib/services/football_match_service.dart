import '/models/match/competition_matches.dart';
import '/models/match/match_detail.dart';
import '/models/match/match_summary.dart';
import '/services/api_client.dart';

class FootballMatchService {

  final ApiClient apiClient;

  FootballMatchService(
      this.apiClient
  );

  Future<List<CompetitionMatches>> getMatchesByDate(DateTime date) async {

    final formatted =
        "${date.year}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";

    final response =
        await apiClient.get(
          "/football-matches/date/$formatted",
        );

    return (response as List)
        .map(
          (json) => CompetitionMatches.fromJson(json),
        )
        .toList();
  }

  Future<MatchDetail> getMatchDetail(int id) async {
    final response = await apiClient.get(
      "/football-matches/$id/details",
    );
    
    return MatchDetail.fromJson(response);
  }

  Future<List<MatchSummary>> getMatchesByCompetitionSeason(
    int competitionSeasonId,
  ) async {

    final response = await apiClient.get(
      "/football-matches/competition-season/$competitionSeasonId",
    );

    return (response as List)
        .map(
          (json) => MatchSummary.fromJson(json),
        )
        .toList();
  }

  Future<MatchDetail> updateMatch(int id, Map<String,dynamic> body,) async {
    final response =
        await apiClient.put(
          "/football-matches/$id",
          body,
        );

    return MatchDetail.fromJson(response);
  }

  Future<void> createStatistics(Map<String, dynamic> body) async {
    await apiClient.post(
      "/matches-statistics",
      body,
    );
  }

  Future<void> updateStatistics(int id, Map<String, dynamic> body) async {
    await apiClient.put(
      "/matches-statistics/$id",
      body,
    );
  }

}