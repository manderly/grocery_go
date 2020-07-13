import 'package:flutter/material.dart';
import 'package:grocery_go/components/add_new.dart';
import 'package:grocery_go/components/item_list.dart';

class ItemListStream extends StatelessWidget {

  final dbStream;
  final listType; // item, crossedOff
  final onTap;
  final onInfoTap;
  final parentList;

  ItemListStream({@required this.dbStream, @required this.listType, @required this.onTap, @required this.onInfoTap, this.parentList});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dbStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && !snapshot.data.documents.isEmpty) {
          return ItemList(list: snapshot.data.documents, listType: listType, onItemTap: onTap, onInfoTap: onInfoTap, parentList: parentList);
        } else {
          return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("No items yet!"),
                ),
                AddNew(listType: listType, parentList: parentList),
              ],
          );
        }
      }
    );
  }
}