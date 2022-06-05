import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/kolumnaModel.dart';
import 'package:timehubmobile/Store/tablicaModel.dart';
import 'package:timehubmobile/style.dart';
import 'package:timehubmobile/widokTablicy.dart';

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
        actions: [buildDodajTabliceButton(context)],
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
              Navigator.pushNamed(context, "/widokTablicy",
                  arguments: ScreenArguments(
                      index,
                      Provider.of<ModelTablicy>(context, listen: false)
                          .tablice[index]
                          .tytul
                          .toString()));
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

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> pokazOkno(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _edycjaTekstuController =
              TextEditingController();
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    controller: _edycjaTekstuController,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Nie poprawna wartośc";
                    },
                    decoration:
                        InputDecoration(hintText: 'Wpisz nazwę tablicy'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Czy zautomatyzowana"),
                      Checkbox(
                          value: isChecked,
                          onChanged: (checked) {
                            setState(() {
                              isChecked = checked!;
                            });
                          })
                    ],
                  )
                ]),
              ),
              actions: [
                TextButton(
                    child: Text("Stwórz"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await Provider.of<ModelTablicy>(context, listen: false)
                            .dodajTablice(_edycjaTekstuController.text,
                                isChecked ? 'true' : 'false', context);

                        Navigator.of(context).pop();
                      }
                    })
              ],
            );
          });
        });
  }

  Widget buildDodajTabliceButton(BuildContext context) => IconButton(
      icon: Icon(
        Icons.add,
      ),
      splashRadius: 25,
      splashColor: Color.fromARGB(255, 54, 136, 202),
      onPressed: () async {
        debugPrint('Dodaj tablice clicked');
        await pokazOkno(context);
        setState(() {
          Provider.of<ModelTablicy>(context, listen: false).getTablica(context);
        });
      });
}

class ScreenArguments {
  final int index;
  final String title;

  ScreenArguments(this.index, this.title);
}
