import '/services/api_client.dart';
import '/models/team/team_match_statistics.dart';

class TeamStatisticsService {

  final ApiClient apiClient;

  TeamStatisticsService(this.apiClient);

  Future<List<TeamMatchStatistics>> getTeamStatistics(
    int teamId,
  ) async {

    final response =
        await apiClient.get(
          "/teams/$teamId/statistics",
        );

    return (response as List)
        .map(
          (json) => TeamMatchStatistics.fromJson(json),
        )
        .toList();
  }
}