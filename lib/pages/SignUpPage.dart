import 'package:flutter/material.dart';

import '../controllers/SignUpController.dart';

class SignUpPage extends StatelessWidget {
  SignUpController signupController = SignUpController();

  final _formKey = GlobalKey<FormState>();

  String artistPic = '';
  String artistEmail = '';
  String artistPassword = '';
  String artistName = '';

  Future<void> submit(
      BuildContext context, SignUpController signupController) async {
    await signupController.signUp(email: artistEmail, password: artistPassword);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          title: Text("Cadastrar"),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(24),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'E-mail'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira um e-mail válido';
                        }
                      },
                      onSaved: (value) {
                        artistEmail = value!;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(24),
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
                        artistPassword = value!;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(24),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            await submit(context, signupController);
                          }
                        },
                        child: Text("Cadastrar"))),
              ],
            ),
          )),
        ));
  }
}
