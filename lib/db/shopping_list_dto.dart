class ShoppingListDTO {

  String id;
  String name;
  String date;
  List itemIDs;

  String toString() {
    return 'id: $id, name: $name, date: $date, storeIDs: $itemIDs';
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'id': this.id ?? '',
    'name': this.name,
    'date': this.date,
    'itemIDs': this.itemIDs,
  };
}