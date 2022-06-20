import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timehubmobile/Store/userModel.dart';
import 'package:provider/provider.dart';

class ModelWykresu extends ChangeNotifier {
  String _bledy = "";
  WykresAktualne aktualne = const WykresAktualne(zrobione: 0.0, w_trakcie: 0.0);
  Map<String, dynamic> procentNaTablice = {};
  bool get bledy => _bledy != "";
  List<String> get nazwyTablic => procentNaTablice.keys.toList();

  Future wykresAktywneZadania(BuildContext context) async {
    final odpowiedz = await http.get(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/api/statystykaNotatkiSkonczoneAktywne7Dni/'),
        headers: {
          'Authorization': 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        });
    if (odpowiedz.statusCode == 200) {
      aktualne = WykresAktualne.utworz(json.decode(odpowiedz.body));
      (context as Element).reassemble();
    } else {
      _bledy = "Cos poszło nie tak";
    }
  }

  Future wykresProcentNaTablice(BuildContext context) async {
    final odpowiedz = await http.get(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/api/statystykaProcentowaIloscTaskowWTablicach/'),
        headers: {
          'Authorization': 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        });
    if (odpowiedz.statusCode == 200) {
      procentNaTablice = json.decode(odpowiedz.body);
      (context as Element).reassemble();
    } else {
      _bledy = "Cos poszło nie tak";
    }
  }
}

class WykresAktualne {
  final double zrobione;
  final double w_trakcie;

  const WykresAktualne({required this.zrobione, required this.w_trakcie});

  factory WykresAktualne.utworz(model) {
    return WykresAktualne(
        zrobione: double.parse(model['zrobione'].toString()),
        w_trakcie: double.parse(model['w_trakcie'].toString()));
  }
  factory WykresAktualne.usun() {
    return WykresAktualne(zrobione: 0, w_trakcie: 0);
  }
}
