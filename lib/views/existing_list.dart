import 'package:flutter/material.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/shopping_list_dto.dart';
import 'package:grocery_go/models/shopping_list.dart';

class ExistingListArguments {
  final ShoppingList list;
  ExistingListArguments(this.list);
}

class ExistingList extends StatefulWidget {
  static const routeName = '/existingList';
  ExistingList({Key key});

  @override
  _ExistingListState createState() => _ExistingListState();
}

class _ExistingListState extends State<ExistingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit shopping list"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: UpdateShoppingListForm(),
        ),
      ),
    );
  }
}

class UpdateShoppingListForm extends StatefulWidget {
  @override
  _UpdateShoppingListFormState createState() => _UpdateShoppingListFormState();
}

class _UpdateShoppingListFormState extends State<UpdateShoppingListForm> {
  final formKey = GlobalKey<FormState>();
  final DatabaseManager db = DatabaseManager();

  final updateShoppingListFields = ShoppingListDTO();

  String validateStringInput(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    } else return null;
  }

  void updateList(BuildContext context, list) async {
    final formState = formKey.currentState;

    if (formState.validate()) {
      formKey.currentState.save();

      // take the existing data
      updateShoppingListFields.id = list.id;
      updateShoppingListFields.itemIDs = list.itemIDs;
      // update the last edited date
      updateShoppingListFields.date = DateTime.now().toString();
      await db.updateShoppingList(list.id, updateShoppingListFields);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {

    final ExistingListArguments args = ModalRoute.of(context).settings.arguments;

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            autofocus: true,
            initialValue: args.list.name,
            decoration: InputDecoration(
                labelText: 'List name',
                border: OutlineInputBorder()
            ),
            validator: (value) => validateStringInput(value),
            onSaved: (value) {
              updateShoppingListFields.name = value;
            }
          ),
          RaisedButton(
            onPressed: () => updateList(context, args.list),
            child: Text('Update list'),
          ),
        ],
      ),
    );
  }
}