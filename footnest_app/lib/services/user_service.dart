import '/services/api_client.dart';
import '/models/user/user.dart';

class UserService {

  final ApiClient apiClient;

  UserService(this.apiClient);

  Future<List<User>> getUsers() async {
    final response = await apiClient.get("/users");

    return (response as List)
        .map(
          (json) => User.fromJson(json),
        )
        .toList();
  }

  Future<User> getUser(int id) async {
    final response = await apiClient.get("/users/$id");
    return User.fromJson(response);
  }

  Future<User> updateApproval(int id, bool approved) async {
    final response =
        await apiClient.put(
          "/users/$id/approval",
          {
            "approved": approved,
          },
        );

    return User.fromJson(response);
  }
}