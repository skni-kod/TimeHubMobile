import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ModelUzytkownika extends ChangeNotifier {
  late Uzytkownik uzytkownik = new Uzytkownik.usun();
  String bledy = "";

  bool get zalogowany => uzytkownik.token != '';
  String get token => uzytkownik.token;
  String get blad => bledy;

  Future login(nazwa, haslo) async {
    final odpowiedz = await http.post(
        Uri.parse('http://10.0.2.2:8000/dj_rest_auth/login/'),
        body: {'username': nazwa, 'password': haslo});
    if (odpowiedz.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      uzytkownik = Uzytkownik.utworz(jsonDecode(odpowiedz.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = 'Taki użytkownik nie istnieje!';
    }
  }

  Future register(nazwa, email, haslo, powtHaslo) async {
    final odpowiedz = await http.post(
        Uri.parse('http://10.0.2.2:8000/dj_rest_auth/registration/'),
        body: {
          'username': nazwa,
          'password1': haslo,
          'email': email,
          'password2': powtHaslo
        });
    if (odpowiedz.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      uzytkownik = Uzytkownik.utworz(jsonDecode(odpowiedz.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = "Sprawdź wpisane wartości i spróbuj ponownie!";
    }
  }

  void wyloguj() {
    uzytkownik = Uzytkownik.usun();
  }
}

class Uzytkownik {
  final int pk;
  final String username;
  final String email;
  final String first_name;
  final String last_name;
  final String token;

  const Uzytkownik(
      {required this.token,
      required this.pk,
      required this.username,
      required this.email,
      required this.first_name,
      required this.last_name});

  factory Uzytkownik.utworz(model) {
    return Uzytkownik(
        token: model['access_token'],
        username: model['user']['username'],
        pk: model['user']['pk'],
        email: model['user']['email'],
        first_name: model['user']['first_name'],
        last_name: model['user']['last_name']);
  }
  factory Uzytkownik.usun() {
    return Uzytkownik(
        token: '',
        username: '',
        pk: 0,
        email: '',
        first_name: '',
        last_name: '');
  }
}
