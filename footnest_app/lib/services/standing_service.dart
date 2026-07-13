import 'package:footnest_app/models/standing/standing.dart';

import 'api_client.dart';

class StandingService {

  final ApiClient apiClient;

  StandingService(this.apiClient);

  Future<List<Standing>> getStandings(int competitionSeasonId) async {
    final response = await apiClient.get(
      "/standings/competition-season/$competitionSeasonId",
    );

    return (response as List)
        .map(
          (json) => Standing.fromJson(json),
        )
        .toList();
  }

}