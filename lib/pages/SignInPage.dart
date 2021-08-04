import 'package:flutter/material.dart';
import 'package:uno_game/Pages/SignUpPage.dart';

import '../controllers/SignInController.dart';

import '../Pages/HomePage.dart';
import '../Pages/SignUpPage.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignInController signInController = SignInController();

  String? email;
  String? password;

  Future<void> submit(BuildContext context, SignInController signInController) async {
    try {
      await signInController.signIn(email: email, password: password);

      if (signInController.currentToken.isNotEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return HomePage();
        }));
      }
    }catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text("Entrar"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
          child: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'E-mail'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira um e-mail válido';
                        }
                      },
                      onSaved: (value) {
                        email = value!;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Senha'),
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira uma senha';
                        }
                      },
                      onSaved: (value) {
                        password = value!;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(24),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                          }

                          await submit(context, signInController);
                        },
                        child: Text("Entrar")
                  )),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) =>  SignUpPage()
                        ));
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Cadastrar',
                        style: TextStyle(color: Colors.blue),
                      )),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
