class MatchStatistics {

  final int id;

  final int teamId;
  final String teamName;
  final String teamLogo;

  final double? xg;
  final double? possession;

  final int? totalShots;
  final int? shotsOnTarget;
  final int? bigChances;
  final int? corners;

  final int? yellowCards;
  final int? redCards;
  final int? fouls;


  MatchStatistics({
    required this.id,
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
    this.xg,
    this.possession,
    this.totalShots,
    this.shotsOnTarget,
    this.bigChances,
    this.corners,
    this.yellowCards,
    this.redCards,
    this.fouls,
  });


  factory MatchStatistics.fromJson(
      Map<String,dynamic> json
  ) {

    return MatchStatistics(
      id: json["id"],
      teamId: json["teamId"],
      teamName: json["teamName"],
      teamLogo: json["teamLogo"],
      xg: json["xg"],
      possession: json["possession"],
      totalShots: json["totalShots"],
      shotsOnTarget: json["shotsOnTarget"],
      bigChances: json["bigChances"],
      corners: json["corners"],
      yellowCards: json["yellowCards"],
      redCards: json["redCards"],
      fouls: json["fouls"],
    );

  }

}