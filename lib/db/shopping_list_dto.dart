class ShoppingListDTO {

  String id;
  String name;
  String date;
  int itemCount;

  String toString() {
    return 'id: $id, name: $name, date: $date, itemCount: $itemCount';
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'id': this.id ?? '',
    'name': this.name ?? 'unnamed item',
    'date': this.date,
    'itemCount': this.itemCount ?? 0,
  };
}