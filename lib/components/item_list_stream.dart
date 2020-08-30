import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_go/components/item_list.dart';
import 'package:grocery_go/models/shopping_list.dart';

class ItemListStream extends StatelessWidget {

  final dbStream;
  final sortBy;
  final listType; // item, crossedOff
  final onTap;
  final onInfoTap;
  final ShoppingList parentList;

  ItemListStream({@required this.dbStream, @required this.sortBy, @required this.listType, @required this.onTap, @required this.onInfoTap, this.parentList});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dbStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && !snapshot.data.documents.isEmpty) {
          List<DocumentSnapshot> docs = snapshot.data.documents;

          if (listType != 'crossedOff') {
            docs.sort((a, b) {
              return a.data['listPositions'][sortBy].compareTo(b.data['listPositions'][sortBy]);
            });
          } else {
            docs.sort((b, a) {
              return a.data['lastUpdated'].toDate().compareTo(b.data['lastUpdated'].toDate());
            });
          }

          return ItemList(list: docs, listType: listType, onItemTap: onTap, onInfoTap: onInfoTap, parentList: parentList);
        } else {
          return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("No items yet!"),
                ),
              ],
          );
        }
      }
    );
  }
}