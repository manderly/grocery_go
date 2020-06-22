import 'package:flutter/material.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/store_dto.dart';
import 'package:grocery_go/models/store.dart';

class ExistingStoreArguments {
  final Store store;
  ExistingStoreArguments(this.store);
}

class ExistingStore extends StatefulWidget {
  static const routeName = '/existingStore';
  ExistingStore({Key key});

  @override
  _ExistingStoreState createState() => _ExistingStoreState();
}

class _ExistingStoreState extends State<ExistingStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit saved store"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: UpdateStoreForm(),
        ),
      ),
    );
  }
}

class UpdateStoreForm extends StatefulWidget {
  @override
  _UpdateStoreFormState createState() => _UpdateStoreFormState();
}

class _UpdateStoreFormState extends State<UpdateStoreForm> {
  final formKey = GlobalKey<FormState>();
  final DatabaseManager db = DatabaseManager();

  final updateStoreFields = StoreDTO();

  String validateStringInput(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    } else return null;
  }


  void updateStore(BuildContext context, store) async {
    final formState = formKey.currentState;

    if (formState.validate()) {
      formKey.currentState.save();
      updateStoreFields.id = store.id;
      // update the last edited date
      updateStoreFields.date = DateTime.now().toString();
      await db.updateStore(store.id, updateStoreFields);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {

    final ExistingStoreArguments args = ModalRoute.of(context).settings.arguments;

    return Form(
      key: formKey,
      child: Column(
        children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
              autofocus: true,
              initialValue: args.store.name,
              decoration: InputDecoration(
                  labelText: 'Store name',
                  border: OutlineInputBorder()
              ),
              validator: (value) => validateStringInput(value),
              onSaved: (value) {
                updateStoreFields.name = value;
              }
            ),
          ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
              autofocus: false,
              initialValue: args.store.address,
              decoration: InputDecoration(
                  labelText: 'Location (optional)',
                  border: OutlineInputBorder()
              ),
              validator: (value) => validateStringInput(value),
              onSaved: (value) {
                updateStoreFields.address = value;
              }
            ),
          ),
          RaisedButton(
            onPressed: () => updateStore(context, args.store),
            child: Text('Update store'),
          ),
        ],
      ),
    );
  }
}