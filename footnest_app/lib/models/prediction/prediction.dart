class Prediction {

  final int id;
  final int matchId;
  final String homeTeam;
  final String awayTeam;
  final String homeLogo;
  final String awayLogo;
  final DateTime date;
  final String? kickoffTime;
  final String prediction;
  final double odd;
  final bool settled;
  final bool won;
  final String competitionLogo;



  Prediction({

    required this.id,
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    required this.date,
    required this.kickoffTime,
    required this.prediction,
    required this.odd,
    required this.settled,
    required this.won,
    required this.competitionLogo,

  });



  factory Prediction.fromJson(Map<String,dynamic> json){
    return Prediction(
      id: json['id'],
      matchId: json['matchId'],
      homeTeam: json['homeTeam'],
      awayTeam: json['awayTeam'],
      homeLogo: json['homeLogo'],
      awayLogo: json['awayLogo'],
      date: DateTime.parse(json['date']),
      kickoffTime: json['kickoffTime'],
      prediction: json['prediction'],
      odd: (json['odd'] as num).toDouble(),
      settled: json['settled'] ?? false,
      won: json['won'] ?? false,
      competitionLogo: json['competitionLogo'] ?? "",
    );
  }

  String get kickoffText {
    if(kickoffTime == null ||
       kickoffTime!.isEmpty){

      return "--:--";

    }

    return kickoffTime!.substring(0,5);
  }

  String get status {
    if(!settled) {
      return "OPEN";
    }

    return won
        ? "WON"
        : "LOST";
  }
}