import 'package:flutter/material.dart';
import 'package:grocery_go/components/toggle_list.dart';

class ManageLinksArguments {
  final dbStream;
  final linkedEntities;
  final String parentID;
  final String parentName;
  final String parentType;

  ManageLinksArguments(this.dbStream, this.linkedEntities, this.parentID, this.parentName, this.parentType);
}

class ManageLinks extends StatefulWidget {

  static const routeName = '/manageLinks';

  final dbStream;
  final linkedEntities;
  final String parentID;
  final String parentName;
  final String parentType;
  ManageLinks({Key key, this.dbStream, this.linkedEntities, this.parentID, this.parentName, this.parentType});

  @override
  _ManageLinks createState() => _ManageLinks();
}

class _ManageLinks extends State<ManageLinks> {

  @override
  Widget build(BuildContext context) {

    //final ManageLinksArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add/Remove"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: StreamBuilder(
              stream: widget.dbStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.hasData && !snapshot.data.documents.isEmpty) {
                  return ToggleList(parentType: widget.parentType, parentID: widget.parentID, parentName: widget.parentName, list: snapshot.data.documents, linkedEntities: widget.linkedEntities);
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