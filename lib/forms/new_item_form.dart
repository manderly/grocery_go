import 'package:flutter/material.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/item_dto.dart';

class NewItemForm extends StatefulWidget {
  final args;

  NewItemForm({this.args});

  @override
  _NewItemFormState createState() => _NewItemFormState(args);
}

class _NewItemFormState extends State<NewItemForm> {

  final args;
  _NewItemFormState(this.args);

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

    print(args);

    if (formState.validate()) {
      formKey.currentState.save();

      // the user doesn't have access to these params when they first
      // create an item, only when they edit it
      // set some defaults here
      // todo: can these just be defaults in the DTO?
      itemFields.date = DateTime.now().toString();
      itemFields.lastUpdated = DateTime.now().toString();
      itemFields.addedBy = "TILCode";
      itemFields.subsOk = true;
      itemFields.substitutions = new List<String>();
      itemFields.private = false;
      itemFields.quantity = 1;
      itemFields.urgent = false;

      var docRef = await db.createItem(args.parentListID, itemFields);

      //db.addItemToShoppingList(args.parentListID, docRef.documentID);

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
          Text("Adding to: " + args.parentListName),
          RaisedButton(
            onPressed: () => saveItem(context),
            child: Text('Save item'),
          ),
        ],
      ),
    );
  }
}