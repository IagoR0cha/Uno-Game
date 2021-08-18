import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uno_game/controllers/GameConttroler.dart';
import 'package:uno_game/controllers/PlayersController.dart';
import 'package:uno_game/controllers/SignInController.dart';
import 'package:uno_game/models/Player.dart';
import 'package:uno_game/pages/GamesPage.dart';
import 'package:uno_game/pages/SignInPage.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  String playerName = '';
  String playerEmail = '';
  String playerPassword = '';
  String playerContact = '';

  @override
  Widget build(BuildContext context) {
    return Consumer3<PlayersController, GameController, SignInController>(
      builder: (_, playerController, gameController, signInController, __) {
        return Scaffold(
          backgroundColor: Color(0xFFEEEEEE),
          appBar: AppBar(
            title: Text('Jogadores'),
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () async {
                    await _picker.pickImage(source: ImageSource.camera);
                  },
                  icon: Icon(Icons.camera, color: Colors.white)),
              IconButton(
                  onPressed: () {
                    signInController.signOut();

                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (_) {
                      return SignInPage();
                    }));
                  },
                  icon: Icon(Icons.exit_to_app, color: Colors.white))
            ],
          ),
          body: Container(
            padding: EdgeInsets.all(24),
            child: ListView.builder(
              itemCount: playerController.players.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    gameController.index(playerController.players[index].id!);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GamesPage(
                          currentPlayer: playerController.players[index]),
                    ));
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      height: 150,
                      child: Column(children: [
                        Expanded(
                            child: Text(
                          playerController.players[index].name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              letterSpacing: 1),
                        )),
                        Expanded(
                            child: Text(
                          playerController.players[index].email,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              letterSpacing: 1),
                        )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                child: const Text('Editar',
                                    style: TextStyle(color: Colors.white)),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          actions: [
                                            Form(
                                              key: _formKey,
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Editar Jogador",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Nome'),
                                                          initialValue:
                                                              playerController
                                                                  .players[
                                                                      index]
                                                                  .name,
                                                          onSaved: (value) {
                                                            playerName = value!;
                                                          },
                                                        )),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Email'),
                                                          initialValue:
                                                              playerController
                                                                  .players[
                                                                      index]
                                                                  .email,
                                                          onSaved: (value) {
                                                            playerEmail =
                                                                value!;
                                                          },
                                                        )),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Senha'),
                                                          initialValue:
                                                              playerController
                                                                  .players[
                                                                      index]
                                                                  .password,
                                                          onSaved: (value) {
                                                            playerPassword =
                                                                value!;
                                                          },
                                                        )),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Contato'),
                                                          initialValue:
                                                              playerController
                                                                  .players[
                                                                      index]
                                                                  .contact,
                                                          onSaved: (value) {
                                                            playerContact =
                                                                value!;
                                                          },
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          _formKey.currentState!
                                                              .save();

                                                          Player playerCurrent =
                                                              new Player(
                                                                  name:
                                                                      playerName,
                                                                  email:
                                                                      playerEmail,
                                                                  password:
                                                                      playerPassword,
                                                                  contact:
                                                                      playerContact);
                                                          await playerController
                                                              .edit(
                                                                  playerController
                                                                      .players[
                                                                          index]
                                                                      .id!,
                                                                  playerCurrent);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Salvo com sucesso!'),
                                                            ),
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            'Editar Jogador'),
                                                      ),
                                                    )
                                                  ]),
                                            )
                                          ],
                                        );
                                      });
                                },
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                child: const Text('Deletar',
                                    style: TextStyle(color: Colors.white)),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  await playerController.delete(
                                      playerController.players[index].id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Jogador deletado!')));
                                },
                              ),
                            ]),
                      ]),
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
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
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
                                  decoration:
                                      InputDecoration(labelText: 'Name'),
                                  onSaved: (value) {
                                    playerName = value!;
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Email'),
                                  onSaved: (value) {
                                    playerEmail = value!;
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Senha'),
                                  onSaved: (value) {
                                    playerPassword = value!;
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Contato'),
                                  onSaved: (value) {
                                    playerContact = value!;
                                  },
                                )),
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
                                  await playerController.create(playerCurrent);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Salvo com sucesso!'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text('Cadastrar Jogador'),
                              ),
                            )
                          ]),
                        )
                      ],
                    );
                  });
            },
          ),
        );
      },
    );
  }
}
