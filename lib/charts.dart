import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/wykresModel.dart';

class Wykresy extends StatefulWidget {
  Wykresy({Key? key}) : super(key: key);

  @override
  State<Wykresy> createState() => _stanWykresow();
}

class _stanWykresow extends State<Wykresy> {
  /*Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(text, style: style),
    );
  }

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [BarChartRodData(toY: 8, color: Colors.red)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [BarChartRodData(toY: 10, color: Colors.black)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [BarChartRodData(toY: 14, color: Colors.blue)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [BarChartRodData(toY: 15, color: Colors.green)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [BarChartRodData(toY: 13, color: Colors.orange)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [BarChartRodData(toY: 10, color: Colors.pink)],
          showingTooltipIndicators: [0],
        ),
      ];*/

  @override
  Widget build(BuildContext context) {
    List<Color> kolory = [
      Color(0xff0293ee),
      Color(0xfff8b250),
      Color(0xff845bef),
      Color(0xff13d38e)
    ];

    List<Container> indykatoryProcentNaTablice(List<String> nazwy) {
      return List.generate(nazwy.length < 4 ? nazwy.length : 4, (i) {
        return Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.square,
                  color: kolory[i],
                  size: 20,
                ),
                Text(nazwy[i])
              ],
            ));
      });
    }

    List<PieChartSectionData> procentNaTabliceSekcje(
        Map<String, dynamic> procentNaTabliceDane) {
      List<String> nazwy = procentNaTabliceDane.keys.toList();
      return List.generate(
          procentNaTabliceDane.length < 4 ? procentNaTabliceDane.length : 4,
          (i) {
        return PieChartSectionData(
          color: kolory[i],
          value: double.parse(procentNaTabliceDane[nazwy[i]].toString()),
          title: procentNaTabliceDane[nazwy[i]].toString(),
          radius: 70,
          titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        );
      });
    }

    WykresAktualne aktualne =
        Provider.of<ModelWykresu>(context, listen: true).aktualne;
    double lacznieWykresAktualne = 0.0;
    Provider.of<ModelWykresu>(context, listen: true)
        .wykresAktywneZadania(context);
    Provider.of<ModelWykresu>(context, listen: true)
        .wykresProcentNaTablice(context);
    bool bledy = Provider.of<ModelWykresu>(context, listen: true).bledy;
    bool pusto = false;

    if (!bledy) {
      aktualne = Provider.of<ModelWykresu>(context, listen: true).aktualne;
      lacznieWykresAktualne = aktualne.zrobione + aktualne.w_trakcie;
      if (lacznieWykresAktualne == 0) {
        pusto = true;
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Wykresy"),
        ),
        body: bledy
            ? const Text('Wystąpił błąd. Spróbuj ponownie później')
            : pusto
                ? const Text('Nie masz żadnych wykresów do wyświetlenia')
                : ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 50),
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Aktualne zadania',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.square,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      Text('Zadania wykonane')
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.square,
                                        color: Colors.orange,
                                        size: 20,
                                      ),
                                      Text('Zadania bierzące')
                                    ],
                                  ),
                                ),
                              ]),
                          Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width / 2 - 40,
                              child: PieChart(PieChartData(
                                  pieTouchData: PieTouchData(
                                      touchCallback:
                                          (FlTouchEvent, PieTouchResponse) =>
                                              {}),
                                  startDegreeOffset: 180,
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 1,
                                  centerSpaceRadius: 0,
                                  sections: [
                                    PieChartSectionData(
                                      color: Colors.blue,
                                      value: aktualne.zrobione /
                                          lacznieWykresAktualne *
                                          100,
                                      title: aktualne.zrobione.toString(),
                                      radius: 70,
                                      titleStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      //  titlePositionPercentageOffset: 0.5,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.orange,
                                      value: aktualne.w_trakcie /
                                          lacznieWykresAktualne *
                                          100,
                                      title: aktualne.w_trakcie.toString(),
                                      radius: 70,
                                      titleStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      //  titlePositionPercentageOffset: 0.5,
                                    )
                                  ]))),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Podział zadań na tablice [%]',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Text('Ostatnie 7 dni'),
                          Wrap(
                              children: indykatoryProcentNaTablice(
                                  Provider.of<ModelWykresu>(context,
                                          listen: false)
                                      .nazwyTablic)),
                          Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width / 2 - 40,
                              child: PieChart(PieChartData(
                                  startDegreeOffset: 180,
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 1,
                                  centerSpaceRadius: 0,
                                  sections: procentNaTabliceSekcje(
                                      Provider.of<ModelWykresu>(context,
                                              listen: false)
                                          .procentNaTablice)))),
                        ],
                      ),
                      /*Row(
                    children: [
                      Column(children: [
                        const Text(
                          "Ilość wykonanych zadań",
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text("W przeciągu ostatnich 7 dni"),
                        Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width - 40,
                            child: BarChart(
                              BarChartData(
                                titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 30,
                                          getTitlesWidget: getTitles),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    )),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: barGroups,
                                gridData: FlGridData(show: false),
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 20,
                              ),
                            ))
                      ])
                    ],
                  )*/
                    ],
                  ));
  }
}
