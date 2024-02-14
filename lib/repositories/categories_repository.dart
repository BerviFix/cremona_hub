import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cremona_hub/models/category_model.dart';

class CategoriesRepository {
  Future<List<CategoryModel>> getCategoriesList() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.cremonaoggi.it/wp-json/wp/v2/categories?per_page=100'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        List<CategoryModel> categoriesList = (jsonData as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();

        return categoriesList;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Failed to load categories: $e');
      // Handle the exception as needed
      return []; // Return an empty list on exception
    }
  }
}
