import 'package:flutter/material.dart';
import 'package:grocery_go/forms/components/linked_entities_list.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/store_dto.dart';
import 'package:grocery_go/models/store.dart';

class StoreForm extends StatefulWidget {
  final Store store;

  StoreForm({this.store});

  @override
  _StoreFormState createState() => _StoreFormState();
}

class _StoreFormState extends State<StoreForm> {

  _StoreFormState();

  final formKey = GlobalKey<FormState>();
  final DatabaseManager db = DatabaseManager();

  final storeFields = StoreDTO();

  String validateStringInput(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    } else return null;
  }

  void updateStore(BuildContext context) async {
    final formState = formKey.currentState;

    if (formState.validate()) {
      formKey.currentState.save();
      storeFields.date = DateTime.now().toString();

      if (widget.store != null) {
        storeFields.id = widget.store.id;
        storeFields.shoppingLists = widget.store.shoppingLists;
        await db.updateStore(widget.store.id, storeFields);
      } else {
        storeFields.shoppingLists = Map();
        await db.addStore(storeFields);
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
          ]
        )
      )
    );
  }

  _formFields() {
    List<Widget> fields = [_nameField(), _addressField()];
    // if we're editing an existing store, add the linked shopping lists
    if (widget.store?.id != null) {
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
          initialValue: widget.store?.name ?? '',
          decoration: InputDecoration(
              labelText: 'Store name',
              border: OutlineInputBorder()
          ),
          validator: (value) => validateStringInput(value),
          onSaved: (value) {
            storeFields.name = value;
          }
      ),
    );
  }

  _addressField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        children: [
          TextFormField(
              autofocus: false,
              initialValue: widget.store?.address ?? '',
              decoration: InputDecoration(
                  labelText: 'Location (optional)',
                  border: OutlineInputBorder()
              ),
              validator: (value) => validateStringInput(value),
              onSaved: (value) {
                storeFields.address = value;
              }
          ),
        ],
      ),
    );
  }

  _linkedEntities() {
    return LinkedEntitiesList(
        widget.store.id, "store", widget.store.name, widget.store.shoppingLists, "Shopping Lists");
  }

  _saveButton() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () => updateStore(context),
            child: Text('Save store'),
          ),
        ]
      ),
    );
  }
}