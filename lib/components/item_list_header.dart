import 'package:flutter/material.dart';

class ItemListHeader extends StatelessWidget {

  final String text;

  ItemListHeader({Key key, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue[800],
        height: 30.0,
        child: Center(
            child: Text(text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                )
            )
        )
    );
  }
}