import '/models/match/competition_matches.dart';
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

}