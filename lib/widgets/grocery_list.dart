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

    try {
      final response = await http.get(url);
      debugPrint('${response.statusCode}');

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }

      debugPrint(response.body);

      //? when response.body is null the firebase returns the string 'null' and some backends return '' and some others may return status code
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

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
    } catch (error) {
      debugPrint('$error');
      setState(() {
        _error = 'Something went wrong. Please try again later.';
      });
    }
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

//! The FutureBuilder is displaying data fetched asynchronously from Firebase using snapshot.data!. 

//? When we add an Item, the _addItem is called which adds the item to the _groceryItems and also sends request to firebase, and rebuilds the state. 
//~ This happens because we load items once in initState using _loadedItems = _loadItems();. The FutureBuilder uses _loadedItems as its future, which does not re-run when new items are added. When you navigate back after adding an item, the UI does not rebuild the future to fetch the updated list. Therefore, the newly added item does not appear until the app restarts.

//? And also when we swipe to delete an item the onDissmiss handler calls _removeItem which removes the item from _groceryItems and rebuils the state. And sends the request to delete the Item.
//~ This happens because the snapshot.data! still includes the remove item because the FutureBuilder does not automatically know that the data has automatically changed. This can create a mismatch between the ui and backend.


//! So for this app where the items are dynamically added and removed we should avoid the use of FutureBuilder.


//! FutureBuilder 
//! Pros
//? Simple to use for fetching data once from a server or database. Automatically handles loading, error, and success states with a clean API. Great for static data or situations where the data doesn't frequently change. 
//! Cons
//? Not suitable for dynamic lists where items are frequently added, removed, or updated because FutureBuilder doesn't automatically re-trigger when changes happen. If you reload the future (as we did in _addItem), it fetches all data from the backend again, which can be inefficient. Not ideal if you want immediate UI updates without waiting for a backend refresh.

// class _GroceryListState extends State<GroceryList> {
//   List<GroceryItem> _groceryItems = [];
//   late Future<List<GroceryItem>> _loadedItems;

//   @override
//   void initState() {
//     super.initState();
//     _loadedItems = _loadItems();
//   }

//   void _addItem() async {
//     final newItem = await Navigator.push<GroceryItem>(
//       context,
//       MaterialPageRoute(builder: (_) => const NewItem()),
//     );
//     // _loadItems();
//     if (newItem == null) {
//       return;
//     }
//     setState(() {
//       _groceryItems.add(newItem);
//       _loadedItems = _loadItems(); // Reload the future to refresh data
//     });
//   }

//   Future<List<GroceryItem>> _loadItems() async {
//     final url = Uri.https(
//       'shopping-list-app-ee5cb-default-rtdb.firebaseio.com',
//       'shopping-list.json',
//     );

//     final response = await http.get(url);
//     debugPrint('${response.statusCode}');

//     if (response.statusCode >= 400) {
//       throw Exception('Failed to fetch Grocery Items');
//     }

//     debugPrint(response.body);

//     //? when response.body is null the firebase returns the string 'null' and some backends return '' and some others may return status code
//     if (response.body == 'null') {
//       return [];
//     }

//     final Map<String, dynamic> data = json.decode(response.body);

//     final List<GroceryItem> loadedItems = [];

//     for (final item in data.entries) {
//       final category = categories.entries
//           .firstWhere(
//               (catItem) => catItem.value.title == item.value['category'])
//           .value;
//       loadedItems.add(
//         GroceryItem(
//           id: item.key,
//           name: item.value['name'],
//           quantity: item.value['quantity'],
//           category: category,
//         ),
//       );
//     }
//     return loadedItems;
//   }

//   void _removeItem(GroceryItem removedItem) async {
//     final index = _groceryItems.indexOf(removedItem);

//     setState(() {
//       _groceryItems.remove(removedItem);
//       _loadedItems = _loadItems(); // Reload the future to refresh data
//     });

//     final url = Uri.https(
//       'shopping-list-app-ee5cb-default-rtdb.firebaseio.com',
//       'shopping-list/${removedItem.id}.json',
//     );

//     final response = await http.delete(url);

//     debugPrint('Delete code ${response.statusCode}');

//     if (response.statusCode >= 400) {
//       setState(() {
//         _groceryItems.insert(index, removedItem);
//       });
//     setState(() {
//       _loadedItems = _loadItems(); // Reload the future to refresh data
//     });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Grocery List'),
//         actions: [
//           IconButton(
//             onPressed: _addItem,
//             icon: const Icon(Icons.add),
//           )
//         ],
//       ),
//       body: FutureBuilder(
//         future: _loadedItems,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('${snapshot.error}'),
//             );
//           }
//           if (snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text('No Items to Show!'),
//             );
//           }

//           //? _groceryItems is a regular list you are using locally to keep track of items in the _addItem and _removeItem methods.
//           //~ snapshot.data comes from the FutureBuilder and contains the most recent data retrieved asynchronously (from _loadItems()).
//           //? If you use _groceryItems inside the FutureBuilder, it will not reflect the data loaded asynchronously because _groceryItems is not updated when _loadItems() completes. snapshot.data ensures that the UI displays the correct list fetched from Firebase.

//           return ListView.builder(
//             // itemCount: _groceryItems.length,
//             itemCount: snapshot.data!.length,
//             itemBuilder: (ctx, index) => Dismissible(
//               key: ValueKey(snapshot.data![index].id),
//               onDismissed: (direction) {
//                 _removeItem(snapshot.data![index]);
//               },
//               child: ListTile(
//                 title: Text(snapshot.data![index].name),
//                 trailing: Text('${snapshot.data![index].quantity}'),
//                 leading: Container(
//                   height: 24,
//                   width: 24,
//                   color: snapshot.data![index].category.categoryColor,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
