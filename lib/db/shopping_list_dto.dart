class ShoppingListDTO {

  String id;
  String name;
  String date;
  int activeItems;
  int totalItems;
  Map stores;

  String toString() {
    return 'id: $id, name: $name, date: $date, activeItems: $activeItems, totalItems: $totalItems, stores: $stores';
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'id': this.id ?? '',
    'name': this.name ?? 'unnamed item',
    'date': this.date,
    'activeItems': this.activeItems ?? 0,
    'totalItems': this.totalItems ?? 0,
    'stores': this.stores,
  };
}