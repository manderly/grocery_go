import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDTO {

  String id;
  String name;
  Timestamp date;
  int quantity;
  bool subsOk;
  List substitutions;
  String addedBy;
  Timestamp lastUpdated;
  bool private;
  bool urgent;
  bool isCrossedOff;
  Map listPositions;

  String toString() {
    return 'id: $id, name: $name, date: $date, '
        'quantity: $quantity, subsOk: $subsOk, substitutions: $substitutions, '
        'addedBy: $addedBy, lastUpdated: $lastUpdated, private: $private, urgent: $urgent, isCrossedOff: $isCrossedOff, listPositions: $listPositions';
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'id': this.id,
    'name': this.name,
    'date': this.date,
    'quantity': this.quantity,
    'subsOk': this.subsOk,
    'substitutions': this.substitutions,
    'addedBy': this.addedBy,
    'lastUpdated': this.lastUpdated,
    'private': this.private,
    'urgent':this.urgent,
    'isCrossedOff':this.isCrossedOff,
    'listPositions':this.listPositions,
  };
}