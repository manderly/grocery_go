import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListItem extends StatelessWidget {

  final item;
  final listType;
  final count;
  final onTap;
  final onInfoTap;

  ListItem({Key key, @required this.item, this.listType, this.count, this.onTap, this.onInfoTap});

  buildDateString(date) {
    return DateFormat.yMMMd().format(DateTime.parse(date));
  }

  buildCrossedOffDate(date) {
    var difference = new DateTime.now().difference(DateTime.parse(date));
    var howLongAgo = DateTime.now().subtract(difference);

    return (timeago.format(howLongAgo).toString());
  }

  buildTitleString() {
    if (listType == 'item') {
      return item.name + (item.quantity > 1 ? ' (' + item.quantity.toString() + ')' : '');
    } else {  // crossed off, shopping list, store
      return item.name;
    }
  }

  buildSubtitleString() {
    if (listType == 'shopping list') {
      return this.count.toString() + ' item' + (this.count == 1 ? '' : 's');
    } else if (listType == 'store') {
      return item.address;
    } else if (listType == 'item') {
      return 'Added by ' + item.addedBy + ' on ' + buildDateString(item.lastUpdated);
    } else if (listType == 'crossedOff') {
      return '' + buildCrossedOffDate(item.lastUpdated) + ' at storeName';
    } else {
      return "cannot build subtitle";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(buildTitleString(), style: (listType == 'crossedOff' ? TextStyle(decoration: TextDecoration.lineThrough) : TextStyle(decoration: TextDecoration.none))),
      subtitle: Text(buildSubtitleString()),
      leading: FlutterLogo(),
      trailing: IconButton(
        icon: Icon(Icons.info),
        onPressed: () => onInfoTap(item),
      ),
      onTap: () => onTap(item), //handleTap(context),
    );
  }
}