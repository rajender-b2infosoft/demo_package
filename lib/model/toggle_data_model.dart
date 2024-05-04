import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category {
  final int id;
   String title;
  final String name;
   bool value;
  final String description;

  Category({
    required this.id,
    required this.title,
    required this.name,
    required this.value,
    required this.description,
  });

  @override
  String toString() {
    return 'Category{id: $id, title: $title, name: $name, value: $value, description: $description}';
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      title: json['title'] as String,
      name: json['name'] as String,
      value: json['value'] as bool,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'value': value,
      'description': description,
    };
  }
}