import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_data.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addItem() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewItem()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItem.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(groceryItem[index].name),
          trailing: Text('${groceryItem[index].quantity}'),
          leading: Container(
            height: 24,
            width: 24,
            color: groceryItem[index].category.categoryColor,
          ),
        ),
      ),
    );
  }
}
