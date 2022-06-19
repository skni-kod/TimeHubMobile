import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ModelUzytkownika extends ChangeNotifier {
  late Uzytkownik uzytkownik = new Uzytkownik(nazwaUzytkownika: '', token: '');
  String bledy = "";

  bool get zalogowany => uzytkownik.token != '';
  String get token => uzytkownik.token;
  String get blad => bledy;

  Future login(nazwa, haslo) async {
    final odpowiedz = await http.post(
        Uri.parse('https://projekt-timehub.herokuapp.com/dj_rest_auth/login/'),
        body: {'username': nazwa, 'password': haslo});
    if (odpowiedz.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      uzytkownik =
          Uzytkownik.utworz(nazwa, jsonDecode(odpowiedz.body)["access_token"]);
      print(uzytkownik.token);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = 'Taki użytkownik nie istnieje!';
    }
  }

  Future register(nazwa, email, haslo, powtHaslo) async {
    final odpowiedz = await http.post(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/dj_rest_auth/registration/'),
        body: {
          'username': nazwa,
          'password1': haslo,
          'email': email,
          'password2': powtHaslo
        });
    if (odpowiedz.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      uzytkownik =
          Uzytkownik.utworz(nazwa, jsonDecode(odpowiedz.body)["access_token"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = "Sprawdź wpisane wartości i spróbuj ponownie!";
    }
  }

  void wyloguj() {
    print('e');
    uzytkownik = const Uzytkownik(nazwaUzytkownika: '', token: '');
  }
}

class Uzytkownik {
  final String nazwaUzytkownika;
  final String token;

  const Uzytkownik({
    required this.nazwaUzytkownika,
    required this.token,
  });

  factory Uzytkownik.utworz(nazwa, token) {
    return Uzytkownik(
      nazwaUzytkownika: nazwa,
      token: token,
    );
  }
}
