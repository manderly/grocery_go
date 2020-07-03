import 'package:flutter/material.dart';
import 'package:grocery_go/components/linked_entities_list.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/shopping_list_dto.dart';

class ShoppingListForm extends StatefulWidget {
  final args;

  ShoppingListForm({this.args});

  @override
  _ShoppingListFormState createState() => _ShoppingListFormState(args);
}

class _ShoppingListFormState extends State<ShoppingListForm> {

  final args;
  _ShoppingListFormState(this.args);

  final formKey = GlobalKey<FormState>();
  final DatabaseManager db = DatabaseManager();

  final shoppingListFields = ShoppingListDTO();

  String validateStringInput(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    } else return null;
  }

  void updateShoppingList(BuildContext context) async {
    final formState = formKey.currentState;

    if (formState.validate()) {
      formKey.currentState.save();
      shoppingListFields.date = DateTime.now().toString();

      if (args != null) {
        // preserve existing data from args
        shoppingListFields.id = args.list.id;
        await db.updateShoppingList(args.list.id, shoppingListFields);
      } else {
        await db.addShoppingList(shoppingListFields);
      }

      Navigator.of(context).pop();
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
                initialValue: (args?.list?.name),
                decoration: InputDecoration(
                    labelText: 'List name',
                    border: OutlineInputBorder()
                ),
                validator: (value) => validateStringInput(value),
                onSaved: (value) {
                  shoppingListFields.name = value;
                }
            ),
          ),
          LinkedEntitiesList(args?.list?.stores, "shopping list", "Stores"),
          RaisedButton(
            onPressed: () => updateShoppingList(context),
            child: Text('Save shopping list'),
          ),
        ],
      ),
    );
  }
}