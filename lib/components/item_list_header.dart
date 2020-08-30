import 'package:flutter/material.dart';

class ItemListHeader extends StatelessWidget {

  final String text;
  final String listType;
  final onManageListTap;

  ItemListHeader({Key key, @required this.text, @required this.listType, @required this.onManageListTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue[800],
        height: 40.0,
        child: Center(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                child: Text(text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 15.0, 5.0),
                child: IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () => onManageListTap(listType),
                ),
              ),
            ],
          ),
        ),
    );
  }
}