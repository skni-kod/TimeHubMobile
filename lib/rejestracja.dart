import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/userModel.dart';

class Rejestracja extends StatefulWidget {
  const Rejestracja({Key? key}) : super(key: key);

  @override
  State<Rejestracja> createState() => _StanRejestracji();
}

class _StanRejestracji extends State<Rejestracja> {
  final kontrolerNazwyUzytkownika = TextEditingController();
  final kontrolerEmail = TextEditingController();
  final kontrolerHasla = TextEditingController();
  final kontrolerHaslaPowt = TextEditingController();
  String error = "";
  @override
  Widget build(BuildContext context) {
    final _kluczFormularza = GlobalKey<FormState>();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _kluczFormularza,
                child: Container(
                    padding: EdgeInsets.only(top: 150),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: TextFormField(
                            controller: kontrolerNazwyUzytkownika,
                            validator: (tresc) {
                              if (tresc == null || tresc.isEmpty) {
                                return "Musisz wypełnić to pole!";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Wpisz swój login',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: TextFormField(
                            controller: kontrolerEmail,
                            validator: (tresc) {
                              if (tresc == null || tresc.isEmpty) {
                                return "Musisz wypełnić to pole!";
                              }
                              if (!RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                  .hasMatch(tresc)) {
                                return "Nieprawidłowy email!";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Wpisz swój email',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: TextFormField(
                            controller: kontrolerHasla,
                            validator: (tresc) {
                              if (tresc == null || tresc.isEmpty) {
                                return "Musisz wypełnić to pole!";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Wpisz swoje hasło',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: TextFormField(
                            controller: kontrolerHaslaPowt,
                            validator: (tresc) {
                              if (tresc == null || tresc.isEmpty) {
                                return "Musisz wypełnić to pole!";
                              }
                              if (tresc != kontrolerHasla.text) {
                                return "Hasła muszą być takie same!";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Powtórz hasło',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: Align(
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_kluczFormularza.currentState!
                                      .validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Trwa rejestracja...')),
                                    );
                                    await Provider.of<ModelUzytkownika>(context,
                                            listen: false)
                                        .register(
                                            kontrolerNazwyUzytkownika.text,
                                            kontrolerEmail.text,
                                            kontrolerHasla.text,
                                            kontrolerHaslaPowt.text);
                                    if (Provider.of<ModelUzytkownika>(context,
                                            listen: false)
                                        .zalogowany) {
                                      Navigator.pushNamed(context, "/");
                                    } else {
                                      setState(() {
                                        error = Provider.of<ModelUzytkownika>(
                                                context,
                                                listen: false)
                                            .blad;
                                      });
                                    }
                                  }
                                },
                                child: const Text("Zarejestruj się")),
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ],
                    )))));
  }
}
