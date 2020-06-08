class Item {
  final String id;
  final String name;
  final int quantity;
  final bool subsOk;
  final List<String> substitutions;
  final String addedBy;
  final String lastUpdated;

  Item({
    this.id,
    this.name,
    this.quantity,
    this.subsOk,
    this.substitutions,
    this.addedBy,
    this.lastUpdated
  });
}