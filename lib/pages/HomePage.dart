import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uno_game/controllers/PlayersController.dart';
import 'package:uno_game/models/Player.dart';

// import '../mockdata/mockdata.dart';
import './GamesPage.dart';

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  String playerName = '';
  String playerEmail = '';
  String playerPassword = '';
  String playerContact = '';

  @override
  Widget build(BuildContext context) {

    return Consumer<PlayersController>(
      builder: (_, playersController, __) {
        return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(title: Text('Jogadores'), elevation: 0),
      body: Container(
        padding: EdgeInsets.all(24),
        child: ListView.builder(
          itemCount: playersController.players.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GamesPage(currentPlayer: playersController.players[index],),
                  )
                );
              },
              child: Card(
                elevation: 3,
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                child: Container(
                  height: 120,
                  child: Column(children: [
                    const SizedBox(height: 15),
                    Expanded(child: Text(
                      playersController.players[index].name,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        letterSpacing: 2
                      ),
                    )),
                    Expanded(child: Text(
                      playersController.players[index].email,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        letterSpacing: 1
                      ),
                    )),
                    Expanded(child: Text(
                      playersController.players[index].contact,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        letterSpacing: 1
                      ),
                    )),
                  ],),
                ),
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
                            decoration: InputDecoration(labelText: 'Name'),
                            onSaved: (value) {
                              playerName = value!;
                            },
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Email'),
                            onSaved: (value) {
                              playerEmail = value!;
                            },
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Senha'),
                            onSaved: (value) {
                              playerPassword = value!;
                            },
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Contato'),
                            onSaved: (value) {
                              playerContact = value!;
                            },
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async {
                              _formKey.currentState!.save();

                              Player playerCurrent = new Player(
                                name: playerName,
                                email: playerEmail,
                                password: playerPassword,
                                contact: playerContact,
                              );
                              await playersController.create(playerCurrent);
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
      },
    );
  }
}