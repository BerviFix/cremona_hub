import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:cremona_hub/models/news_model.dart';

class NewsListRepository {
  Future<List<NewsModel>> getNewsList() async {
    final random = Random();
    final int randomNumber = random.nextInt(50) + 50;

    try {
      final response = await http.get(Uri.parse(
          'https://www.cremonaoggi.it/wp-json/wp/v2/posts?per_page=$randomNumber'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        List<NewsModel> newsList =
            (jsonData as List).map((json) => NewsModel.fromJson(json)).toList();

        return newsList;
      } else {
        throw Exception('Failed to load news list');
      }
    } catch (e) {
      print('Failed to load news list: $e');
      // Handle the exception as needed
      return []; // Return an empty list on exception
    }
  }
}
