import 'package:flutter/material.dart';
import 'package:grocery_go/components/linked_entities_list.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/store_dto.dart';

class StoreForm extends StatefulWidget {
  final args;

  StoreForm({this.args});

  @override
  _StoreFormState createState() => _StoreFormState(args);
}

class _StoreFormState extends State<StoreForm> {

  final args;
  _StoreFormState(this.args);

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

      if (args != null) {
        storeFields.id = args.store.id;
        await db.updateStore(args.store.id, storeFields);
      } else {
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: TextFormField(
                autofocus: true,
                initialValue: (args?.store?.name),
                decoration: InputDecoration(
                    labelText: 'Store name',
                    border: OutlineInputBorder()
                ),
                validator: (value) => validateStringInput(value),
                onSaved: (value) {
                  storeFields.name = value;
                }
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Column(
              children: [
                TextFormField(
                    autofocus: false,
                    initialValue: (args?.store?.address),
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
          ),
          LinkedEntitiesList(args?.store?.shoppingLists, "store", "Shopping Lists"),
        ],
      ),
    );
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