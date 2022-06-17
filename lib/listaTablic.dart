import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/tablicaModel.dart';

class ListaTablic extends StatefulWidget {
  const ListaTablic({Key? key}) : super(key: key);

  @override
  State<ListaTablic> createState() => _StanListyTablic();
}

@override
void initState() {}

class _StanListyTablic extends State<ListaTablic> {
  final GlobalKey _widgetKey = GlobalKey();
  String title = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Twoje tablice"),
        actions: [
          Builder(
              builder: (context) => IconButton(
                  onPressed: () => openAddEntryDialog(),
                  icon: const Icon(Icons.add)))
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
            Provider.of<ModelTablicy>(context, listen: false).tablice.length,
            (index) {
          print('tablice wygenerowane');
          return InkWell(
            onTap: () async {
              debugPrint("Tablica $index pressed");
              await Provider.of<ModelTablicy>(context, listen: false)
                  .getKolumny(context, index);
              Navigator.pushNamed(context, "/widokTablicy")
                  .then((_) => setState(() {
                        Provider.of<ModelTablicy>(context, listen: false)
                            .getTablica(context);
                      }));
            },
            highlightColor: Colors.white,
            splashColor: Colors.white,
            child: Card(
              color: Colors.blueAccent,
              margin: const EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
              elevation: 20.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(
                      flex: 8,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Icon(Icons.view_kanban_outlined,
                            size: 100.0, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        Provider.of<ModelTablicy>(context, listen: false)
                            .tablice[index]
                            .tytul
                            .toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future openAddEntryDialog() async {
    Tablica? save = await Navigator.of(context).push(MaterialPageRoute<Tablica>(
        builder: (BuildContext context) {
          return AddEntryDialog.add();
        },
        fullscreenDialog: true));
    if (save != null) {
      await Provider.of<ModelTablicy>(context, listen: false)
          .dodajTablice(save.tytul, save.czyZautomatyzowane, context);
      setState(() {
        Provider.of<ModelTablicy>(context, listen: false).getTablica(context);
      });
    }
  }
}

class AddEntryDialog extends StatefulWidget {
  final Tablica initTab;
  AddEntryDialog.add({Key? key})
      : initTab = Tablica(id: -1, tytul: '', czyZautomatyzowane: false),
        super(key: key);

  AddEntryDialog.edit(Tablica tab) : initTab = tab;

  @override
  AddEntryDialogState createState() {
    return AddEntryDialogState(initTab);
  }
}

class AddEntryDialogState extends State<AddEntryDialog> {
  bool isChecked = false;
  late TextEditingController _textController;
  TextEditingController _deleteTextController = TextEditingController();
  Tablica tab;
  final _kluczFormularza = GlobalKey<FormFieldState>();
  final _kluczFormularzaUsun = GlobalKey<FormFieldState>();

  AppBar _createAppBar(BuildContext context) {
    return AppBar(
      title: widget.initTab.id == -1
          ? const Text("New entry")
          : const Text("Edit entry"),
      actions: [
        TextButton(
          onPressed: () {
            if (_kluczFormularza.currentState!.validate()) {
              tab.czyZautomatyzowane = isChecked;
              debugPrint(tab.tytul);
              debugPrint(tab.czyZautomatyzowane.toString());
              debugPrint(tab.id.toString());
              Navigator.of(context).pop(tab);
            }
          },
          child: const Text('SAVE', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initTab.tytul);
    tab = widget.initTab;
    isChecked = tab.czyZautomatyzowane!;
  }

  AddEntryDialogState(this.tab);
  @override
  Widget build(BuildContext context) {
    tab.czyZautomatyzowane = false;
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
            onChanged: (value) => tab.tytul = value,
          ),
        ),
        SwitchListTile(
            title: Text("Zautomatyzowana"),
            value: isChecked,
            secondary: const Icon(FontAwesomeIcons.gear),
            onChanged: (checked) {
              if (widget.initTab.id == -1) {
                setState(() {
                  isChecked = checked;
                });
              }
            }),
        widget.initTab.id != -1
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
                            .usunTablice(context);
                        await Provider.of<ModelTablicy>(context, listen: false)
                            .getTablica(context);

                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        setState(() {});
                      }
                    }),
                title: TextFormField(
                  key: _kluczFormularzaUsun,
                  validator: (tresc) {
                    if (tresc != tab.tytul || tresc == null || tresc.isEmpty) {
                      return 'Musisz podać tytuł tablicy!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Wpisz nazwę tablicy',
                  ),
                ),
              )
            : Text('')
      ]),
    );
  }
}
