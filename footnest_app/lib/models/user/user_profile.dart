class UserProfile {

  final String username;
  final DateTime createdAt;
  final bool admin;
  final int totalBets;
  final int wonBets;
  final int lostBets;
  final int openBets;
  final int totalPredictions;
  final int wonPredictions;
  final int lostPredictions;
  final int openPredictions;

  UserProfile({
    required this.username,
    required this.createdAt,
    required this.admin,
    required this.totalBets,
    required this.wonBets,
    required this.lostBets,
    required this.openBets,
    required this.totalPredictions,
    required this.wonPredictions,
    required this.lostPredictions,
    required this.openPredictions,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      createdAt: DateTime.parse(json['createdAt']),
      admin: json['admin'],
      totalBets: json['totalBets'],
      wonBets: json['wonBets'],
      lostBets: json['lostBets'],
      openBets: json['openBets'],
      totalPredictions: json['totalPredictions'],
      wonPredictions: json['wonPredictions'],
      lostPredictions: json['lostPredictions'],
      openPredictions: json['openPredictions'],
    );
  }

}