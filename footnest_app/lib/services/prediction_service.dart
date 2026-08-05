import '/services/api_client.dart';
import '/models/prediction/prediction.dart';


class PredictionService {

  final ApiClient apiClient;

  PredictionService(
      this.apiClient
  );

  Future<List<Prediction>> getByMatch(int matchId) async {
    final response =
        await apiClient.get(
          "/predictions/match/$matchId",
        );

    return (response as List)
        .map(
          (json) =>
              Prediction.fromJson(json),
        )
        .toList();
  }

  Future<List<Prediction>> getMyPredictions() async {

    final response =
        await apiClient.get(
          "/predictions",
        );


    return (response as List)
        .map(
          (json) =>
              Prediction.fromJson(json),
        )
        .toList();

  }

  Future<Prediction> create(Map<String,dynamic> body) async {
    final response =
        await apiClient.post(
          "/predictions",
          body,
        );

    return Prediction.fromJson(response);
  }

  Future<void> delete(int id) async {
    await apiClient.delete(
      "/predictions/$id",
    );
  }

}