import 'package:flutter/material.dart';

class DeleteAll extends StatelessWidget {

  deleteAll() {
    print("Stub: deleting all the crossed-off items");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text('Delete all crossed off items'),
        onTap: () => deleteAll()
    );
  }
}