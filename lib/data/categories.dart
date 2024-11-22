import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/categories.dart';

var categories = {
  Categories.vegetables: Category(
    title: 'Vegetables',
    color: const Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.fruit: Category(
    title: 'Fruits',
    color: const Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.meat: Category(
    title: 'Meat',
    color: const Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: Category(
    title: '',
    color: const Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: Category(
    title: '',
    color: const Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: Category(
    title: '',
    color: const Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: Category(
    title: '',
    color: const Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: Category(
    title: '',
    color: const Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.hygiene: Category(
    title: '',
    color: const Color.fromARGB(255, 149, 0, 255),
  ),
  Categories.other: Category(
    title: '',
    color: const Color.fromARGB(255, 0, 255, 255),
  ),
};
