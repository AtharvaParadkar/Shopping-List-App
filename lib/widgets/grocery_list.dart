import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_data.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
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
