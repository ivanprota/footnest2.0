import 'api_client.dart';
import '/models/competitionseason/competition_season.dart';

class CompetitionSeasonService {

  final ApiClient apiClient;

  CompetitionSeasonService(this.apiClient);

  Future<List<CompetitionSeason>> getCompetitionSeasons() async {
    final response =
        await apiClient.get('/competition-seasons');

    return (response as List)
        .map(
          (json) => CompetitionSeason.fromJson(json),
        )
        .toList();
  }
}