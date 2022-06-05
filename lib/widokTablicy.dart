import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
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
    lists = Provider.of<ModelTablicy>(context, listen: false)
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
      body: Column(children: [
        Expanded(
            child: DragAndDropLists(
          axis: Axis.horizontal,
          listWidth: MediaQuery.of(context).size.width * 0.6,
          listPadding: EdgeInsets.all(8),
          listDraggingWidth: 150,
          listInnerDecoration: BoxDecoration(
              color: Color.fromARGB(122, 70, 184, 250),
              borderRadius: BorderRadius.circular(10)),
          children: lists,
          itemDecorationWhileDragging: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black45,
                spreadRadius: 3.0,
                blurRadius: 6.0,
                offset: Offset(2, 3),
              ),
            ],
          ),
          itemDivider: const Divider(
            thickness: 2,
            height: 2,
            color: Colors.white,
          ),
          onItemReorder: onReorderListItem,
          onListReorder: onReorderList,
          onItemAdd: onItemAdd,
          onListAdd: onListAdd,
          itemDragHandle: buildDragHandle(),
          listDragHandle: buildDragHandle(isList: true),
        )),
        SizedBox(
          height: 40,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.pink,
                    child: Center(
                      child: Draggable<DragAndDropListInterface>(
                        feedback: Icon(Icons.add_box),
                        child: Icon(Icons.add_box),
                        data: DragAndDropList(
                          header: Text(
                            'New default list',
                          ),
                          children: <DragAndDropItem>[],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                        color: Colors.orange,
                        child: Center(
                            child: Draggable<DragAndDropItem>(
                          feedback: Icon(Icons.add_comment),
                          child: Icon(Icons.add_comment),
                          data:
                              DragAndDropItem(child: Text('New default item')),
                        ))))
              ]),
        )
      ]),
    );
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

  onItemAdd(DragAndDropItem newItem, int listIndex, int itemIndex) {
    print('adding new item');
    setState(() {
      if (itemIndex == -1) {
        lists[listIndex].children.add(newItem);
      } else {
        lists[listIndex].children.insert(itemIndex, newItem);
      }
    });
  }

  onListAdd(DragAndDropListInterface newList, int listIndex) {
    print('adding new list');
    setState(() {
      if (listIndex == -1) {
        lists.add(newList as DragAndDropList);
      } else {
        lists.insert(listIndex, newList as DragAndDropList);
      }
    });
  }

  DragAndDropList buildList(Kolumna kolumna) => DragAndDropList(
        header: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(7.0)),
                  color: Colors.pink,
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  kolumna.tytul,
                  // style: Theme.of(context).primaryTextTheme.headline6,
                ),
              ),
            ),
          ],
        ),
        footer: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(7.0)),
                  color: Colors.pink,
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
          ],
        ),
        leftSide: VerticalDivider(
          color: Colors.pink,
          width: 1.5,
          thickness: 1.5,
        ),
        rightSide: VerticalDivider(
          color: Colors.pink,
          width: 1.5,
          thickness: 1.5,
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
          ),
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
          ),
        ],
      );
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
