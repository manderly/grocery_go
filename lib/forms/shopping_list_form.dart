import 'package:flutter/material.dart';
import 'package:grocery_go/forms/components/linked_entities_list.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/shopping_list_dto.dart';
import 'package:grocery_go/models/shopping_list.dart';

class ShoppingListForm extends StatefulWidget {
  final ShoppingList shoppingList; // see model for full list of properties

  ShoppingListForm({this.shoppingList});

  @override
  _ShoppingListFormState createState() => _ShoppingListFormState();
}

class _ShoppingListFormState extends State<ShoppingListForm> {

  _ShoppingListFormState();

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

      if (widget.shoppingList != null) {
        // preserve existing data from args
        shoppingListFields.id = widget.shoppingList.id;
        shoppingListFields.stores = widget.shoppingList.stores;
        await db.updateShoppingList(widget.shoppingList.id, shoppingListFields);
      } else {
        // creating a new shopping list
        shoppingListFields.stores = Map();
        shoppingListFields.listPositions = Map();
        shoppingListFields.listPositions['default'] = 1000;
        await db.addShoppingList(shoppingListFields);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _formFields(),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  _formFields() {
    List<Widget> fields = [_nameField()];
    // if we're editing an existing shopping list, add the linked stores
    if (widget.shoppingList?.id != null) {
      fields.add(_linkedEntities());
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fields,
      ),
    );
  }

  _nameField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: TextFormField(
          autofocus: true,
          initialValue: widget.shoppingList?.name ?? '',
          decoration: InputDecoration(
              labelText: 'List name',
              border: OutlineInputBorder()
          ),
          validator: (value) => validateStringInput(value),
          onSaved: (value) {
            shoppingListFields.name = value;
          }
      ),
    );
  }

  _linkedEntities() {
    return LinkedEntitiesList(
        widget.shoppingList.id, "shopping list", widget.shoppingList.name, widget.shoppingList.stores, "Stores");
  }

  _saveButton() {
    return Expanded(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () => updateShoppingList(context),
            child: Text('Save shopping list'),
          ),
        ]
      ),
    );
  }
}