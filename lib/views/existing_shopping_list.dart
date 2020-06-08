import 'package:flutter/material.dart';
import 'package:grocery_go/components/item_list.dart';
import 'package:grocery_go/components/item_list_header.dart';
import 'package:grocery_go/models/item.dart';

class ExistingShoppingListArguments {
  final String listID;
  final String listName;
  ExistingShoppingListArguments(this.listID, this.listName);
}

class ExistingShoppingList extends StatelessWidget {

  static const routeName = '/existingShoppingList';

  // todo: replace this temporary list with one retrieved from DB using list ID
  final List<Item> list = [
    Item(id: "abc1", name: "Pepperidge Farm Cinnamon Bread", quantity: 2, subsOk: true, substitutions:["Aunt Millie's Famous Cinnamon Bread"], addedBy: "Mandi", lastUpdated: "2020-06-08T01:02:37+00:00"),
    Item(id: "abc2", name: "egg carton", quantity: 1, subsOk: false, addedBy: "Jon", lastUpdated: "2020-05-30T08:24:58+00:00"),
    Item(id: "abc3", name: "zucchini", quantity: 3, subsOk: false, addedBy: "Mandi", lastUpdated: "2020-06-01T10:15:23+00:00"),
  ];

  final List<Item> crossedOff = [
    Item(id: "abc4", name: "Barq's root beer", quantity: 1, subsOk: true, substitutions:["A&W"], addedBy: "Mandi", lastUpdated: "2020-05-30T08:24:58+00:00"),
    Item(id: "abc5", name: "Cheerios", quantity: 1, subsOk: true, substitutions:["Honey Bunches of Oats", "Cheerios berry flavor", "Quaker Oats"], addedBy: "Mandi", lastUpdated: "2020-05-20T08:24:58+00:00"),
    Item(id: "abc6", name: "Pillsbury Chocolate Chip Cookie dough roll", quantity: 1, subsOk: false, addedBy: "Jon", lastUpdated: "2020-05-05T05:10:16+00:00"),
  ];

  @override
  Widget build(BuildContext context) {

    final ExistingShoppingListArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.listName + ", id: " + args.listID),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ItemListHeader(text: "Aisle ?"),
                    ItemList(list: list, listType: 'item'),
                    ItemListHeader(text: "Crossed off"),
                    ItemList(list: crossedOff, listType: "crossedOff"),
                  ],
                ),
              );
            }),
    );
  }
}