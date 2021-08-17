import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uno_game/controllers/SignInController.dart';

import '../pages/SignInPage.dart';
import '../pages/HomePage.dart';

class PercistenceValidation extends StatefulWidget {

  @override
  Validated createState() => Validated();
}

class Validated extends State<PercistenceValidation> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SignInController>(
      builder: (_,login,__) {
        if (login.hasAutenticated) {
          return HomePage();
        } else {
          return SignInPage();
        }
      }
    );
  }

}