import 'package:flutter/cupertino.dart';
import 'package:uno_game/models/Player.dart';
import '../util/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlayersController extends ChangeNotifier {
  PlayersController() {
    index();
  }

  List<Player> players = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> index() async {
    isLoading = true;
    players.clear();

   try {
      var url = Uri.https(Env.FIREBASE_URL, '/players.json');

      var resp = await http.get(url);

      print(resp.body);

      Map<String, dynamic> data =
          new Map<String, dynamic>.from(json.decode(resp.body));

      data.forEach((key, value) {
        players.add(Player(
          id: key,
          name: value['name'],
          password: value['password'],
          contact: value['contact'],
          email: value['email'],
        ));
      });

      isLoading = false;
    } catch (error) {
      throw error;
    }
  }

  Future<void> create(Player playerData) async {
    var url = Uri.https(Env.FIREBASE_URL, '/players.json');

    await http.post(url, body: jsonEncode({
      'name': playerData.name,
      'email': playerData.email,
      'password': playerData.password,
      'contact': playerData.contact,
      }));

    index();
    notifyListeners();
  }

  Future<void> delete(String playerId) async {
  var url = Uri.https(Env.FIREBASE_URL, '/players/$playerId.json');

    try{
      await http.delete(url);
      index();
      notifyListeners();
    } catch(e) {
    }
  }

  Future<void> edit(String artistId, Player playerData) async {
    var url = Uri.https(Env.FIREBASE_URL, '/artists/$artistId.json');

    try {
      await http.put(url, body: jsonEncode({
        'name': playerData.name,
        'email': playerData.email,
        'password': playerData.password,
        'contact': playerData.contact,
      }));
      index();
      notifyListeners();
    }catch(e) {
    }
  }
}