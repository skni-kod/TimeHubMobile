import 'package:flutter/material.dart';
import 'package:timehubmobile/Components/note.dart';
import 'package:timehubmobile/Store/tasksModel.dart';
import 'package:provider/provider.dart';

class TasksMini extends StatefulWidget {
  const TasksMini({Key? key}) : super(key: key);

  @override
  State<TasksMini> createState() => _NotesMiniState();
}

class _NotesMiniState extends State<TasksMini> {
  @override
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

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: MediaQuery.of(context).size.height - 330,
            width: MediaQuery.of(context).size.width - 80,
            child: Column(children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.blue))),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 82,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            DateTime.now().day.toString() +
                                " " +
                                getMonthName(DateTime.now().month),
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 18),
                          )))
                ],
              ),
              Expanded(
                child: Consumer<TasksModel>(
                    builder: ((context, value, child) => ListView(
                          children: List.generate(
                              value.count,
                              (index) => Note(
                                    note: value.items[index]["value"],
                                    id: value.items[index]["id"],
                                  )),
                        ))),
              )
            ]),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          ),
        ),
        Positioned.fill(
            top: 5,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 30,
                height: 30,
                child: FloatingActionButton(
                    mini: true,
                    onPressed: () => Navigator.pushNamed(context, "/notes"),
                    child: const Center(
                      child: Icon(
                        Icons.expand_less,
                        size: 30,
                      ),
                    )),
              ),
            )),
      ],
    );
  }
}
