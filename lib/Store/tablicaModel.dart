import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:timehubmobile/Store/userModel.dart';

class ModelTablicy extends ChangeNotifier {
  late Tablica tablica = Tablica(id: -1, tytul: '', czyZautomatyzowane: false);
  late List<Tablica> tablice;
  late List<Kolumna> kolumny;
  late List<List<Notatka>> notatkiL;
  late List<Notatka> notatki;
  String bledy = "";
  bool ok = false;
  String get blad => bledy;

  Future getTablica(BuildContext context) async {
    final odpowiedz = await http.get(
      Uri.parse('https://projekt-timehub.herokuapp.com/api/uzytkownikTablice'),
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
    final odpowiedz = await http.post(
        Uri.parse('https://projekt-timehub.herokuapp.com/api/tablice/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        },
        body: {
          'tytul': tytul,
          'czy_zautomatyzowane': czyZautomatyzowana ? 'true' : 'false'
        });
    if (odpowiedz.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      tablica = Tablica.utworz(
          json.decode(odpowiedz.body)['id'],
          json.decode(odpowiedz.body)['tytul'],
          json.decode(odpowiedz.body)['czy_zautomatyzowane']);
      tablice.add(tablica);
      debugPrint(odpowiedz.body);
      debugPrint('tablica dodana');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(odpowiedz.body);
    }
  }

  Future getKolumny(BuildContext context, int index) async {
    final odpowiedz = await http.get(
      Uri.parse(
          'https://projekt-timehub.herokuapp.com/api/tablicaKolumny/${Provider.of<ModelTablicy>(context, listen: false).tablice[index].id}'),
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
      tablica = Tablica.utworz(
          Provider.of<ModelTablicy>(context, listen: false).tablice[index].id,
          Provider.of<ModelTablicy>(context, listen: false)
              .tablice[index]
              .tytul,
          Provider.of<ModelTablicy>(context, listen: false)
              .tablice[index]
              .czyZautomatyzowane);
      debugPrint('wczytano kolumny');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = 'Blad podczas wczytywania kolumn!';
    }
  }

  Future edytujTablice(Tablica zmiana, BuildContext context) async {
    final odpowiedz = await http.patch(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/api/tablice/${tablica.id}/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        },
        body: {
          'id': tablica.id.toString(),
          'tytul': zmiana.tytul,
          'czy_zautomatyzowane': tablica.czyZautomatyzowane! ? 'true' : 'false'
        });
    if (odpowiedz.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      int _index = tablice.indexWhere((tab) => tab.id == tablica.id);
      debugPrint(_index.toString());

      tablice.removeAt(_index);
      tablica = Tablica.utworz(
          json.decode(odpowiedz.body)['id'],
          json.decode(odpowiedz.body)['tytul'],
          json.decode(odpowiedz.body)['czy_zautomatyzowane']);
      tablice.insert(_index, tablica);
      debugPrint('Tablica edytowana');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      debugPrint(odpowiedz.body);
    }
  }

  Future usunTablice(BuildContext context) async {
    final odpowiedz = await http.delete(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/api/tablice/${tablica.id}/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        });
    if (odpowiedz.statusCode == 204) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      tablice.remove(tablica);
      debugPrint('Tablica usunieta');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      debugPrint(odpowiedz.body);
    }
  }

  Future getNotatki(BuildContext context) async {
    final odpowiedz = await http.get(
      Uri.parse('https://projekt-timehub.herokuapp.com/api/uzytkownikNotatki/'),
      headers: {
        "Authorization": 'Bearer ' +
            Provider.of<ModelUzytkownika>(context, listen: false).token,
      },
    );
    if (odpowiedz.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      notatkiL = [];
      for (var kolumna in kolumny) {
        notatki = (json.decode(odpowiedz.body) as List)
            .map((i) => Notatka.fromJson(i))
            .toList()
            .where((element) => element.kolumna == kolumna.id)
            .toList();
        notatkiL.add(notatki);
      }
      // debugPrint(notatkiL[0][0].id.toString());
      debugPrint('wczytano notatki');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = 'Blad podczas wczytywania notatek!';
    }
  }

  Future moveNotatka(
      int notatkaIndex, int nowaKolumna, BuildContext context) async {
    final odpowiedz = await http.patch(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/api/notatka/$notatkaIndex/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        },
        body: {
          "kolumna": nowaKolumna.toString()
        });
    if (odpowiedz.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      debugPrint(nowaKolumna.toString());
      debugPrint('Edytowano notatke');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      bledy = 'Blad podczas edycji notateki!';
    }
  }

  Future addNotatka(Notatka note, BuildContext context, int indexKolumna,
      int indexNotatka) async {
    final odpowiedz = await http.post(
        Uri.parse('https://projekt-timehub.herokuapp.com/api/notatka/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        },
        body: {
          "kolumna": note.kolumna.toString(),
          "data_stworzenia": note.dataStworzenia?.toIso8601String(),
          "czy_wazne": note.czyWazne.toString(),
          "zawartosc": note.zawartosc.toString(),
          "data_rozpoczecia": note.dataRozpoczecia?.toIso8601String(),
          "data_zakonczenia": note.dataZakonczenia?.toIso8601String(),
        });
    if (odpowiedz.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      notatkiL[indexKolumna][indexNotatka].id =
          json.decode(odpowiedz.body)['id'];
      debugPrint('Dodano notatke');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      debugPrint(odpowiedz.body);
      bledy = 'Blad podczas edycji notateki!';
    }
  }

  Future addKolumna(
      Kolumna kolumna, BuildContext context, int indexKolumna) async {
    final odpowiedz = await http.post(
        Uri.parse('https://projekt-timehub.herokuapp.com/api/kolumny/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        },
        body: {
          "tablica": kolumna.tablica.toString(),
          "tytul": kolumna.tytul
        });
    if (odpowiedz.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      debugPrint(odpowiedz.body);
      kolumny[indexKolumna].id = json.decode(odpowiedz.body)['id'];
      debugPrint('Dodano kolumna');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      debugPrint(odpowiedz.body);
      bledy = 'Blad podczas edycji notateki!';
    }
  }

  Future usunNotatke(BuildContext context, Notatka note) async {
    final odpowiedz = await http.delete(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/api/notatka/${note.id}/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        });
    if (odpowiedz.statusCode == 204) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      int indexKol =
          kolumny.indexWhere((element) => element.id == note.kolumna);
      notatkiL[indexKol].remove(note);
      debugPrint('Notatka usunieta');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      debugPrint(odpowiedz.body);
    }
  }

  Future edytujNotatka(Notatka zmiana, BuildContext context) async {
    final odpowiedz = await http.patch(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/api/notatka/${zmiana.id}/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        },
        body: {
          "czy_zrobione": zmiana.czyZrobione ? 'true' : 'false',
          "czy_wazne": zmiana.czyWazne ? 'true' : 'false',
          "zawartosc": zmiana.zawartosc,
          "data_rozpoczecia": zmiana.dataRozpoczecia?.toIso8601String(),
          "data_zakonczenia": zmiana.dataZakonczenia?.toIso8601String(),
        });
    if (odpowiedz.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      int _indexKol =
          kolumny.indexWhere((element) => element.id == zmiana.kolumna);
      debugPrint(_indexKol.toString());
      int _indexNot =
          notatkiL[_indexKol].indexWhere((element) => element.id == zmiana.id);
      notatkiL[_indexKol].removeAt(_indexNot);
      notatkiL[_indexKol].insert(_indexNot, zmiana);
      debugPrint('Notatka edytowana');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //  debugPrint(odpowiedz.body);
    }
  }

  Future edytujKolumna(Kolumna zmiana, BuildContext context) async {
    final odpowiedz = await http.patch(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/api/kolumny/${zmiana.id}/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        },
        body: {
          "tytul": zmiana.tytul
        });
    if (odpowiedz.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      int _indexKol = kolumny.indexWhere((element) => element.id == zmiana.id);
      debugPrint(_indexKol.toString());
      kolumny[_indexKol].tytul = zmiana.tytul;
      debugPrint('Kolumna edytowana');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //  debugPrint(odpowiedz.body);
    }
  }

  Future usunKolumna(BuildContext context, Kolumna kolumna) async {
    final odpowiedz = await http.delete(
        Uri.parse(
            'https://projekt-timehub.herokuapp.com/api/kolumny/${kolumna.id}/'),
        headers: {
          "Authorization": 'Bearer ' +
              Provider.of<ModelUzytkownika>(context, listen: false).token,
        });
    if (odpowiedz.statusCode == 204) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      int indexKol = kolumny.indexOf(kolumna);
      notatkiL.removeAt(indexKol);
      kolumny.remove(kolumna);
      debugPrint('Notatka usunieta');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      debugPrint(odpowiedz.body);
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
  bool? czyZautomatyzowane = false;

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

  factory Tablica.utworz(id, tytul, czyZautomatyzowane) {
    return Tablica(
      id: id,
      tytul: tytul,
      czyZautomatyzowane: czyZautomatyzowane,
    );
  }
}

class Kolumna {
  Kolumna({
    required this.id,
    required this.tablica,
    required this.tytul,
  });
  int id;
  int tablica;
  String tytul;

  factory Kolumna.fromJson(Map<String, dynamic> json) => Kolumna(
        id: json["id"],
        tablica: json["tablica"],
        tytul: json["tytul"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tablica": tablica,
        "tytul": tytul,
      };
}

class Notatka {
  Notatka({
    required this.id,
    required this.kolumna,
    required this.stworzonePrzez,
    required this.dataStworzenia,
    required this.czyZrobione,
    required this.czyWazne,
    required this.zawartosc,
    required this.dataRozpoczecia,
    required this.dataZakonczenia,
  });

  int id;
  int kolumna;
  int stworzonePrzez;
  DateTime? dataStworzenia;
  bool czyZrobione;
  bool czyWazne;
  String zawartosc;
  DateTime? dataRozpoczecia;
  DateTime? dataZakonczenia;

  factory Notatka.fromJson(Map<String, dynamic> json) => Notatka(
        id: json["id"],
        kolumna: json["kolumna"],
        stworzonePrzez: json["stworzone_przez"],
        dataStworzenia: DateTime.parse(json["data_stworzenia"]),
        czyZrobione: json["czy_zrobione"],
        czyWazne: json["czy_wazne"],
        zawartosc: json["zawartosc"],
        dataRozpoczecia: DateTime.parse(json["data_rozpoczecia"]),
        dataZakonczenia: DateTime.parse(json["data_zakonczenia"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kolumna": kolumna,
        "stworzone_przez": stworzonePrzez,
        "data_stworzenia": dataStworzenia?.toIso8601String(),
        "czy_zrobione": czyZrobione,
        "czy_wazne": czyWazne,
        "zawartosc": zawartosc,
        "data_rozpoczecia": dataRozpoczecia?.toIso8601String(),
        "data_zakonczenia": dataZakonczenia?.toIso8601String(),
      };
}
