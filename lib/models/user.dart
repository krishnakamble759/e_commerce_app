class User {
  final String username;
  final String password;
  String? token;

  User({
    required this.username,
    required this.password,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      token:json ['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'token': token,
  };
}