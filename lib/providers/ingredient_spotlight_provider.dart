import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class IngredientSpotlight {
  final String name;
  final String description;
  final String imageUrl;

  const IngredientSpotlight({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

/// Fetches the full ingredient list from TheMealDB, shuffles, returns 10.
final ingredientSpotlightProvider =
    FutureProvider<List<IngredientSpotlight>>((ref) async {
  const url =
      'https://www.themealdb.com/api/json/v1/1/list.php?i=list';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Gagal memuat daftar bahan: ${response.statusCode}');
  }

  final data = json.decode(response.body) as Map<String, dynamic>;
  final meals = (data['meals'] as List<dynamic>?) ?? [];

  final allIngredients = meals
      .map((m) {
        final name = (m['strIngredient'] as String?)?.trim() ?? '';
        final desc = (m['strDescription'] as String?)?.trim() ?? '';
        if (name.isEmpty) return null;
        final key = name.toLowerCase().replaceAll(' ', '_');
        return IngredientSpotlight(
          name: name,
          description: desc.isNotEmpty ? desc : 'Bahan makanan populer.',
          imageUrl:
              'https://www.themealdb.com/images/ingredients/$key.png/medium',
        );
      })
      .whereType<IngredientSpotlight>()
      .toList();

  // Shuffle and take 10
  allIngredients.shuffle(Random());
  return allIngredients.take(10).toList();
});
