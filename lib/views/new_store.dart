import 'package:flutter/material.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/store_dto.dart';

class NewStore extends StatefulWidget {

  static const routeName = '/newStore';

  NewStore({Key key});

  @override
  _NewStoreState createState() => _NewStoreState();
}

class _NewStoreState extends State<NewStore> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new store"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: AddStoreForm(),
        ),
      ),
    );
  }
}


class AddStoreForm extends StatefulWidget {
  @override
  _AddStoreFormState createState() => _AddStoreFormState();
}

class _AddStoreFormState extends State<AddStoreForm> {
  final formKey = GlobalKey<FormState>();
  final DatabaseManager db = DatabaseManager();

  final newStoreFields = StoreDTO();

  String validateStringInput(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    } else return null;
  }

  void saveNewStore(BuildContext context) async {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formKey.currentState.save();
      newStoreFields.date = DateTime.now().toString();
      await db.addStore(newStoreFields);
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('New list created: ' + newStoreFields.name))
      );
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
              decoration: InputDecoration(
                  labelText: 'Store name',
                  border: OutlineInputBorder()
              ),
              validator: (value) => validateStringInput(value),
              onSaved: (value) {
                newStoreFields.name = value;
              }
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                  labelText: 'Location (optional)',
                  border: OutlineInputBorder()
              ),
              onSaved: (value) {
                newStoreFields.address = value;
              }
            ),
          ),
          RaisedButton(
            onPressed: () => saveNewStore(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}