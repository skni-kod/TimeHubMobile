import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timehubmobile/Store/kolumnaModel.dart';
import 'package:timehubmobile/Store/tablicaModel.dart';
import 'package:timehubmobile/listaTablic.dart';
import 'package:timehubmobile/style.dart';
import 'package:timehubmobile/test_list.dart';
import 'package:timehubmobile/test_list.dart';

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
    lists = Provider.of<ModelKolumny>(context, listen: false)
        .kolumny
        .map(buildList)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
        appBar: AppBar(
          title: Text("Tablica ${args.index}: ${args.title}"),
        ),
        body: DragAndDropLists(
          axis: Axis.horizontal,
          listWidth: MediaQuery.of(context).size.width * 0.6,
          listPadding: EdgeInsets.all(16),
          listDraggingWidth: 150,
          listInnerDecoration: BoxDecoration(
              color: Color.fromARGB(122, 70, 184, 250),
              borderRadius: BorderRadius.circular(10)),
          children: lists,
          itemDecorationWhileDragging: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color.fromARGB(31, 223, 47, 47), blurRadius: 4)
            ],
          ),
          itemDivider: const Divider(
            thickness: 2,
            height: 2,
            color: Colors.white,
          ),
          onItemReorder: onReorderListItem,
          onListReorder: onReorderList,
          itemDragHandle: buildDragHandle(),
          listDragHandle: buildDragHandle(isList: true),
        ));
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAligment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;

    final color = isList ? Colors.blueGrey : Colors.black26;

    return DragHandle(
        verticalAlignment: verticalAligment,
        child: Container(
          padding: EdgeInsets.only(right: 10),
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
      newListItems.insert(newItemIndex, movedItem);
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);
    });
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

DragAndDropList buildList(Kolumna kolumna) => DragAndDropList(
      header: Container(
        padding: EdgeInsets.all(8),
        child: Text(
          kolumna.tytul,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
      children: [
        DragAndDropItem(
          child: ListTile(
            leading: Image.network(
              'http://ogrodnictwo.expert/wp-content/uploads/2016/09/Fotolia_57641864_Subscription_Monthly_XL-800x500_c.jpg',
              width: 40,
              height: 40,
              //fit: BoxFit.cover,
            ),
            title: Text('1'),
          ),
        )
      ],
    );
