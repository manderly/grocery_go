import 'package:flutter/material.dart';

class LinkedEntitiesList extends StatelessWidget {
  final linkedEntities;

  LinkedEntitiesList(this.linkedEntities);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: linkedEntities.entries.map<Widget>((entry) {
          var w = Text(entry.value);
          return w;
      }).toList()),
    );
  }
}