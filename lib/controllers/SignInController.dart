import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uno_game/models/User.dart';
import 'dart:convert';

import '../../util/env.dart';

class SignInController extends ChangeNotifier {
  SignInController() {
    persistenceUser(
        new User(email: '', token: '', expirationDate: DateTime.now()));
  }

  DateTime expirationDate = DateTime.now();
  String currentToken = '';
  bool get hasAutenticated => getToken.isNotEmpty;

  User user = User(email: '', token: '', expirationDate: DateTime.now());

  Future<void> signIn(
      {required String? email, required String? password}) async {
    try {
      var url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:signInWithPassword',
        {'key': Env.API_KEY},
      );

      final resp = await http.post(
        url,
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}),
      );

      final respAuth = json.decode(resp.body);
      if (respAuth['error'] != null) {
        throw Exception(respAuth['error']);
      } else {
        currentToken = respAuth['idToken'];
        expirationDate = DateTime.now()
            .add(Duration(seconds: int.parse(respAuth['expiresIn'])));

        user = new User(
            email: email!, token: currentToken, expirationDate: expirationDate);
        saveUserData(user);
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> saveUserData(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('email', user.email);
    prefs.setString('token', user.token);
    prefs.setString('expirationDate', user.expirationDate.toString());

    notifyListeners();
  }

  Future<void> persistenceUser(User currentUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (currentUser.token.isNotEmpty) {
      user = currentUser;
    }

    if (prefs.getString('token') != null) {
      user = User(
        email: prefs.getString('email')!,
        token: prefs.getString('token')!,
        expirationDate: DateFormat("yyyy-MM-dd hh:mm:ss")
            .parse(prefs.getString('expirationDate')!),
      );

      currentToken = user.token;
    }
    notifyListeners();
  }

  String get getToken {
    if (user.token.isNotEmpty && user.expirationDate.isAfter(DateTime.now())) {
      return user.token;
    } else {
      return '';
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('email');
    prefs.remove('token');
    prefs.remove('expirationDate');

    user = new User(email: '', token: '', expirationDate: DateTime.now());
    notifyListeners();
  }
}
