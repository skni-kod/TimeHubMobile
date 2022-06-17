import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/tablicaModel.dart';
import 'package:timehubmobile/Store/userModel.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
            child: const FlutterLogo(),
            onTap: () {
              if (Navigator.defaultRouteName != "/") {
                Navigator.pushNamed(context, "/");
              }
            },
          ),
          actions: [
            Builder(
                builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.settings)))
          ],
        ),
        drawer: Drawer(
            child: ListView(
          children: !Provider.of<ModelUzytkownika>(context, listen: false)
                  .zalogowany
              ? [
                  ListTile(
                    title: const Text("Zaloguj się"),
                    onTap: () => Navigator.pushNamed(context, "/logowanie"),
                  ),
                  ListTile(
                    title: const Text("Zarejestruj się"),
                    onTap: () => Navigator.pushNamed(context, "/rejestracja"),
                  )
                ]
              : [
                  ListTile(
                      title: const Text("Wyloguj się"),
                      onTap: () {
                        Provider.of<ModelUzytkownika>(context, listen: false)
                            .wyloguj();
                        Navigator.pushNamed(context, "/");
                      }),
                ],
        )),
        body: !Provider.of<ModelUzytkownika>(context, listen: true).zalogowany
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 200, horizontal: 20),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(children: const [
                            Text(
                              "Musisz się zalogować aby korzystać z aplikacji!",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ])),
                      ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/logowanie"),
                          child: const Text("Zaloguj się")),
                      ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/rejestracja"),
                          child: const Text("Zarejestruj się"))
                    ],
                  )
                ]))
            : const UzytkownikZalogowany().build(context));
  }
}

class UzytkownikZalogowany {
  const UzytkownikZalogowany();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.only(top: 40, bottom: 20),
          child: const Text(
            "TimeHUB",
            style: TextStyle(fontSize: 30, color: Colors.blue),
          ),
        )
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: IconButton(
                  padding: const EdgeInsets.only(right: 15, bottom: 15),
                  color: Colors.blue,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.view_kanban, size: 40),
                  onPressed: () async {
                    await Provider.of<ModelTablicy>(context, listen: false)
                        .getTablica(context);
                    if (Provider.of<ModelTablicy>(context, listen: false).ok) {
                      for (int i = 0;
                          i <
                              Provider.of<ModelTablicy>(context, listen: false)
                                  .tablice
                                  .length;
                          i++) {
                        print((Provider.of<ModelTablicy>(context, listen: false)
                            .tablice[i]
                            .tytul));
                      }
                      Navigator.pushNamed(context, "/listaTablic");
                    } else {
                      print("error");
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Kanban",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: IconButton(
                  padding: const EdgeInsets.only(right: 15, bottom: 15),
                  color: Colors.blue,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 40,
                  ),
                  onPressed: () => Navigator.pushNamed(context, "/calendar"),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Kalendarz",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
        Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: IconButton(
                      padding: const EdgeInsets.only(right: 15, bottom: 15),
                      color: Colors.blue,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.insights, size: 40),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Wykresy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ]),
                const Positioned(
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 25,
                  ),
                  top: -3,
                  right: 26,
                ),
              ],
            ))
      ]),
      // const TasksMini()
    ]));
  }
}
