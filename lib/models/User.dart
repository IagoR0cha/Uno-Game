class User {
  final String email;
  final String token;
  final DateTime expirationDate;

  const User({
    required this.email,
    required this.token,
    required this.expirationDate
  });
}