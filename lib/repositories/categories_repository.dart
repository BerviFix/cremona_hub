import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cremona_hub/models/category_model.dart';

class CategoriesRepository {
  Future<List<CategoryModel>> getCategoriesList() async {
    final response = await http
        .get(Uri.parse('https://www.cremonaoggi.it/wp-json/wp/v2/categories'));

    final jsonData = jsonDecode(response.body);

    List<CategoryModel> categoriesList =
        (jsonData as List).map((json) => CategoryModel.fromJson(json)).toList();

    return categoriesList;
  }
}
