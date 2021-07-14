import './Game.dart';

class Player {
  final String? id;
  final String name;
  final String contact;
  final String email;
  final String password;
  final List<Game>? games;

  const Player({
    this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.password,
    this.games,
  });
}