import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _addItem() async {
    final newItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(builder: (_) => const NewItem()),
    );
    // _loadItems();
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _loadItems() async {
    final url = Uri.https(
      'shopping-list-app-ee5cb-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );
    final response = await http.get(url);
    debugPrint('${response.statusCode}');

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data. Please try again later.';
      });
    }

    debugPrint(response.body);

    final Map<String, dynamic> data = json.decode(response.body);

    final List<GroceryItem> loadedItems = [];
    for (final item in data.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
  }

  void _removeItem(GroceryItem removedItem) async {
    final index = _groceryItems.indexOf(removedItem);

    setState(() {
      _groceryItems.remove(removedItem);
    });

    final url = Uri.https(
      'shopping-list-app-ee5cb-default-rtdb.firebaseio.com',
      'shopping-list/${removedItem.id}.json',
    );

    final response = await http.delete(url);

    debugPrint('Delete code ${response.statusCode}');

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, removedItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('No Items to Show!'),
    );

    // if (_isLoading) {
    //   content = const Center(child: CircularProgressIndicator());
    // }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          child: ListTile(
            title: Text(_groceryItems[index].name),
            trailing: Text('${_groceryItems[index].quantity}'),
            leading: Container(
              height: 24,
              width: 24,
              color: _groceryItems[index].category.categoryColor,
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }

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
      body: content,
    );
  }
}
