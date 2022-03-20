import 'package:flutter/material.dart';
import 'package:timehubmobile/calendar.dart';
import 'package:timehubmobile/home.dart';
import 'package:timehubmobile/notes.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/notemodel.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => NoteModel())],
    child: const TimeHub(),
  ));
}

class TimeHub extends StatelessWidget {
  const TimeHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<NoteModel>(context, listen: false).readNotes();

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
          "/": (context) => const Home(),
          "/notes": (context) => Notes(),
          "/calendar": ((context) => Calendar())
        });
  }
}
