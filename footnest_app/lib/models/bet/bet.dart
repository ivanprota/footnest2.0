import 'bet_selection.dart';

class Bet {

  final int id;

  final String name;

  final DateTime createdAt;

  final String status;

  final List<BetSelection> selections;


  Bet({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.status,
    required this.selections,
  });

  factory Bet.fromJson(Map<String,dynamic> json){
    return Bet(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      selections: (json['selections'] as List)
        .map(
          (e)=>BetSelection.fromJson(e)
        ).toList(),
    );
  }

}