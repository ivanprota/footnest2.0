class AuthResponse {

  final String token;
  final String username;
  final bool admin;


  AuthResponse({
    required this.token,
    required this.username,
    required this.admin,
  });


  factory AuthResponse.fromJson(Map<String, dynamic> json) {

    return AuthResponse(
      token: json['token'],
      username: json['username'],
      admin: json['admin'],
    );

  }

}