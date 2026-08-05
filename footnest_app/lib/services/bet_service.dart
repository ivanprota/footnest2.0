import '/services/api_client.dart';
import '/models/bet/bet.dart';


class BetService {

  final ApiClient apiClient;

  BetService(
    this.apiClient,
  );

  Future<List<Bet>> getMyBets() async {
    final response = await apiClient.get("/bets");
    return (response as List)
        .map(
          (json)=>Bet.fromJson(json),
        )
        .toList();
  }

  Future<Bet> create(Map<String,dynamic> body) async {
    final response =
        await apiClient.post("/bets", body);

    return Bet.fromJson(response);
  }

  Future delete(int id) async {
    await apiClient.delete(
      "/bets/$id",
    );
  }

}