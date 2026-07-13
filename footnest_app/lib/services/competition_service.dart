import '/models/competition/competition.dart';
import 'api_client.dart';

class CompetitionService {

  final ApiClient apiClient;

  CompetitionService(this.apiClient);

  Future<List<Competition>> getCompetitions() async {
    final response = await apiClient.get('/competitions');

    return (response as List)
        .map((json) => Competition.fromJson(json))
        .toList();

  }

  Future<Competition> getCompetitionById(int id) async {

    final response = await apiClient.get(
      '/competitions/$id',
    );

    return Competition.fromJson(response);
  }

}