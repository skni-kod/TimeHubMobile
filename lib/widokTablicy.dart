import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/tablicaModel.dart';

import 'date_time_picker.dart';
import 'listaTablic.dart';

class WidokTablicy extends StatefulWidget {
  const WidokTablicy({Key? key}) : super(key: key);

  @override
  State<WidokTablicy> createState() => _StanWidokuTablicy();
}

class _StanWidokuTablicy extends State<WidokTablicy> {
  late List<DragAndDropList> lists;

  @override
  void initState() {
    super.initState();
    lists = Provider.of<ModelTablicy>(context, listen: false)
        .kolumny
        .map(buildList)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint(notatki.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<ModelTablicy>(context).tablica.tytul!),
        actions: [
          Builder(
              builder: (context) => IconButton(
                  onPressed: () => openEditEntryDialog(),
                  icon: const Icon(Icons.settings)))
        ],
      ),
      body: Column(children: [
        Expanded(
            child: DragAndDropLists(
          axis: Axis.horizontal,
          listWidth: MediaQuery.of(context).size.width * 0.6,
          listPadding: EdgeInsets.all(8),
          listDraggingWidth: 150,
          listInnerDecoration: BoxDecoration(
              color: Color.fromARGB(122, 70, 184, 250),
              borderRadius: BorderRadius.circular(10)),
          children: lists,
          itemDecorationWhileDragging: const BoxDecoration(
            color: Color.fromARGB(121, 41, 113, 155),
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black45,
                spreadRadius: 3.0,
                blurRadius: 6.0,
                offset: Offset(2, 3),
              ),
            ],
          ),
          itemDivider: const Divider(
            thickness: 2,
            height: 2,
            color: Colors.white,
          ),
          onItemReorder: onReorderListItem,
          onListReorder: onReorderList,
          onItemAdd: onItemAdd,
          onListAdd: onListAdd,
          itemDragHandle: buildDragHandle(),
          listDragHandle: buildDragHandle(isList: true),
        )),
        SizedBox(
          height: 40,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Color.fromARGB(255, 221, 27, 27),
                    child: Center(
                      child: Draggable<DragAndDropListInterface>(
                        feedback: Icon(Icons.add_box),
                        child: Icon(Icons.add_box),
                        data: DragAndDropList(
                          header: const Text(
                            'Nowa kolumna',
                          ),
                          children: <DragAndDropItem>[],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                        color: Colors.orange,
                        child: Center(
                            child: Draggable<DragAndDropItem>(
                          feedback: Icon(Icons.add_comment),
                          child: Icon(Icons.add_comment),
                          data:
                              DragAndDropItem(child: Text('New default item')),
                        ))))
              ]),
        )
      ]),
    );
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAligment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;

    final color = isList ? Color.fromARGB(255, 75, 143, 177) : Colors.black26;

    return DragHandle(
        verticalAlignment: verticalAligment,
        child: Container(
          padding: isList
              ? EdgeInsets.only(right: 10, top: 10)
              : EdgeInsets.only(right: 10),
          child: Icon(
            Icons.menu,
            color: color,
          ),
        ));
  }

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;

      final movedItem = oldListItems.removeAt(oldItemIndex);
      final movedItemN = Provider.of<ModelTablicy>(context, listen: false)
          .notatkiL[oldListIndex]
          .removeAt(oldItemIndex);
      debugPrint(movedItemN.id.toString());
      newListItems.insert(newItemIndex, movedItem);
      Provider.of<ModelTablicy>(context, listen: false)
          .notatkiL[newListIndex]
          .insert(newItemIndex, movedItemN);
      Provider.of<ModelTablicy>(context, listen: false).moveNotatka(
          movedItemN.id,
          Provider.of<ModelTablicy>(context, listen: false)
              .kolumny[newListIndex]
              .id,
          context);
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      final movedKolumn = Provider.of<ModelTablicy>(context, listen: false)
          .kolumny
          .removeAt(oldListIndex);
      final movedListN = Provider.of<ModelTablicy>(context, listen: false)
          .notatkiL
          .removeAt(oldListIndex);
      debugPrint(movedKolumn.id.toString());
      debugPrint(newListIndex.toString());
      lists.insert(newListIndex, movedList);
      Provider.of<ModelTablicy>(context, listen: false)
          .kolumny
          .insert(newListIndex, movedKolumn);
      Provider.of<ModelTablicy>(context, listen: false)
          .notatkiL
          .insert(newListIndex, movedListN);
    });
  }

  onItemAdd(DragAndDropItem newItem, int listIndex, int itemIndex) {
    debugPrint('Dodawanie nowej notatki');
    setState(() {
      if (itemIndex == -1) {
        openAddNotatkaDialog(itemIndex, listIndex);
      } else {
        openAddNotatkaDialog(itemIndex, listIndex);
      }
    });
  }

  onListAdd(DragAndDropListInterface newList, int listIndex) {
    debugPrint('Dodawanie nowej kolumny');
    setState(() {
      if (listIndex == -1) {
        openAddKolumnaDialog(listIndex);
      } else {
        openAddKolumnaDialog(listIndex);
      }
    });
  }

  DragAndDropItem buildItem(Notatka notatka) => DragAndDropItem(
        child: ListTile(
          title: Text(notatka.zawartosc),
          onLongPress: () {
            openEditNotatkaDialog(notatka);
          },
        ),
      );

  DragAndDropList buildList(Kolumna kolumna) => DragAndDropList(
      header: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onLongPress: () {
                openEditKolumnaDialog(kolumna);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(7.0)),
                  color: Colors.blueAccent,
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  kolumna.tytul,
                  // style: Theme.of(context).primaryTextTheme.headline6,
                ),
              ),
            ),
          ),
        ],
      ),
      footer: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(7.0)),
                color: Colors.blueAccent,
              ),
              padding: EdgeInsets.all(10),
            ),
          ),
        ],
      ),
      leftSide: const VerticalDivider(
        color: Colors.blueAccent,
        width: 1.5,
        thickness: 1.5,
      ),
      rightSide: const VerticalDivider(
        color: Colors.blueAccent,
        width: 1.5,
        thickness: 1.5,
      ),
      children: Provider.of<ModelTablicy>(context, listen: false)
          .notatkiL[Provider.of<ModelTablicy>(context, listen: false)
              .kolumny
              .indexOf(kolumna)]
          .map(buildItem)
          .toList());

  Future openEditEntryDialog() async {
    Tablica? zmiana =
        await Navigator.of(context).push(MaterialPageRoute<Tablica>(
            builder: (BuildContext context) {
              return AddEntryDialog.edit(
                  Provider.of<ModelTablicy>(context, listen: false).tablica);
            },
            fullscreenDialog: true));
    if (zmiana != null) {
      debugPrint('zmiana');
      await Provider.of<ModelTablicy>(context, listen: false)
          .edytujTablice(zmiana, context);
    }
  }

  Future openAddNotatkaDialog(int indexNotatka, int indexKolumna) async {
    Notatka? save = await Navigator.of(context).push(MaterialPageRoute<Notatka>(
        builder: (BuildContext context) {
          return AddEditNotatka.add();
        },
        fullscreenDialog: true));
    if (save != null) {
      save.kolumna = Provider.of<ModelTablicy>(context, listen: false)
          .kolumny[indexKolumna]
          .id;
      if (indexNotatka == -1) {
        lists[indexKolumna].children.add(buildItem(save));
        Provider.of<ModelTablicy>(context, listen: false)
            .notatkiL[indexKolumna]
            .add(save);
        indexNotatka = lists[indexKolumna].children.length - 1;
      } else {
        lists[indexKolumna].children.insert(indexNotatka, buildItem(save));
        Provider.of<ModelTablicy>(context, listen: false)
            .notatkiL[indexKolumna]
            .insert(indexNotatka, save);
      }
      await Provider.of<ModelTablicy>(context, listen: false)
          .addNotatka(save, context, indexKolumna, indexNotatka);

      setState(() {});
    }
  }

  Future openEditNotatkaDialog(Notatka notatka) async {
    Notatka? zmiana =
        await Navigator.of(context).push(MaterialPageRoute<Notatka>(
            builder: (BuildContext context) {
              return AddEditNotatka.edit(notatka);
            },
            fullscreenDialog: true));
    if (zmiana != null) {
      debugPrint('zmiana');
      debugPrint(zmiana.id.toString());
      await Provider.of<ModelTablicy>(context, listen: false)
          .edytujNotatka(zmiana, context);
    }
    setState(() {
      lists = Provider.of<ModelTablicy>(context, listen: false)
          .kolumny
          .map(buildList)
          .toList();
    });
  }

  Future openEditKolumnaDialog(Kolumna kolumna) async {
    Kolumna? zmiana =
        await Navigator.of(context).push(MaterialPageRoute<Kolumna>(
            builder: (BuildContext context) {
              return AddEditKolumna.edit(kolumna);
            },
            fullscreenDialog: true));
    if (zmiana != null) {
      debugPrint('zmiana');
      debugPrint(zmiana.tytul.toString());
      await Provider.of<ModelTablicy>(context, listen: false)
          .edytujKolumna(zmiana, context);
    }
    setState(() {
      lists = Provider.of<ModelTablicy>(context, listen: false)
          .kolumny
          .map(buildList)
          .toList();
    });
  }

  Future openAddKolumnaDialog(int indexKolumna) async {
    Kolumna? save = await Navigator.of(context).push(MaterialPageRoute<Kolumna>(
        builder: (BuildContext context) {
          return AddEditKolumna.add();
        },
        fullscreenDialog: true));
    if (save != null) {
      if (indexKolumna == -1) {
        save.tablica =
            Provider.of<ModelTablicy>(context, listen: false).tablica.id!;
        Provider.of<ModelTablicy>(context, listen: false).notatkiL.add([]);
        Provider.of<ModelTablicy>(context, listen: false).kolumny.add(save);
        lists.add(buildList(save));

        indexKolumna = lists.length - 1;
      } else {
        save.tablica =
            Provider.of<ModelTablicy>(context, listen: false).tablica.id!;
        debugPrint(indexKolumna.toString());
        Provider.of<ModelTablicy>(context, listen: false)
            .notatkiL
            .insert(indexKolumna, []);
        Provider.of<ModelTablicy>(context, listen: false)
            .kolumny
            .insert(indexKolumna, save);
        lists.insert(indexKolumna, buildList(save));
      }
      await Provider.of<ModelTablicy>(context, listen: false)
          .addKolumna(save, context, indexKolumna);

      setState(() {});
    }
  }
}

class DraggableList {
  final String header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items,
  });
}

class DraggableListItem {
  final String title;
  final String urlImage;

  const DraggableListItem({
    required this.title,
    required this.urlImage,
  });
}

class AddEditNotatka extends StatefulWidget {
  final Notatka initNotatka;
  AddEditNotatka.add({Key? key})
      : initNotatka = Notatka(
            id: -1,
            kolumna: -1,
            stworzonePrzez: -1,
            dataStworzenia: DateTime.now(),
            czyZrobione: false,
            czyWazne: false,
            zawartosc: '',
            dataRozpoczecia: DateTime.now(),
            dataZakonczenia: DateTime.now());

  AddEditNotatka.edit(Notatka note) : initNotatka = note;

  @override
  AddEditNotatkaState createState() {
    return AddEditNotatkaState(initNotatka);
  }
}

class AddEditNotatkaState extends State<AddEditNotatka> {
  bool isCheckedI = false;
  bool isCheckedC = false;
  late TextEditingController _textController;
  TextEditingController _deleteTextController = TextEditingController();
  Notatka note;
  final _kluczFormularza = GlobalKey<FormFieldState>();
  final _kluczFormularzaUsun = GlobalKey<FormFieldState>();
  DateTime _dateTimeStart = DateTime.now();
  DateTime _dateTimeEnd = DateTime.now();

  AppBar _createAppBar(BuildContext context) {
    return AppBar(
      title: widget.initNotatka.id == -1
          ? const Text("Nowa notatka")
          : const Text("Edytowanie notatki"),
      actions: [
        TextButton(
          onPressed: () {
            if (_kluczFormularza.currentState!.validate()) {
              note.czyWazne = isCheckedI;
              note.czyZrobione = isCheckedC;
              note.dataRozpoczecia = _dateTimeStart;
              note.dataZakonczenia = _dateTimeEnd;
              //debugPrint(tab.tytul);
              // debugPrint(tab.czyZautomatyzowane.toString());
              //  debugPrint(tab.id.toString());
              Navigator.of(context).pop(note);
            }
          },
          child: const Text('Zapisz', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initNotatka.zawartosc);
    note = widget.initNotatka;
    isCheckedI = note.czyWazne;
    isCheckedC = note.czyZrobione;
    _dateTimeEnd = note.dataZakonczenia!;
    _dateTimeStart = note.dataRozpoczecia!;
  }

  AddEditNotatkaState(this.note);
  @override
  Widget build(BuildContext context) {
    // tab.czyZautomatyzowane = false;
    return Scaffold(
      appBar: _createAppBar(context),
      body: ListView(children: [
        SwitchListTile(
            title: const Text("Ważna"),
            value: isCheckedI,
            secondary: const Icon(
              FontAwesomeIcons.solidStar,
              color: Color.fromARGB(255, 221, 189, 47),
            ),
            onChanged: (checked) {
              setState(() {
                isCheckedI = checked;
              });
            }),
        widget.initNotatka.id != -1
            ? SwitchListTile(
                title: const Text("Ukończona"),
                value: isCheckedC,
                secondary: const Icon(
                  Icons.done,
                  color: Color.fromARGB(255, 221, 189, 47),
                ),
                onChanged: (checked) {
                  setState(() {
                    isCheckedC = checked;
                  });
                })
            : SizedBox(height: 0.0),
        ListTile(
          leading: Icon(Icons.note_alt, color: Colors.grey[500]),
          title: TextFormField(
            key: _kluczFormularza,
            validator: (tresc) {
              if (tresc == null || tresc.isEmpty) {
                return 'Musisz wypełnić to pole!';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Tytuł',
            ),
            controller: _textController,
            onChanged: (value) => note.zawartosc = value,
          ),
        ),
        ListTile(
          leading: Icon(Icons.today, color: Colors.grey[500]),
          title: DateTimeItem(
              dateTime: _dateTimeStart,
              onChanged: (dateTimeStart) =>
                  setState(() => _dateTimeStart = dateTimeStart),
              isEnd: false),
        ),
        ListTile(
          leading: Icon(Icons.event, color: Colors.grey[500]),
          title: DateTimeItem(
            dateTime: _dateTimeEnd,
            onChanged: (dateTimeEnd) =>
                setState(() => _dateTimeEnd = dateTimeEnd),
            isEnd: true,
          ),
        ),
        widget.initNotatka.id != -1
            ? ListTile(
                trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      _delete(context);
                    }))
            : const SizedBox(height: 0.0)
      ]),
    );
  }

  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Potwierdzenie'),
            content:
                const Text('Czy jesteś pewien, że chcesz usuniąć notatkę?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    await Provider.of<ModelTablicy>(context, listen: false)
                        .usunNotatke(context, note);
                    await Provider.of<ModelTablicy>(context, listen: false)
                        .getNotatki(context);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: const Text('Tak')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Nie'))
            ],
          );
        });
  }
}

class AddEditKolumna extends StatefulWidget {
  final Kolumna initKolumna;
  AddEditKolumna.add({Key? key})
      : initKolumna = Kolumna(id: -1, tablica: -1, tytul: '');

  AddEditKolumna.edit(Kolumna kolumna) : initKolumna = kolumna;

  @override
  AddEditKolumnaState createState() {
    return AddEditKolumnaState(initKolumna);
  }
}

class AddEditKolumnaState extends State<AddEditKolumna> {
  late TextEditingController _textController;
  TextEditingController _deleteTextController = TextEditingController();
  Kolumna kolumna;
  final _kluczFormularza = GlobalKey<FormFieldState>();
  final _kluczFormularzaUsun = GlobalKey<FormFieldState>();

  AppBar _createAppBar(BuildContext context) {
    return AppBar(
      title: widget.initKolumna.id == -1
          ? const Text("Nowa kolumna")
          : const Text("Edytowanie kolumny"),
      actions: [
        TextButton(
          onPressed: () {
            if (_kluczFormularza.currentState!.validate()) {
              //debugPrint(tab.tytul);
              // debugPrint(tab.czyZautomatyzowane.toString());
              //  debugPrint(tab.id.toString());
              Navigator.of(context).pop(kolumna);
            }
          },
          child: const Text('Zapisz', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initKolumna.tytul);
    kolumna = widget.initKolumna;
    //isChecked = tab.czyZautomatyzowane!;
  }

  AddEditKolumnaState(this.kolumna);
  @override
  Widget build(BuildContext context) {
    // tab.czyZautomatyzowane = false;
    return Scaffold(
      appBar: _createAppBar(context),
      body: ListView(children: [
        ListTile(
          leading: Icon(Icons.title, color: Colors.grey[500]),
          title: TextFormField(
            key: _kluczFormularza,
            validator: (tresc) {
              if (tresc == null || tresc.isEmpty) {
                return 'Musisz wypełnić to pole!';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Tytuł',
            ),
            controller: _textController,
            onChanged: (value) => kolumna.tytul = value,
          ),
        ),
        widget.initKolumna.id != -1
            ? ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                trailing: TextButton(
                    child: const Text('USUŃ'),
                    onPressed: () async {
                      if (_kluczFormularzaUsun.currentState!.validate()) {
                        await Provider.of<ModelTablicy>(context, listen: false)
                            .usunKolumna(context, kolumna);
                        await Provider.of<ModelTablicy>(context, listen: false)
                            .getKolumny(
                                context,
                                Provider.of<ModelTablicy>(context,
                                        listen: false)
                                    .tablice
                                    .indexWhere((element) =>
                                        element.id == kolumna.tablica));

                        Navigator.of(context).pop();
                      }
                    }),
                title: TextFormField(
                  key: _kluczFormularzaUsun,
                  validator: (tresc) {
                    if (tresc != kolumna.tytul ||
                        tresc == null ||
                        tresc.isEmpty) {
                      return 'Musisz podać tytuł tablicy!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Wpisz nazwę tablicy',
                  ),
                ),
              )
            : const SizedBox(height: 0.0)
      ]),
    );
  }
}
