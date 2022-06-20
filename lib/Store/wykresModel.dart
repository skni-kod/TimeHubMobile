import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timehubmobile/Store/userModel.dart';
import 'package:provider/provider.dart';

class ModelWykresu extends ChangeNotifier {
  String _bledy = "";
  WykresAktualne aktualne = WykresAktualne(zrobione: 0, w_trakcie: 0);
  Map<String, dynamic> procentNaTablice = {};
  bool get bledy => _bledy != "";
  List<String> get nazwyTablic => procentNaTablice.keys.toList();

  Future wykresAktywneZadania(BuildContext context) async {
    final odpowiedz = await http.get(
        Uri.parse(
            'http://10.0.2.2:8000/api/statystykaNotatkiSkonczoneAktywne7Dni/'),
        headers: {
          'Authorization': 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        });
    if (odpowiedz.statusCode == 200) {
      aktualne = WykresAktualne.utworz(json.decode(odpowiedz.body));
    } else {
      _bledy = "Cos poszło nie tak";
    }
  }

  Future wykresProcentNaTablice(BuildContext context) async {
    final odpowiedz = await http.get(
        Uri.parse(
            'http://10.0.2.2:8000/api/statystykaProcentowaIloscTaskowWTablicach/'),
        headers: {
          'Authorization': 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        });
    if (odpowiedz.statusCode == 200) {
      procentNaTablice = json.decode(odpowiedz.body);
    } else {
      _bledy = "Cos poszło nie tak";
    }
  }
}

class WykresAktualne {
  final int zrobione;
  final int w_trakcie;

  const WykresAktualne({required this.zrobione, required this.w_trakcie});

  factory WykresAktualne.utworz(model) {
    return WykresAktualne(
        zrobione: model['zrobione'], w_trakcie: model['w_trakcie']);
  }
  factory WykresAktualne.usun() {
    return WykresAktualne(zrobione: 0, w_trakcie: 0);
  }
}
