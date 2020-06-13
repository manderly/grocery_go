class ShoppingList {
  final String id;
  final String name;
  final String listType = 'shopping list';
  final List itemIDs;

  ShoppingList({this.id, this.name, this.itemIDs});
}