import 'package:flutter/material.dart';
import 'package:timehubmobile/Components/note.dart';
import 'package:timehubmobile/Store/notemodel.dart';
import 'package:provider/provider.dart';

class NotesMini extends StatefulWidget {
  const NotesMini({Key? key}) : super(key: key);

  @override
  State<NotesMini> createState() => _NotesMiniState();
}

class _NotesMiniState extends State<NotesMini> {
  @override
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
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Notatki",
                            style: TextStyle(color: Colors.blue),
                          )))
                ],
              ),
              Expanded(
                child: Consumer<NoteModel>(
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
