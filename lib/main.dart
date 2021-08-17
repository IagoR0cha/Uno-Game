import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uno_game/controllers/GameConttroler.dart';
import 'package:uno_game/controllers/PlayersController.dart';
import 'package:uno_game/controllers/SignInController.dart';
import 'package:uno_game/pages/SignInPage.dart';
import 'package:uno_game/util/PersistenceValidation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PlayersController(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => GameController(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => SignInController(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        title: 'UNO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PersistenceValidation(),
      ),
    );
  }
}
