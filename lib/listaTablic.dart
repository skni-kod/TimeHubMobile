import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          return InkWell(
            onTap: () {
              debugPrint("Tablica $index pressed");
              Navigator.pushNamed(context, "/widokTablicy",
                  arguments: ScreenArguments(
                      index + 1,
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
}

Widget buildDodajTabliceButton(BuildContext context) => IconButton(
    icon: Icon(
      Icons.add,
    ),
    splashRadius: 25,
    splashColor: Color.fromARGB(255, 54, 136, 202),
    onPressed: () {
      debugPrint("Dodaj_tablice_button_pressed");
    });

class ScreenArguments {
  final int id;
  final String title;

  ScreenArguments(this.id, this.title);
}
