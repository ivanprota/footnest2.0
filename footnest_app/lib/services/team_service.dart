import '../models/team/team.dart';
import 'api_client.dart';

class TeamService {

  final ApiClient apiClient;

  TeamService(this.apiClient);

  Future<List<Team>> getTeams() async {
    final data =
        await apiClient.get("/teams");

    return (data as List)
        .map(
          (json) => Team.fromJson(json)
        )
        .toList();
  }

}