import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/tablicaModel.dart';
import 'package:timehubmobile/Store/userModel.dart';
import 'package:timehubmobile/widokTablicy.dart';
import 'package:http/http.dart' as http;

String kolumnaToJson(List<Kolumna> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelKolumny extends ChangeNotifier {
  late List<Kolumna> kolumny;
  String bledy = "";
  bool ok = false;
  String get blad => bledy;

  Future getKolumny(BuildContext context, int index) async {
    final odpowiedz = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/tablicaKolumny/${Provider.of<ModelTablicy>(context, listen: false).tablice[index].id}'),
      headers: {
        "Authorization": 'Bearer ' +
            Provider.of<ModelUzytkownika>(context, listen: false).token,
      },
    );
    if (odpowiedz.statusCode == 200) {
      final odpowiedzJson = jsonDecode(odpowiedz.body);
      // If the server did return a 200 OK response,
      // then parse the JSON.

      kolumny = (json.decode(odpowiedz.body) as List)
          .map((i) => Kolumna.fromJson(i))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = 'Blad podczas wczytywania kolumn!';
    }
  }
}

class Kolumna {
  Kolumna({
    required this.tablica,
    required this.tytul,
  });

  int tablica;
  String tytul;

  factory Kolumna.fromJson(Map<String, dynamic> json) => Kolumna(
        tablica: json["tablica"],
        tytul: json["tytul"],
      );

  Map<String, dynamic> toJson() => {
        "tablica": tablica,
        "tytul": tytul,
      };
}
