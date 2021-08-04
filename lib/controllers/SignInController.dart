import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../util/env.dart';

class SignInController extends ChangeNotifier {
  DateTime expirationDate = DateTime.now();
  String currentToken = '';

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
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

     final respAuth = json.decode(resp.body);
     if (respAuth['error'] != null) {
       throw Exception(respAuth['error']);
     } else {
       currentToken = respAuth['idToken'];
       expirationDate = DateTime.now().add(Duration(seconds: int.parse(respAuth.expiresIn)));
     }
     notifyListeners();

    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
