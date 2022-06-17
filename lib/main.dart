import 'package:flutter/material.dart';
import 'package:timehubmobile/Store/tablicaModel.dart';
import 'package:timehubmobile/calendar.dart';
import 'package:timehubmobile/home.dart';
import 'package:timehubmobile/listaTablic.dart';
import 'package:timehubmobile/widokTablicy.dart';
import 'package:timehubmobile/notes.dart';
import 'package:timehubmobile/logowanie.dart';
import 'package:timehubmobile/rejestracja.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/tasksModel.dart';
import 'package:timehubmobile/Store/userModel.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      //ChangeNotifierProvider<TasksModel>(create: (context) => TasksModel()),
      ChangeNotifierProvider<ModelUzytkownika>(
          create: (context) => ModelUzytkownika()),
      ChangeNotifierProvider<ModelTablicy>(create: (context) => ModelTablicy()),
    ],
    child: const TimeHub(),
  ));
}

class TimeHub extends StatelessWidget {
  const TimeHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Provider.of<TasksModel>(context, listen: false).readNotes();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'TimeHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        //"/notes": (context) => Notes(),
        //"/calendar": ((context) => Calendar()),
        "/logowanie": ((context) => const Logowanie()),
        "/rejestracja": ((context) => const Rejestracja()),
        "/listaTablic": ((context) => const ListaTablic()),
        '/widokTablicy': ((context) => const WidokTablicy()),
      },
    );
  }
}
