import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/item_dto.dart';
import 'package:grocery_go/models/shopping_list.dart';

class NewItemForm extends StatefulWidget {
  final ShoppingList parentList;

  NewItemForm({this.parentList});

  @override
  _NewItemFormState createState() => _NewItemFormState();
}

class _NewItemFormState extends State<NewItemForm> {

  _NewItemFormState();

  final formKey = GlobalKey<FormState>();
  final DatabaseManager db = DatabaseManager();

  final itemFields = ItemDTO();

  String validateStringInput(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    } else return null;
  }

  void saveItem(BuildContext context) async {
    final formState = formKey.currentState;

    if (formState.validate()) {
      formKey.currentState.save();

      itemFields.date = Timestamp.fromDate(DateTime.now());
      itemFields.lastUpdated = Timestamp.fromDate(DateTime.now());
      itemFields.addedBy = "TILCode";
      itemFields.subsOk = true;
      itemFields.substitutions = new List<String>();
      itemFields.private = false;
      itemFields.quantity = 1;
      itemFields.urgent = false;
      itemFields.isCrossedOff = false;
      itemFields.listPositions ={'default':widget.parentList.totalItems+1};

      var docRef = await db.createItem(widget.parentList.id, itemFields);

      Navigator.of(context).pop(docRef);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
                autofocus: true,
                initialValue: '',
                decoration: InputDecoration(
                    labelText: 'Item name',
                    border: OutlineInputBorder()
                ),
                validator: (value) => validateStringInput(value),
                onSaved: (value) {
                  itemFields.name = value;
                }
            ),
          ),
          Text("Adding to: " + widget.parentList.name),
          RaisedButton(
            onPressed: () => saveItem(context),
            child: Text('Save item'),
          ),
        ],
      ),
    );
  }
}