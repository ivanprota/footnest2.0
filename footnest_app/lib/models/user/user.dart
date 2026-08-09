class User {

  final int id;
  final String username;
  final bool approved;
  final bool admin;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.approved,
    required this.admin,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {

    return User(
      id: json["id"],
      username: json["username"],
      approved: json["approved"],
      admin: json["admin"],
      createdAt: DateTime.parse(
        json["createdAt"],
      ),
    );
  }
}