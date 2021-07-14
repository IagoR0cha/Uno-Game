import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uno_game/controllers/GameConttroler.dart';
import 'package:uno_game/models/Game.dart';
import 'package:uno_game/models/Player.dart';

class GamesPage extends StatefulWidget {
  final Player currentPlayer;
  GamesPage({ required this.currentPlayer });

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  final _formKey = GlobalKey<FormState>();

  String gameData = '';
  int gamePosition = 0;
  int gameNumPlayer = 0;
  List<Game> currentList = [];

  List<Game> getGames(GameController gameController) {
    List<Game> currentList = [];
    gameController.index(widget.currentPlayer.id!).then((value) => currentList = value);


    print(currentList.length);
    this.currentList = currentList;
    return currentList;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(builder: (_, gameController, __)  {
      return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(widget.currentPlayer.name),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: getGames(gameController).length,
          itemBuilder: (context, index){
            return Card(
              elevation: 3,
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    currentList[index].date,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentList[index].position.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentList[index].numPlayers.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actions: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Cadastrar Jogador",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Data do Jogo'),
                            onSaved: (value) {
                              gameData = value!;
                            },
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Posição do Jogo'),
                            onSaved: (value) {
                              gamePosition = int.parse(value!);
                            },
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Número de Jogadores'),
                            onSaved: (value) {
                              gameNumPlayer = int.parse(value!);
                            },
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async {
                              _formKey.currentState!.save();

                              Game playerCurrent = new Game(
                                date: gameData,
                                numPlayers: gameNumPlayer,
                                position: gamePosition
                              );
                              await gameController.create(playerCurrent, widget.currentPlayer.id!);
                              ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                  content: Text(
                                    'Salvo com sucesso!'
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: Text('Cadastrar Jogador'),
                          ),
                        )
                      ]
                    ),
                  )
                ],
              );
            }
          );
        },
      ),
    );
  });
  }

}