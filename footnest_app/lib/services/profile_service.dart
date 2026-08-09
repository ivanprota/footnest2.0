import '/models/user/user_profile.dart';
import '/models/common/page_response.dart';
import '/models/bet/bet.dart';
import '/models/prediction/prediction.dart';

import 'api_client.dart';

class ProfileService {

  final ApiClient apiClient;

  ProfileService(this.apiClient);

  Future<UserProfile> getProfile() async {

    final response =
        await apiClient.get("/profile");

    return UserProfile.fromJson(response);

  }

  Future<PageResponse<Bet>> getBets({int page = 0, int size = 10}) async {
    final response = await apiClient.get("/bets/my?page=$page&size=$size");

    return PageResponse.fromJson(
      response,
      Bet.fromJson,
    );
  }

  Future<PageResponse<Prediction>> getPredictions({int page = 0, int size = 10,}) async {
    final response = await apiClient.get("/predictions/my?page=$page&size=$size");

    return PageResponse.fromJson(
      response,
      Prediction.fromJson,
    );
  }

  Future<UserProfile> getUserProfile(int userId) async {
    final response = await apiClient.get("/profile/$userId");
    return UserProfile.fromJson(response);
  }

  Future<PageResponse> getUserBets(
    int userId, {
    int page = 0,
    int size = 10,
  }) async {

    final response = await apiClient.get(
      "/bets/user/$userId?page=$page&size=$size",
    );

    return PageResponse.fromJson(
      response,
      Bet.fromJson,
    );
  }

  Future<PageResponse> getUserPredictions(
    int userId, {
    int page = 0,
    int size = 10,
  }) async {

    final response = await apiClient.get(
      "/predictions/user/$userId?page=$page&size=$size",
    );

    return PageResponse.fromJson(
      response,
      Prediction.fromJson,
    );
  }

}