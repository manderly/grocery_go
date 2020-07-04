import 'package:flutter/material.dart';
import 'package:grocery_go/components/toggle_list.dart';

class ManageLinksArguments {
  final dbStream;
  final linkedEntities;
  final String parentID;
  final String parentType;

  ManageLinksArguments({this.dbStream, this.linkedEntities, this.parentID, this.parentType});
}

class ManageLinks extends StatefulWidget {

  static const routeName = '/manageLinks';

  ManageLinks({Key key});

  @override
  _ManageLinks createState() => _ManageLinks();
}

class _ManageLinks extends State<ManageLinks> {

  @override
  Widget build(BuildContext context) {

    final ManageLinksArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add/Remove"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: StreamBuilder(
              stream: args.dbStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.hasData && !snapshot.data.documents.isEmpty) {
                  return ToggleList(parentType: args.parentType, parentID: args.parentID, list: snapshot.data.documents, linkedEntities: args.linkedEntities);
                } else {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("No entities yet!"),
                      ),
                    ],
                  );
                }
              }
            )
          ),
        ),
      ),
    );
  }
}