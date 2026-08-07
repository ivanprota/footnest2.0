import '/models/user/user_profile.dart';
import '/models/common/page_response.dart';
import '/models/bet/bet.dart';
import '/models/prediction/prediction.dart';

import 'api_client.dart';

class ProfileService {

  final ApiClient api;

  ProfileService(this.api);

  Future<UserProfile> getProfile() async {

    final response =
        await api.get("/profile");

    return UserProfile.fromJson(response);

  }

  Future<PageResponse<Bet>> getBets({
    int page = 0,
    int size = 10,
  }) async {

    final response =
        await api.get(
          "/bets/my?page=$page&size=$size",
        );

    return PageResponse.fromJson(
      response,
      Bet.fromJson,
    );

  }

  Future<PageResponse<Prediction>> getPredictions({
    int page = 0,
    int size = 10,
  }) async {

    final response =
        await api.get(
          "/predictions/my?page=$page&size=$size",
        );

    return PageResponse.fromJson(
      response,
      Prediction.fromJson,
    );

  }

}