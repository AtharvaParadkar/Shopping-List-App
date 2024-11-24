import 'package:flutter/material.dart';

class NewItem extends StatelessWidget {
  const NewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(child: Column(children: [
          TextFormField(
            maxLength: 50,
            decoration: InputDecoration(
              label: Text('Name'),
            ),
            validator: (value){
              return '...';
            },
          ),
        ],),),
      ),
    );
  }
}
