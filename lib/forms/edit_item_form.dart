import 'package:flutter/material.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/item_dto.dart';

class EditItemForm extends StatefulWidget {
  final args;

  EditItemForm({this.args});

  @override
  _EditItemFormState createState() => _EditItemFormState(args);
}

class _EditItemFormState extends State<EditItemForm> {
  final args;
  _EditItemFormState(this.args);

  final formKey = GlobalKey<FormState>();
  final DatabaseManager db = DatabaseManager();

  final itemFields = ItemDTO();

  String validateStringInput(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    } else
      return null;
  }

  void saveItem(BuildContext context) async {
    final formState = formKey.currentState;

    print(args);

    if (formState.validate()) {
      formKey.currentState.save();
      itemFields.lastUpdated = DateTime.now().toString();

      var docRef = await db.updateItem(args.parentListID, itemFields);

      Navigator.of(context).pop(docRef);
    }
  }

  void _increaseQuantity() {
    setState(() {
      itemFields.quantity++;
    });
  }

  void _decreaseQuantity() {
    if (itemFields.quantity > 1) {
      setState(() {
        itemFields.quantity--;
      });
    }
  }

  void changeCategory(item) {
    print("stub: open change item category page");
  }

  void _setSubsOk(value) {
    setState(() {
      itemFields.subsOk = value;
    });
  }

  void _setUrgency(value) {
    setState(() {
      itemFields.urgent = value;
    });
  }

  void _setPrivacy(value) {
    setState(() {
      itemFields.private = value;
    });
  }

  @override
  void initState() {
    print(args.item.date.toString());
    itemFields.id = args.item.id;
    itemFields.name = args.item.name;
    itemFields.addedBy = args.item.addedBy;
    itemFields.date = args.item.date;
    itemFields.quantity = args.item.quantity;
    itemFields.subsOk = args.item.subsOk;
    itemFields.private = args.item.private;
    itemFields.urgent = args.item.urgent;
    return super.initState();
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
                initialValue: args.item.name,
                decoration: InputDecoration(
                    labelText: 'Item name', border: OutlineInputBorder()),
                validator: (value) => validateStringInput(value),
                onSaved: (value) {
                  itemFields.name = value;
                }),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            RaisedButton(
              onPressed: _decreaseQuantity,
              child: Text('Fewer'),
            ),
            Spacer(flex: 1),
            RaisedButton(
              onPressed: _increaseQuantity,
              child: Text('More'),
            ),
            Spacer(flex: 4),
            Text(itemFields.quantity.toString()),
            Spacer(flex: 2),
          ]),
          RaisedButton(
            onPressed: () => changeCategory(args.item),
            child: Text('Category: Uncategorized'),
          ),
          Row(
            children: [
              Checkbox(
                  value: itemFields.urgent,
                  onChanged: (bool value) => _setUrgency(value),
              ),
              Text("Urgent")
            ],
          ),
          Row(
            children: [
              Checkbox(
                  value: itemFields.private,
                  onChanged: (bool value) => _setPrivacy(value),
              ),
              Text("Private"),
            ],
          ),
          Row(children: [
            Checkbox(
                value: itemFields.subsOk,
                onChanged: (bool value) => _setSubsOk(value),
            ),
            Text("Ok to substitute"),
            Spacer(flex: 6),
            Text("Manage substitutes..."),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RaisedButton(
                onPressed: () => saveItem(context),
                child: Text('Save item'),
              ),
            ],
          ),
          Text("Item ID: " + args?.item?.id ?? 'no id'),
          Text("Owner: " + args?.item?.addedBy ?? 'no owner name'),
          Text("Parent list name: " + args?.parentListName ?? 'no parent list name'),
          Text("Parent list ID: " + args?.parentListID ?? 'no parent list ID')
        ],
      ),
    );
  }
}
