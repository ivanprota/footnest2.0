class Team {
  final int id;
  final String name;
  final String? logoPath;

  Team({
    required this.id,
    required this.name,
    this.logoPath,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      logoPath: json['logoPath'],
    );
  }
}