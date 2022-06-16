import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/kolumnaModel.dart';
import 'dart:convert';
import 'package:timehubmobile/Store/userModel.dart';

class ModelTablicy extends ChangeNotifier {
  late Tablica tablica = Tablica(tytul: '', czyZautomatyzowane: false);
  late List<Tablica> tablice;
  late List<Kolumna> kolumny;
  String bledy = "";
  bool ok = false;
  String get blad => bledy;

  Future getTablica(BuildContext context) async {
    final odpowiedz = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/uzytkownikTablice'),
      headers: {
        "Authorization": 'Bearer ' +
            Provider.of<ModelUzytkownika>(context, listen: false).token,
      },
    );
    if (odpowiedz.statusCode == 200) {
      final odpowiedzJson = jsonDecode(odpowiedz.body);
      // If the server did return a 200 OK response,
      // then parse the JSON.

      tablice = (json.decode(odpowiedz.body) as List)
          .map((i) => Tablica.fromJson(i))
          .toList();
      ok = true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = 'Blad podczas tworzenia tablicy!';
    }
  }

  Future dodajTablice(tytul, czyZautomatyzowana, BuildContext context) async {
    final odpowiedz = await http
        .post(Uri.parse('http://10.0.2.2:8000/api/tablice/'), headers: {
      "Authorization": 'Bearer ' +
          Provider.of<ModelUzytkownika>(context, listen: false).token,
    }, body: {
      'tytul': tytul,
      'czy_zautomatyzowane': czyZautomatyzowana
    });
    if (odpowiedz.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      tablica = Tablica.utworz(json.decode(odpowiedz.body)['tytul'],
          json.decode(odpowiedz.body)['czyZautomatyzowana']);
      tablice.add(tablica);
      print(odpowiedz.body);
      print('tablica dodana');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(odpowiedz.body);
    }
  }

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
      // If the server did return a 200 OK response,
      // then parse the JSON.

      kolumny = (json.decode(odpowiedz.body) as List)
          .map((i) => Kolumna.fromJson(i))
          .toList();
      print('wczytano kolumny');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = 'Blad podczas wczytywania kolumn!';
    }
  }
}

class Tablice {
  int? user;
  Tablica? tablica;
  String? rolaWTablicy;

  Tablice({this.user, this.tablica, this.rolaWTablicy});

  Tablice.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    tablica =
        json['tablica'] != null ? new Tablica.fromJson(json['tablica']) : null;
    rolaWTablicy = json['rola_w_tablicy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    if (this.tablica != null) {
      data['tablica'] = this.tablica!.toJson();
    }
    data['rola_w_tablicy'] = this.rolaWTablicy;
    return data;
  }
}

class Tablica {
  int? id;
  String? tytul;
  bool? czyZautomatyzowane;

  Tablica({this.id, this.tytul, this.czyZautomatyzowane});

  Tablica.fromJson(Map<String, dynamic> json) {
    id = json['tablica']['id'];
    tytul = json['tablica']['tytul'];
    czyZautomatyzowane = json['tablica']['czy_zautomatyzowane'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tytul'] = this.tytul;
    data['czy_zautomatyzowane'] = this.czyZautomatyzowane;
    return data;
  }

  factory Tablica.utworz(tytul, czyZautomatyzowane) {
    return Tablica(
      tytul: tytul,
      czyZautomatyzowane: czyZautomatyzowane,
    );
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
