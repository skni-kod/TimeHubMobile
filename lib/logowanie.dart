import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/userModel.dart';

class Logowanie extends StatefulWidget {
  const Logowanie({Key? key}) : super(key: key);

  @override
  State<Logowanie> createState() => _StanLogowania();
}

class _StanLogowania extends State<Logowanie> {
  final kontrolerNazwyUzytkownika = TextEditingController();
  final kontrolerHasla = TextEditingController();
  bool error = false;

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
                    padding: EdgeInsets.only(top: 200),
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
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            error
                                ? "Nieprawidłowa nazwa użytkownika lub hasło!"
                                : "",
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
                                          content: Text('Trwa logowanie...')),
                                    );
                                    await Provider.of<ModelUzytkownika>(context,
                                            listen: false)
                                        .login(kontrolerNazwyUzytkownika.text,
                                            kontrolerHasla.text);
                                    if (Provider.of<ModelUzytkownika>(context,
                                            listen: false)
                                        .zalogowany) {
                                      Navigator.pushNamed(context, "/");
                                    } else {
                                      setState(() {
                                        error = true;
                                      });
                                    }
                                  }
                                },
                                child: const Text("Zaloguj się")),
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ],
                    )))));
  }
}
