class MatchTeamStatistics {
  final double? xg;
  final double? possession;
  final int? totalShots;
  final int? shotsOnTarget;
  final int? bigChances;
  final int? corners;
  final int? yellowCards;
  final int? redCards;
  final int? fouls;

  MatchTeamStatistics({
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

  factory MatchTeamStatistics.fromJson(Map<String, dynamic> json) {
    return MatchTeamStatistics(
      xg: (json['xg'] as num?)?.toDouble(),
      possession: (json['possession'] as num?)?.toDouble(),
      totalShots: json['totalShots'],
      shotsOnTarget: json['shotsOnTarget'],
      bigChances: json['bigChances'],
      corners: json['corners'],
      yellowCards: json['yellowCards'],
      redCards: json['redCards'],
      fouls: json['fouls'],
    );
  }
}