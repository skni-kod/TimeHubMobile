import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/notatkaModel.dart';

class Calendar extends StatefulWidget {
  Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _stanKalendarza();
}

class _stanKalendarza extends State<Calendar> {
  String getMonthName(month) {
    switch (month) {
      case 1:
        return "Styczen";
      case 2:
        return "Luty";
      case 3:
        return "Marzec";
      case 4:
        return "Kwiecien";
      case 5:
        return "Maj";
      case 6:
        return "Czerwiec";
      case 7:
        return "Lipiec";
      case 8:
        return "Sierpień";
      case 9:
        return "Wrzesień";
      case 10:
        return "Październik";
      case 11:
        return "Listopad";
      case 12:
        return "Grudzień";
      default:
        return "Błędny miesiąc";
    }
  }

  int dzien = DateTime.now().day - 1;
  int miesiac = DateTime.now().month;
  int rok = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    final DateTime lastDayOfMonth = new DateTime(rok, miesiac + 1, 0);
    List<Notatka> notatki = [];
    void pobierzNotatki() {
      Provider.of<ModelNotatek>(context, listen: false).filtrujNotatki(
          context, miesiac.toString(), rok.toString(), dzien + 1);
      notatki = Provider.of<ModelNotatek>(context, listen: false).notatkiZDnia;
    }

    pobierzNotatki();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalendarz"),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        height: 300,
                        width: MediaQuery.of(context).size.width - 80,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width - 82,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.blue))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: (() => setState(() {
                                                  if (miesiac != 1) {
                                                    miesiac--;
                                                  } else {
                                                    miesiac = 12;
                                                    rok--;
                                                  }
                                                  pobierzNotatki();
                                                })),
                                            child: const Icon(
                                              Icons.arrow_left,
                                              size: 35,
                                            ),
                                          ),
                                          Text(
                                            getMonthName(miesiac) +
                                                " " +
                                                rok.toString(),
                                            style:
                                                const TextStyle(fontSize: 25),
                                          ),
                                          GestureDetector(
                                            onTap: (() => setState(() {
                                                  if (miesiac != 12) {
                                                    miesiac++;
                                                  } else {
                                                    miesiac = 1;
                                                    rok++;
                                                  }
                                                  pobierzNotatki();
                                                })),
                                            child: const Icon(
                                              Icons.arrow_right,
                                              size: 35,
                                            ),
                                          ),
                                        ]))
                              ],
                            ),
                            Center(
                                child: Align(
                              alignment: Alignment.bottomCenter,
                              child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 7,
                                children: List.generate(
                                    lastDayOfMonth.day,
                                    (int index) => GestureDetector(
                                        onTap: (() => setState(() {
                                              dzien = index;
                                            })),
                                        child: Container(
                                          color: index == dzien
                                              ? Colors.blue
                                              : Colors.transparent,
                                          child: Center(
                                            child: Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                color: index == dzien
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ))),
                              ),
                            )),
                          ],
                        )),
                  ]),
                ],
              )),
          ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              physics: const ClampingScrollPhysics(),
              children: [
                Container(
                    height: 260, // give it a fixed height constraint
                    // child ListView
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    child: Column(children: [
                      Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Center(
                              child: Text((dzien + 1).toString() +
                                  ' ' +
                                  getMonthName(miesiac))),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.blue)))),
                      Expanded(
                        child: notatki.isNotEmpty
                            ? ListView.builder(
                                itemCount: notatki.length,
                                itemBuilder: (_, i) {
                                  return Container(
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.blue),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: ListTile(
                                        leading: const Icon(Icons.note),
                                        title: Text(notatki[i].zawartosc),
                                        textColor: notatki[i].czyWazne
                                            ? Colors.red
                                            : Colors.black,
                                      ));
                                },
                              )
                            : const Center(
                                child: Text("Brak zadań"),
                              ),
                      )
                    ])),
              ])
        ],
      ),
    );
  }
}
