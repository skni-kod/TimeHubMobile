import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/tasksModel.dart';

class Note extends StatefulWidget {
  const Note({Key? key, required this.note, required this.id})
      : super(key: key);

  final String note;
  final num id;

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final textInputController = TextEditingController();
  bool edit = false;
  @override
  Widget build(BuildContext context) {
    textInputController.text = widget.note;
    return ChangeNotifierProvider(
        create: (context) => TasksModel(),
        child: GestureDetector(
            onLongPress: (ModalRoute.of(context)?.settings.name == "/notes"
                ? () {
                    !Provider.of<TasksModel>(context, listen: false)
                            .isInDelete(widget.id)
                        ? Provider.of<TasksModel>(context, listen: false)
                            .addToDelete({"id": widget.id})
                        : Provider.of<TasksModel>(context, listen: false)
                            .removeFromDelete({"id": widget.id});
                  }
                : () {}),
            onTap: () => setState(() {
                  edit = true;
                }),
            child: edit
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Provider.of<TasksModel>(context)
                                    .isInDelete(widget.id)
                                ? Colors.green
                                : Colors.blue)),
                    margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        LayoutBuilder(
                            builder: (BuildContext context,
                                    BoxConstraints constraints) =>
                                SizedBox(
                                  width: constraints.maxWidth - 20,
                                  child: TextField(
                                    maxLines: null,
                                    autofocus: true,
                                    controller: textInputController,
                                    style: const TextStyle(fontSize: 18),
                                    decoration: const InputDecoration.collapsed(
                                      hintText: 'Edytuj notatkę',
                                    ),
                                  ),
                                )),
                        Positioned.fill(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (textInputController.text != "") {
                                      Provider.of<TasksModel>(context,
                                              listen: false)
                                          .changeNote({
                                        "id": widget.id,
                                        "value": textInputController.text
                                      });
                                      textInputController.clear();
                                      edit = false;
                                    }
                                  },
                                  icon: const Icon(Icons.done))),
                        )
                      ],
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Provider.of<TasksModel>(context)
                                    .isInDelete(widget.id)
                                ? Colors.green
                                : Colors.blue)),
                    margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Text(
                          widget.note,
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  )));
  }
}
