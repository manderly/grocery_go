class ItemDTO {

  String id;
  String name;
  String date;
  int quantity;
  bool subsOk;
  List substitutions;
  String addedBy;
  String lastUpdated;
  bool private;
  bool urgent;
  bool isCrossedOff;

  String toString() {
    return 'id: $id, name: $name, date: $date, '
        'quantity: $quantity, subsOk: $subsOk, substitutions: $substitutions, '
        'addedBy: $addedBy, lastUpdated: $lastUpdated, private: $private, urgent: $urgent, isCrossedOff: $isCrossedOff';
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
  };
}