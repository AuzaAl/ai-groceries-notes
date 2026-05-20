import 'package:flutter/material.dart';

class GroceryItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final String category;
  final String? notes;
  final bool isChecked;
  final DateTime addedAt;
  final String source; // "ai" | "manual" | "recipe"

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    this.notes,
    this.isChecked = false,
    required this.addedAt,
    required this.source,
  });

  GroceryItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    String? category,
    String? notes,
    bool? isChecked,
    DateTime? addedAt,
    String? source,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      isChecked: isChecked ?? this.isChecked,
      addedAt: addedAt ?? this.addedAt,
      source: source ?? this.source,
    );
  }
}
