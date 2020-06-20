import 'package:flutter/material.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/shopping_list_dto.dart';

class NewShoppingList extends StatefulWidget {

  static const routeName = '/newShoppingList';

  NewShoppingList({Key key});

  @override
  _NewShoppingListState createState() => _NewShoppingListState();
}

class _NewShoppingListState extends State<NewShoppingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new shopping list"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: AddShoppingListForm(),
        ),
      ),
    );
  }
}

class AddShoppingListForm extends StatefulWidget {
  @override
  _AddShoppingListFormState createState() => _AddShoppingListFormState();
}

class _AddShoppingListFormState extends State<AddShoppingListForm> {
  final formKey = GlobalKey<FormState>();

  final DatabaseManager db = DatabaseManager();

  final newShoppingListFields = ShoppingListDTO();

  String validateStringInput(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    } else return null;
  }

  void saveNewList(BuildContext context) {
    final formState = formKey.currentState;
    if (formState.validate()) {
      // save the form
      formKey.currentState.save();
      // this data is auto-generated when a new list is made
      newShoppingListFields.date = DateTime.now().toString();
      newShoppingListFields.itemIDs = new List<String>();
      // put this stuff in the db
      db.addShoppingList(newShoppingListFields);
      // confirm with a snack bar
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('New list created: ' + newShoppingListFields.name))
      );
      // go back to main view
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Shopping list name',
                  border: OutlineInputBorder()
              ),
              validator: (value) => validateStringInput(value),
              onSaved: (value) {
                newShoppingListFields.name = value;
              }
          ),
          RaisedButton(
            onPressed: () => saveNewList(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}