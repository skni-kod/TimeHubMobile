import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  Calendar({Key? key}) : super(key: key);

  final DateTime date = DateTime.now();

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

  void hover(PointerEvent event) {
    print(event);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime lastDayOfMonth = new DateTime(date.year, date.month + 1, 0);

    return Scaffold(
      body: Container(
          padding:
              const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
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
                                padding: const EdgeInsets.only(bottom: 10),
                                width: MediaQuery.of(context).size.width - 82,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.blue))),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      getMonthName(date.month),
                                      style: const TextStyle(fontSize: 30),
                                    )))
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
                                (int index) => Container(
                                      color: index == date.day
                                          ? Colors.blue
                                          : Colors.transparent,
                                      child: Center(
                                        child: Text(
                                          "$index",
                                          style: TextStyle(
                                            color: index == date.day
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    )),
                          ),
                        )),
                      ],
                    )),
              ]),
            ],
          )),
    );
  }
}
