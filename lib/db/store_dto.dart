class StoreDTO {

  String id;
  String name;
  String date;
  String address;
  Map shoppingLists;

  String toString() {
    return 'id: $id, name: $name, date: $date, address: $address, shoppingLists: $shoppingLists';
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'id': this.id ?? '',
    'name': this.name,
    'date': this.date,
    'address': this.address,
    'shoppingLists': this.shoppingLists,
  };
}