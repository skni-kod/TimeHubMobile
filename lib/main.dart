import 'package:flutter/material.dart';
import 'package:timehubmobile/Store/tablicaModel.dart';
import 'package:timehubmobile/Store/wykresModel.dart';
import 'package:timehubmobile/calendar.dart';
import 'package:timehubmobile/home.dart';
import 'package:timehubmobile/listaTablic.dart';
import 'package:timehubmobile/widokTablicy.dart';
import 'package:timehubmobile/logowanie.dart';
import 'package:timehubmobile/rejestracja.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/notatkaModel.dart';
import 'package:timehubmobile/Store/userModel.dart';
import 'package:flutter/services.dart';
import 'package:timehubmobile/charts.dart';
import "package:flutter_localizations/flutter_localizations.dart";

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ModelUzytkownika>(
          create: (context) => ModelUzytkownika()),
      ChangeNotifierProvider<ModelTablicy>(create: (context) => ModelTablicy()),
      ChangeNotifierProvider<ModelNotatek>(create: (context) => ModelNotatek()),
      ChangeNotifierProvider<ModelWykresu>(create: (context) => ModelWykresu())
    ],
    child: const TimeHub(),
  ));
}

class TimeHub extends StatelessWidget {
  const TimeHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale('pl')],
      title: 'TimeHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        "/calendar": ((context) => Calendar()),
        "/logowanie": ((context) => const Logowanie()),
        "/rejestracja": ((context) => const Rejestracja()),
        "/listaTablic": ((context) => const ListaTablic()),
        '/widokTablicy': ((context) => const WidokTablicy()),
        '/wykresy': ((context) => Wykresy())
      },
    );
  }
}
