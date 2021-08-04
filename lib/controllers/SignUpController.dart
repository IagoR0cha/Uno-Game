import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../util/env.dart';

class SignUpController {
  Future<void> signUp(
      {required String? email, required String? password}) async {
    try {

      var url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:signUp',
        {'key': Env.API_KEY},
      );

      final res = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

      print(res.body);

    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
