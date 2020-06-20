class ShoppingListDTO {

  String name;
  String date;
  List itemIDs;

  String toString() {
    return 'name: $name, date: $date, storeIDs: $itemIDs';
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'name': this.name,
    'date': this.date,
    'itemIDs': this.itemIDs,
  };
}