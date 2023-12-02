import 'package:flutter/material.dart';

class Resource {
  final String name;
  final Color color;
  final String description;
  int quantity;

  Resource({
    required this.name,
    required this.color,
    required this.description,
    this.quantity = 0,
  });
}
