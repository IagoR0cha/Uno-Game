import 'package:flutter/cupertino.dart';
import 'package:uno_game/models/Game.dart';
import '../util/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Game> games = [];

  Future<List<Game>> index(String id) async {
    isLoading = true;
    games.clear();

   try {
      var url = Uri.https(Env.FIREBASE_URL, '/players/$id/games.json');

      var resp = await http.get(url);

      Map<String, dynamic> data =
          new Map<String, dynamic>.from(json.decode(resp.body));

      print(data);

      data.forEach((key, value) {
        games.add(Game(
          date: value['date'],
          numPlayers: value['numPlayers'],
          position: value['position']
        ));
      });

      isLoading = false;
      return games;
    } catch (error) {
      throw error;
    }
  }

  Future<void> create(Game gameData, String id) async {
    var url = Uri.https(Env.FIREBASE_URL, '/players/$id/games.json');

    await http.post(url, body: jsonEncode({
      'date': gameData.date,
      'position': gameData.position,
      'numPlayers': gameData.numPlayers
      }));

    notifyListeners();
  }
}