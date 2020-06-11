class Item {
  final String id;
  final String name;
  final int quantity;
  final bool subsOk;
  final List<String> substitutions;
  final String addedBy;
  final String lastUpdated;
  final bool private;
  final bool urgent;

  Item({
    this.id,
    this.name,
    this.quantity,
    this.subsOk,
    this.substitutions,
    this.addedBy,
    this.lastUpdated,
    this.private,
    this.urgent,
  });


}