import 'dart:collection';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class TasksModel extends ChangeNotifier {
  final List<Map> _list = [{"id":1,"kanban":"Politechnika","kanban_id":1,"column":"to_do","column_id":1,"start":DateTime,"end":"10.00",}];
  final List<Map> _deleteList = [];

  int get count => _list.length;

  UnmodifiableListView<Map> get items => UnmodifiableListView(_list);
  UnmodifiableListView<Map> get deleteItems =>
      UnmodifiableListView(_deleteList);

  void addNote(String note) {
    _list.add(
        {"id": _list.isNotEmpty ? _list.last["id"] + 1 : 1, "value": note});
    notifyListeners();
    _saveToFile();
  }

  void removeNotes() {
    _deleteList
        .forEach((e) => _list.removeWhere((item) => e["id"] == item["id"]));
    notifyListeners();
    _saveToFile();
    _deleteList.clear();
  }

  void addToDelete(Map noteId) {
    _deleteList.add(noteId);
    notifyListeners();
  }

  void removeFromDelete(Map noteId) {
    _deleteList.removeWhere((id) => noteId["id"] == id["id"]);
    notifyListeners();
  }

  bool isInDelete(num id) {
    return _deleteList.any((element) => element["id"] == id);
  }

  void clearDelete() {
    _deleteList.clear();
    notifyListeners();
  }

  void changeNote(Map note) {
    _list[_list.indexWhere((element) => element["id"] == note["id"])]["value"] =
        note["value"];
    _saveToFile();
    notifyListeners();
  }

  void _saveToFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    String text = "";
    final File file = File(
      '${directory.path}/notes.txt',
    );
    for (Map note in _list) {
      text += note["value"].toString() + "\n";
    }
    file.writeAsString(text, mode: FileMode.write);
  }

  void readNotes() async {
    List<String> notes;
    _list.clear();
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/notes.txt');
      notes = await file.readAsLines();
      for (String note in notes) {
        _list.add(
            {"id": _list.isNotEmpty ? _list.last["id"] + 1 : 1, "value": note});
      }
      notifyListeners();
      return;
    } catch (e) {
      print(e);
      return;
    }
  }
}
