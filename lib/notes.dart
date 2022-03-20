import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Components/note.dart';
import 'package:timehubmobile/Store/notemodel.dart';
import 'package:timehubmobile/Components/expandableFab.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);
  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final textInputController = TextEditingController();

  bool addNote = false;

  void confirmNote() {
    FocusScope.of(context).unfocus();
    if (textInputController.text != "") {
      Provider.of<NoteModel>(context, listen: false)
          .addNote(textInputController.text);
      textInputController.clear();
      setState(() {
        addNote = false;
      });
    }
  }

  void dispose() {
    textInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Consumer<NoteModel>(
            builder: (context, value, child) => value.deleteItems.isNotEmpty
                ? Stack(
                    children: [
                      Container(
                          alignment: Alignment.bottomRight,
                          margin: const EdgeInsets.only(right: 60),
                          child: ActionButton(
                            onPressed: () {
                              Provider.of<NoteModel>(context, listen: false)
                                  .removeNotes();
                            },
                            icon: Icons.delete,
                          )),
                      Container(
                          alignment: Alignment.bottomRight,
                          child: ActionButton(
                            onPressed: () =>
                                Provider.of<NoteModel>(context, listen: false)
                                    .clearDelete(),
                            icon: Icons.close,
                          )),
                    ],
                  )
                : addNote
                    ? ActionButton(
                        icon: Icons.done,
                        onPressed: () => confirmNote(),
                      )
                    : ActionButton(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      )),
        body: Consumer<NoteModel>(
            builder: (context, value, child) => GestureDetector(
                onTap: confirmNote,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.blue))),
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                42,
                                        child: const Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Notatki",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18),
                                            )))
                                  ],
                                ),
                                TextField(
                                    maxLines: null,
                                    onTap: () => setState(() {
                                          addNote = true;
                                        }),
                                    controller: textInputController,
                                    decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                        ),
                                        labelText: 'Dodaj notatkę',
                                        labelStyle: TextStyle(fontSize: 18))),
                                Expanded(
                                  child: Consumer<NoteModel>(
                                      builder: ((context, value, child) =>
                                          ListView(
                                            children: List.generate(
                                                value.count,
                                                (index) => Note(
                                                      note: value.items[index]
                                                          ["value"],
                                                      id: value.items[index]
                                                          ["id"],
                                                    )),
                                          ))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )))));
  }
}
