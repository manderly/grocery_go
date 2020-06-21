class StoreDTO {

  String id;
  String name;
  String date;
  String address;

  String toString() {
    return 'id: $id, name: $name, date: $date, address: $address';
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'id': this.id ?? '',
    'name': this.name,
    'date': this.date,
    'address': this.address,
  };
}