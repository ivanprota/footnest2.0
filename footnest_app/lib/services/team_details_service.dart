import 'api_client.dart';
import '/models/team/team_details.dart';


class TeamDetailsService {

  final ApiClient apiClient;

  TeamDetailsService(this.apiClient);

  Future<TeamDetails> getTeamDetails(int teamId) async {
    final response = await apiClient.get(
      '/teams/$teamId/details'
    );

    return TeamDetails.fromJson(
      response
    );
  }

}