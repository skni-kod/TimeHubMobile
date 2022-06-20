import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/userModel.dart';

class ModelNotatek extends ChangeNotifier {
  List<Notatka> _notatki = [];
  List<Notatka> notatkiZDnia = [];
  String bledy = "";
  Future pobierz(BuildContext context, String miesiac, String rok) async {
    _notatki = [];
    final odpowiedz = await http.post(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/api/uzytkownikNotatkiMiesiacRok/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        },
        body: {
          'miesiac': miesiac.toString(),
          'rok': rok.toString()
        });
    if (odpowiedz.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      for (var notatka in jsonDecode(odpowiedz.body)) {
        _notatki.add(Notatka.stworz(notatka['notatka']));
      }
      (context as Element).reassemble();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = 'Taki użytkownik nie istnieje!';
    }
  }

  Future filtrujNotatki(
      BuildContext context, String miesiac, String rok, int dzien) async {
    await pobierz(context, miesiac, rok);
    notatkiZDnia = [];
    DateTime wybranyDzien = DateTime.parse(rok +
        '-' +
        (int.parse(miesiac) < 10 ? '0' + miesiac : miesiac) +
        '-' +
        (dzien < 10 ? '0' + dzien.toString() : dzien.toString()));
    for (Notatka notatka in _notatki) {
      if (wybranyDzien.day <= notatka.dataZakonczenia.day &&
          wybranyDzien.day >= notatka.dataRozpoczecia.day) {
        notatkiZDnia.add(notatka);
      }
    }
  }
}

class Notatka {
  int id;
  int kolumna;
  int stworzonePrzez;
  DateTime dataStworzenia;
  bool czyZrobione;
  bool czyWazne;
  String zawartosc;
  DateTime dataRozpoczecia;
  DateTime dataZakonczenia;

  Notatka(
      {required this.id,
      required this.kolumna,
      required this.stworzonePrzez,
      required this.dataStworzenia,
      required this.czyZrobione,
      required this.czyWazne,
      required this.zawartosc,
      required this.dataRozpoczecia,
      required this.dataZakonczenia});

  factory Notatka.stworz(model) {
    return Notatka(
      id: model['id'],
      kolumna: model['kolumna'],
      stworzonePrzez: model['stworzone_przez'],
      dataStworzenia: DateTime.parse(model['data_stworzenia']),
      czyZrobione: model['czy_zrobione'],
      czyWazne: model['czy_wazne'],
      zawartosc: model['zawartosc'],
      dataRozpoczecia: DateTime.parse(model['data_rozpoczecia']),
      dataZakonczenia: DateTime.parse(model['data_zakonczenia']),
    );
  }
}
