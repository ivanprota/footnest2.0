class BetSelection {

  final int id;
  final int matchId;
  final String homeTeam;
  final String awayTeam;
  final String homeLogo;
  final String awayLogo;
  final String competitionLogo;
  final String prediction;
  final double odd;
  final bool settled;
  final bool? won;

  BetSelection({
    required this.id,
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    required this.competitionLogo,
    required this.prediction,
    required this.odd,
    required this.settled,
    required this.won,
  });

  factory BetSelection.fromJson(Map<String,dynamic> json) {
    return BetSelection(
      id: json['id'],
      matchId: json['matchId'],
      homeTeam: json['homeTeam'],
      awayTeam: json['awayTeam'],
      homeLogo: json['homeLogo'],
      awayLogo: json['awayLogo'],
      competitionLogo: json['competitionLogo'],
      prediction: json['prediction'],
      odd: (json['odd'] as num)
          .toDouble(),
      settled: json['settled'] ?? false,
      won: json['won'],
    );
  }

}