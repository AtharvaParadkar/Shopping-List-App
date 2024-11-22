import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/category.dart';

const categories = {
  Categories.vegetables: Category(
    'Vegetables',
    Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.fruit: Category(
    'Fruits',
    Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.meat: Category(
    'Meat',
    Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: Category(
    '',
    Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: Category(
    '',
    Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: Category(
    '',
    Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: Category(
    '',
    Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: Category(
    '',
    Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.hygiene: Category(
    '',
    Color.fromARGB(255, 149, 0, 255),
  ),
  Categories.other: Category(
    '',
    Color.fromARGB(255, 0, 255, 255),
  ),
};
