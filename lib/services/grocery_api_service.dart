import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/grocery_item.dart';

class GroceryApiService {
  // Local endpoint as requested. Note: Android emulator might need 10.0.2.2 instead of localhost.
  static const String baseUrl = 'http://localhost:3000/api/gemini';

  Future<List<GroceryItem>> extractIngredients(String url) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': url}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => GroceryItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load ingredients: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error extracting ingredients: $e');
    }
  }
}