import 'package:flutter/material.dart';
import 'package:timehubmobile/Components/notesMini.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: const FlutterLogo(),
          onTap: () {
            if (Navigator.defaultRouteName != "/") {
              Navigator.pushNamed(context, "/");
            }
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
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
                    onPressed: () {},
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
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: IconButton(
                            padding:
                                const EdgeInsets.only(right: 15, bottom: 15),
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
        NotesMini()
      ])),
    );
  }
}
